module barrelshift(data_operandA, ctrl_shiftamt, shift, data_result);
    input [31:0] data_operandA;
    input [4:0] ctrl_shiftamt;
    input shift;
    output [31:0] data_result;

    wire [31:0] stage16;
    wire [31:0] stage8;
    wire [31:0] stage4;
    wire [31:0] stage2;
    wire [31:0] stage1;

    sixteenbitshifter level16(
        .data_operandA(data_operandA),
        .shift(shift),
        .data_result(stage16),
        .enable(ctrl_shiftamt[4])
    );

    eightbitshifter level8(
        .data_operandA(stage16),
        .shift(shift),
        .data_result(stage8),
        .enable(ctrl_shiftamt[3])
    );

    fourbitshifter level4(
        .data_operandA(stage8),
        .shift(shift),
        .data_result(stage4),
        .enable(ctrl_shiftamt[2])
    );

    twobitshifter level2(
        .data_operandA(stage4),
        .shift(shift),
        .data_result(stage2),
        .enable(ctrl_shiftamt[1])
    );

    onebitshifter level1(
        .data_operandA(stage2),
        .shift(shift),
        .data_result(data_result),
        .enable(ctrl_shiftamt[0])
    );

endmodule
    