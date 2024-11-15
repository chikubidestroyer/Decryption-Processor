module dx_latch(
    input [31:0] programCount_in, IR_in, data_readRegA, data_readRegB,
    input clock, reset, dx_en,
    output [31:0] programCount_out, IR_out, a, b
);

reg32bit programCount (
    .clock(clock),
    .ctrl_writeEnable(1'b1),
    .ctrl_reset(reset),
    .data_writeReg(programCount_in),
    .data_readReg(programCount_out)
);

reg32bit IR (
    .clock(clock),
    .ctrl_writeEnable(1'b1),
    .ctrl_reset(reset),
    .data_writeReg(IR_in),
    .data_readReg(IR_out)
);

reg32bit regA (
    .clock(clock),
    .ctrl_writeEnable(1'b1),
    .ctrl_reset(reset),
    .data_writeReg(data_readRegA),
    .data_readReg(a)
);

reg32bit regB (
    .clock(clock),
    .ctrl_writeEnable(1'b1),
    .ctrl_reset(reset),
    .data_writeReg(data_readRegB),
    .data_readReg(b)
);

endmodule