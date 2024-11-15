module xm_latch(
    input [31:0] o_in, b_in, IR_in,
    input clock, reset, xm_en, in_ovfl,
    output [31:0] xm_o_out, xm_b_out, xm_ir_out,
    output out_ovfl
);

reg32bit o (
    .clock(clock),
    .ctrl_writeEnable(1'b1),
    .ctrl_reset(reset),
    .data_writeReg(o_in),
    .data_readReg(xm_o_out)
);

reg32bit b (
    .clock(clock),
    .ctrl_writeEnable(1'b1),
    .ctrl_reset(reset),
    .data_writeReg(b_in),
    .data_readReg(xm_b_out)
);

reg32bit IR (
    .clock(clock),
    .ctrl_writeEnable(1'b1),
    .ctrl_reset(reset),
    .data_writeReg(IR_in),
    .data_readReg(xm_ir_out)
);

dffe_ref ovfl(
    .q(out_ovfl),
    .d(in_ovfl),
    .clk(clock),
    .en(xm_en),
    .clr(reset)
);

endmodule