module reg65 (
    input clk, 
    input reset, 
    input we, 
    input [64:0] data_in, 
    output [64:0] data_out
);
    genvar i;
    
    // Generate 65 D flip-flops with enable and clear signals
    generate
        for (i = 0; i < 65; i = i + 1) begin : reg_loop
            dffe_ref dff (
                .q(data_out[i]),   // Output bit `i`
                .d(data_in[i]),    // Input bit `i`
                .clk(clk),         // Clock signal
                .en(we),           // Write enable signal
                .clr(reset)        // Reset signal
            );
        end
    endgenerate
endmodule

module reg64 (
    input clk, 
    input reset, 
    input we, 
    input [63:0] data_in, 
    output [63:0] data_out
);
    genvar i;
    
    // Generate 64 D flip-flops with enable and clear signals
    generate
        for (i = 0; i < 64; i = i + 1) begin : reg_loop
            dffe_ref dff (
                .q(data_out[i]),   // Output bit `i`
                .d(data_in[i]),    // Input bit `i`
                .clk(clk),         // Clock signal
                .en(we),           // Write enable signal
                .clr(reset)        // Reset signal
            );
        end
    endgenerate
endmodule

module reg5 (
    input clk, 
    input reset, 
    input we, 
    input [4:0] data_in, 
    output [4:0] data_out
);
    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : reg_loop
            dffe_ref dff (
                .q(data_out[i]),   // Output bit `i`
                .d(data_in[i]),    // Input bit `i`
                .clk(clk),         // Clock signal
                .en(we),           // Write enable signal
                .clr(reset)        // Reset signal
            );
        end
    endgenerate
endmodule

module reg6 (
    input clk, 
    input reset, 
    input we, 
    input [5:0] data_in, 
    output [5:0] data_out
);
    genvar i;
    generate
        for (i = 0; i < 6; i = i + 1) begin : reg_loop
            dffe_ref dff (
                .q(data_out[i]),   // Output bit `i`
                .d(data_in[i]),    // Input bit `i`
                .clk(clk),         // Clock signal
                .en(we),           // Write enable signal
                .clr(reset)        // Reset signal
            );
        end
    endgenerate
endmodule

module reg32 (
    input clk, 
    input reset, 
    input we, 
    input [31:0] data_in, 
    output [31:0] data_out
);
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : reg_loop
            dffe_ref dff (
                .q(data_out[i]),   // Output bit `i`
                .d(data_in[i]),    // Input bit `i`
                .clk(clk),         // Clock signal
                .en(we),           // Write enable signal
                .clr(reset)        // Reset signal
            );
        end
    endgenerate
endmodule

