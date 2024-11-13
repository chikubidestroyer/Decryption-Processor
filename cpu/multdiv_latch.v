module multdiv_latch(
    input [31:0] product_in, ir_in,
    input clock, input_en, clr,
    output [31:0] product_out, ir_out
);
reg32bit product (
    .clock(clock),
    .ctrl_writeEnable(input_en),
    .ctrl_reset(clr),
    .data_writeReg(product_in),
    .data_readReg(product_out)
);
reg32bit ir (
    .clock(clock),
    .ctrl_writeEnable(input_en),
    .ctrl_reset(clr),
    .data_writeReg(ir_in),
    .data_readReg(ir_out)
);
endmodule