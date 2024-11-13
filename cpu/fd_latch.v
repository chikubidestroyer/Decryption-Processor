module fd_latch(
    input [31:0] programCount_in, IR_in,
    input clock, reset, fd_we,
    output [31:0] programCount_out, IR_out 
);

reg32bit programCount (
    .clock(clock),
    .ctrl_writeEnable(fd_we),
    .ctrl_reset(reset),
    .data_writeReg(programCount_in),
    .data_readReg(programCount_out)
);

reg32bit IR (
    .clock(clock),
    .ctrl_writeEnable(fd_we),
    .ctrl_reset(reset),
    .data_writeReg(IR_in),
    .data_readReg(IR_out)
);

endmodule