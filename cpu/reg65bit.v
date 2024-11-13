module reg65bit(
    input [64:0] data_writeReg,
    input clock, ctrl_writeEnable, ctrl_reset,
    output [64:0] data_readReg
);

    // bits [64:33]
    reg32bit cumulative (
        .clock(clock),
        .ctrl_writeEnable(ctrl_writeEnable),
        .ctrl_reset(ctrl_reset),
        .data_writeReg(data_writeReg[64:33]),
        .data_readReg(data_readReg[64:33])
    );

    // bits [32:1]
    reg32bit multiplier (
        .clock(clock),
        .ctrl_writeEnable(ctrl_writeEnable),
        .ctrl_reset(ctrl_reset),
        .data_writeReg(data_writeReg[32:1]),
        .data_readReg(data_readReg[32:1])
    );

    // lsb
    dffe_ref booth_bit (
        .q(data_readReg[0]),
        .d(data_writeReg[0]),
        .clk(clock),
        .en(ctrl_writeEnable),
        .clr(ctrl_reset)
    );

endmodule