module mw_latch(
    input [31:0] o_in, d_in, IR_in,
    input clock, reset, mw_en, in_ovfl,
    output[31:0] mw_o_out, mw_d_out, mw_ir_out,
    output out_ovfl
);

reg32bit o (
    .clock(clock),
    .ctrl_writeEnable(1'b1),
    .ctrl_reset(reset),
    .data_writeReg(o_in),
    .data_readReg(mw_o_out)
);

reg32bit d (
    .clock(clock),
    .ctrl_writeEnable(1'b1),
    .ctrl_reset(reset),
    .data_writeReg(d_in),
    .data_readReg(mw_d_out)
);

reg32bit IR (
    .clock(clock),
    .ctrl_writeEnable(1'b1),
    .ctrl_reset(reset),
    .data_writeReg(IR_in),
    .data_readReg(mw_ir_out)
);

dffe_ref ovfl(
    .q(out_ovfl),
    .d(in_ovfl),
    .clk(clock),
    .en(mw_en),
    .clr(reset)
);

endmodule