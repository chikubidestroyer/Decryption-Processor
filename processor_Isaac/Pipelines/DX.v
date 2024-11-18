module DX(
    output [31:0] out_IR, 
    output [31:0] out_A,
    output [31:0] out_B,
    output [31:0] out_PC,
    output [31:0] out_TG,
    
    input [31:0] in_IR, 
    input [31:0] in_A,
    input [31:0] in_B,
    input [31:0] in_PC,
    input [31:0] in_TG,

    input clock, 
    input stall, 
    input reset);

    reg32 IR(clock, reset, ~stall, in_IR, out_IR);
    reg32 A(clock, reset, ~stall, in_A, out_A);
    reg32 B(clock, reset, ~stall, in_B, out_B);
    reg32 PC(clock, reset, ~stall, in_PC, out_PC);
    reg32 TG(clock, reset, ~stall, in_TG, out_TG);
endmodule
