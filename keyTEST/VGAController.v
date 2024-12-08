`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	input BTNU, BTND, BTNL, BTNR,
	output[15:0] LED,
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data);
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/chena/keytest/";

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
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   

	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel

	RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	

	// Character buffer parameters
	localparam BUFFER_WIDTH = 12;  // 12 char per row 
	localparam BUFFER_HEIGHT = 9; // 9 rows in total
	localparam CHAR_WIDTH = 50;   
	localparam CHAR_HEIGHT = 50;   
	
	// Character buffer to store ASCII codes
	reg [7:0] char_buffer [0:BUFFER_WIDTH*BUFFER_HEIGHT-1];
	
	// Calculate position within the current character
	wire [5:0] x_within_char = x % CHAR_WIDTH;
	wire [5:0] y_within_char = y % CHAR_HEIGHT;
	
		wire onOff;
		wire [7:0] rx_data;
		reg [7:0] key_id;
		wire read_data, busy, err;
		wire [7:0] output_ascii;

	// Modified color output
	wire[BITS_PER_COLOR-1:0] colorOut;
	
	// Initialize buffer with spaces
	integer i;
	initial begin
		for (i = 0; i < BUFFER_WIDTH*BUFFER_HEIGHT; i = i + 1) begin
			char_buffer[i] = 8'h20; // ASCII space
		end
	end
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
		Ps2Interface interface(
			.ps2_clk(ps2_clk),
			.ps2_data(ps2_data),
			.clk(clk),
			.rx_data(rx_data),
			.read_data(read_data),
			.busy(busy),
			.err(err)
		);
		always @(posedge clk) begin
			if (read_data && !err) begin  // Only update when we have valid data
				key_id <= rx_data;
			end
		end
	
	// ASCII lookup RAM instantiation
	RAM #(
		.DEPTH(256),         
		.DATA_WIDTH(8),      
		.ADDRESS_WIDTH(8),    
		.MEMFILE({FILES_PATH, "ascii.mem"}))  
	AsciiLookUp(
		.clk(clk),                           
		.addr(key_id),                    // Using key_id as address
		.dataOut(output_ascii),           // ASCII output
		.wEn(1'b0)); 

	// Handle keyboard input
	reg [7:0] next_write_index = 0;
	// Simple flag to detect key press
	reg received_f0;  // Flag to track if we got F0
	reg [1:0] write_state;
	localparam IDLE = 2'b00;
	localparam WAIT_ASCII = 2'b01;
	localparam DO_WRITE = 2'b10;

	always @(posedge clk) begin
		if (read_data && !err) begin
			if (rx_data == 8'hF0) begin  // Break code prefix
				received_f0 <= 1;
			end
			else begin
				if (!received_f0) begin  // Only process if not a break code
					write_state <= WAIT_ASCII;
				end
				received_f0 <= 0;  // Reset flag
			end
		end
		
		case (write_state)
			IDLE: begin
				// Already handled in the code above
			end
			
			WAIT_ASCII: begin
				// Wait one cycle for ASCII lookup to complete
				write_state <= DO_WRITE;
			end
			
			DO_WRITE: begin
				if (output_ascii != 8'h00) begin  // Valid character
					char_buffer[next_write_index] <= output_ascii;
					if (next_write_index < BUFFER_WIDTH * BUFFER_HEIGHT - 1) begin
						next_write_index <= next_write_index + 1;
					end
					else begin
						next_write_index <= 0;
					end
				end
				write_state <= IDLE;
			end
			
			default: write_state <= IDLE;
		endcase
	end

	reg [4:0] shiftamt;
	reg prevBTN;
	always@(posedge clk) begin
		prevBTN <= BTNU;
		if(shiftamt >= 26) begin
			shiftamt <= 0;
		end
		else if(BTNU && !prevBTN) begin
			shiftamt <= shiftamt + 1;
		end
	end
	//assign LED[4:0] = shiftamt;


	// Sprite lookup address calculation
	wire [17:0] sprite_addr, char_offset;
	wire [11:0] char_index = (y/50) * BUFFER_WIDTH + (x/50);
	assign char_offset = ({24'b0, char_buffer[char_index]}-8'd33);
	assign sprite_addr = (char_offset*2500)+(50*y_within_char + x_within_char);

	assign colorOut = active ? 
					 (x < (BUFFER_WIDTH * CHAR_WIDTH) && y < (BUFFER_HEIGHT * CHAR_HEIGHT) ?
					   (onOff ? colorData : 12'hfff) : 12'hfff) : 12'd0;

	// Modify sprite lookup to use the buffer
	RAM #(
		.DEPTH(94*2500),
		.DATA_WIDTH(1),
		.ADDRESS_WIDTH(18),
		.MEMFILE({FILES_PATH, "sprites.mem"}))
	SpriteLookUp(
		.clk(clk),
		.addr(sprite_addr),
		.dataOut(onOff),
		.wEn(1'b0));

	// Add state machine for testing
	reg [1:0] test_state = 0;
	localparam TEST_IDLE = 2'b00;
	localparam TEST_WRITING = 2'b01;
	localparam TEST_DONE = 2'b10;

	// Add test counter
	reg [7:0] test_counter = 0;

	// Debug signals
	wire [7:0] mem_out;

	// State machine for testing
	always @(posedge clk) begin
		case(test_state)
			TEST_IDLE: begin
				if(BTND) begin  // Start test when BTNU pressed
					test_state <= TEST_WRITING;
					test_counter <= 0;
				end
			end
			
			TEST_WRITING: begin
				if(test_counter < 108) begin
					test_counter <= test_counter + 1;
				end else begin
					test_state <= TEST_DONE;
				end
			end
			
			TEST_DONE: begin
				// Stay in done state
			end
		endcase
	end



	Wrapper_tb wrapper(
		.char_buffer_data(char_buffer[char_index]),
		.char_buffer_we(write_state == DO_WRITE)
	);


	assign LED[1:0] = test_state;  // Show current state
	assign LED[9:2] = test_counter;  // Show current counter value
	assign LED[15:10] = char_buffer[test_counter][5:0];  // Show part of current character
	
endmodule



