module counter(clock, ctrl_reset, enable, data_resultRDY);
    input clock, ctrl_reset, enable;
    output data_resultRDY;

    wire [5:0] counting;
    wire [5:0] next_count;

    // count to 32
    assign next_count[0] = ~counting[0];
    assign next_count[1] = counting[0] ^ counting[1];
    assign next_count[2] = (counting[1] & counting[0]) ^ counting[2];
    assign next_count[3] = (counting[2] & counting[1] & counting[0]) ^ counting[3];
    assign next_count[4] = (counting[3] & counting[2] & counting[1] & counting[0]) ^ counting[4];
    assign next_count[5] = (counting[4] & counting[3] & counting[2] & counting[1] & counting[0]) ^ counting[5];

    dffe_ref dffe_ref0(
        .q(counting[0]), 
        .d(next_count[0]), 
        .clk(clock), 
        .en(enable), 
        .clr(ctrl_reset)
    );
    dffe_ref dffe_ref1(
        .q(counting[1]), 
        .d(next_count[1]), 
        .clk(clock), 
        .en(enable), 
        .clr(ctrl_reset)
    );
    dffe_ref dffe_ref2(
        .q(counting[2]), 
        .d(next_count[2]), 
        .clk(clock), 
        .en(enable), 
        .clr(ctrl_reset)
    );
    dffe_ref dffe_ref3(
        .q(counting[3]), 
        .d(next_count[3]), 
        .clk(clock), 
        .en(enable), 
        .clr(ctrl_reset)
    );
    dffe_ref dffe_ref4(
        .q(counting[4]), 
        .d(next_count[4]), 
        .clk(clock), 
        .en(enable), 
        .clr(ctrl_reset)
    );
    dffe_ref dffe_ref5(
        .q(counting[5]), 
        .d(next_count[5]), 
        .clk(clock), 
        .en(enable), 
        .clr(ctrl_reset)
    );

    //data_resultRDY == 32 (binary 100000)
    assign data_resultRDY = counting[5] & ~|counting[4:0];

endmodule