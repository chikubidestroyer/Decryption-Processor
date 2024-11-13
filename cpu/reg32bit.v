module reg32bit(data_readReg, data_writeReg, clock, ctrl_writeEnable, ctrl_reset);
    input clock, ctrl_writeEnable, ctrl_reset;
    input [31:0] data_writeReg;
    output [31:0] data_readReg;


    genvar i;
    generate
        for (i=0; i<32; i = i+1) begin : dff_gen
            dffe_ref dff(
                .q(data_readReg[i]),
                .d(data_writeReg[i]),
                .clk(clock),
                .en(ctrl_writeEnable),
                .clr(ctrl_reset)
            );
        end
    endgenerate

endmodule