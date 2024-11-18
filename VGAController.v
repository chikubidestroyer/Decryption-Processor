`timescale 1 ns/ 100 ps
module VGAController(     
    input clk,             // 100 MHz System Clock
    input reset,           // Reset Signal
    // Processor interface
    input [31:0] proc_addr,       // Address from processor
    input [31:0] proc_data,       // Data from processor
    input proc_we,                // Write enable from processor
    output [7:0] keyboard_data,   // Data to processor
    output keyboard_data_ready,   // Signal to processor
    // VGA outputs
    output hSync,          // H Sync Signal
    output vSync,          // Vertical Sync Signal
    output[3:0] VGA_R,    // Red Signal Bits
    output[3:0] VGA_G,    // Green Signal Bits
    output[3:0] VGA_B,    // Blue Signal Bits
    // PS/2 interface
    inout ps2_clk,
    inout ps2_data
);
    
    // Lab Memory Files Location
    localparam FILES_PATH = "./"; //change for pc

    // Clock divider 100 MHz -> 25 MHz
    wire clk25; // 25MHz clock
    reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
    
    always @(posedge clk) begin
        pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
    end

    // VGA Timing Generation for a Standard VGA Screen
    localparam 
        VIDEO_WIDTH = 640,  // Standard VGA Width
        VIDEO_HEIGHT = 480; // Standard VGA Height

    wire active, screenEnd;
    wire[9:0] x;
    wire[8:0] y;
    
    VGATimingGenerator #(
        .HEIGHT(VIDEO_HEIGHT),
        .WIDTH(VIDEO_WIDTH))
    Display( 
        .clk25(clk25),       // 25MHz Pixel Clock
        .reset(reset),       // Reset Signal
        .screenEnd(screenEnd), // High for one cycle when between two frames
        .active(active),     // High when drawing pixels
        .hSync(hSync),       // Set Generated H Signal
        .vSync(vSync),       // Set Generated V Signal
        .x(x),               // X Coordinate (from left)
        .y(y)                // Y Coordinate (from top)
    );

    // Image Data to Map Pixel Location to Color Address
    localparam 
        PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT,              // Number of pixels on the screen
        PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,      // Use built in log2 command
        BITS_PER_COLOR = 12,                                // Nexys A7 uses 12 bits/color
        PALETTE_COLOR_COUNT = 256,                          // Number of Colors available
        PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

    wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;   // Image address for the image data
    wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr;  // Color address for the color palette
    assign imgAddress = x + 640*y;              // Address calculated coordinate

    // Memory-mapped registers
    reg [7:0] display_char;
    reg [9:0] x_pos;
    reg [8:0] y_pos;
    
    // Memory map addresses
    localparam CHAR_ADDR = 32'h2000;
    localparam X_POS_ADDR = 32'h2004;
    localparam Y_POS_ADDR = 32'h2008;
    
    // Handle processor writes
    always @(posedge clk) begin
        if (reset) begin
            x_pos <= 150;
            y_pos <= 150;
            display_char <= 8'h20; // Space
        end
        else if (proc_we) begin
            case (proc_addr)
                CHAR_ADDR: display_char <= proc_data[7:0];
                X_POS_ADDR: x_pos <= proc_data[9:0];
                Y_POS_ADDR: y_pos <= proc_data[8:0];
            endcase
        end
    end

    RAM #(        
        .DEPTH(PIXEL_COUNT),                     // Set RAM depth to contain every pixel
        .DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
        .ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
        .MEMFILE({FILES_PATH, "image.mem"}))     // Memory initialization
    ImageData(
        .clk(clk),                    // Falling edge of the 100 MHz clk
        .addr(imgAddress),            // Image data address
        .dataOut(colorAddr),          // Color palette address
        .wEn(1'b0)                    // We're always reading
    );

    // Color Palette to Map Color Address to 12-Bit Color
    wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel

    RAM #(
        .DEPTH(PALETTE_COLOR_COUNT),           // Set depth to contain every color        
        .DATA_WIDTH(BITS_PER_COLOR),          // Set data width according to the bits per color
        .ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH), // Set address width according to the color count
        .MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
    ColorPalette(
        .clk(clk),                           // Rising edge of the 100 MHz clk
        .addr(colorAddr),                    // Address from the ImageData RAM
        .dataOut(colorData),                 // Color at current pixel
        .wEn(1'b0)                          // We're always reading
    );
    
    // PS/2 Keyboard Interface
    wire [7:0] rx_data;
    wire read_data, busy, err;
    
    Ps2Interface keyboard(
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .clk(clk),
        .rst(reset),
        .rx_data(rx_data),
        .read_data(read_data),
        .busy(busy),
        .err(err),
        .tx_data(8'h00),      // We're not sending data to keyboard
        .write_data(1'b0)     // We're not writing to keyboard
    );

    // Connect PS/2 interface to processor outputs
    assign keyboard_data = rx_data;
    assign keyboard_data_ready = read_data;

    // Sprite lookup for character display
    wire onOff;
    RAM #(
        .DEPTH(94*2500),         // Set depth to contain every sprite
        .DATA_WIDTH(1),          // Each pixel is 1 bit (on/off)
        .ADDRESS_WIDTH(18),      // Address width for all sprites
        .MEMFILE({FILES_PATH, "sprites.mem"}))  // Memory initialization
    SpriteLookUp(
        .clk(clk),
        .addr((display_char-33)*2500 + 50*(y-y_pos) + (x-x_pos)), // Calculate sprite address
        .dataOut(onOff),
        .wEn(1'b0)
    );

    // Color output logic
    wire[11:0] colorOut;
    // Display white background, black text when within character bounds
    assign colorOut = active ? 
                     ((x >= x_pos) && (x < x_pos + 50) && (y >= y_pos) && (y < y_pos + 50)) ?
                     (onOff ? 12'h000 : 12'hFFF) : // Black text on white background for character
                     12'hFFF :                      // White background elsewhere
                     12'h000;                       // Black during blanking

    // Assign final RGB outputs
    assign {VGA_R, VGA_G, VGA_B} = colorOut;

endmodule