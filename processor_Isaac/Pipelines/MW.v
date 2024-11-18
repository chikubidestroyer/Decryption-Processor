module MW(
    output [31:0] out_ALU_out, 
    output [31:0] out_D,
    output [31:0] out_IR,
    output out_exception,
    
    input [31:0] in_ALU_out, 
    input [31:0] in_D,
    input [31:0] in_IR,
    input in_exception,

    input clock, 
    input stall, 
    input reset);

    reg32 IR(clock, reset, ~stall, in_IR, out_IR);
    reg32 ALU_out(clock, reset, ~stall, in_ALU_out, out_ALU_out);
    reg32 D(clock, reset, ~stall, in_D, out_D);
    dffe_ref exception(out_exception, in_exception, clock, ~stall, reset);
endmodule
