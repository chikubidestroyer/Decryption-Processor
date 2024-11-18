module PC(
    input [31:0] next,
    input clock, 
    input stall, 
    input reset,
    output [31:0] current
);

    reg32 pc(.data_out(current), .data_in(next), .clk(clock), .we(~stall), .reset(reset));

endmodule
