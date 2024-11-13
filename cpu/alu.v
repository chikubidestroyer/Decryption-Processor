module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire isAdd, isSubtract, isAnd, isOr, isSLL, isSRA;
    assign isAdd = (ctrl_ALUopcode == 5'b00000);
    assign isSubtract = (ctrl_ALUopcode == 5'b00001);
    assign isAnd = (ctrl_ALUopcode == 5'b00010);
    assign isOr = (ctrl_ALUopcode == 5'b00011);
    assign isSLL = (ctrl_ALUopcode == 5'b00100);
    assign isSRA = (ctrl_ALUopcode == 5'b00101);

    wire [31:0] adder_result;
    wire adder_Cout;
    wire [31:0] and_result, or_result;
    wire [31:0] sll_result, sra_result;
    wire comp_isNotEqual, comp_isLessThan;

    cla32bit addersubtract(
        .data_operandA(data_operandA),
        .data_operandB(data_operandB),
        .sub(isSubtract),
        .Sum(adder_result),
        .Cout(adder_Cout)
    );

    and32 andgate(
        .data_operandA(data_operandA),
        .data_operandB(data_operandB),
        .data_result(and_result)
    );

    or32 orgate(
        .data_operandA(data_operandA),
        .data_operandB(data_operandB),
        .data_result(or_result)
    );

    barrelshift sll_barrelshifter(
        .shift(1'b0),
        .data_operandA(data_operandA),
        .ctrl_shiftamt(ctrl_shiftamt),
        .data_result(sll_result)
    );

    barrelshift sra_barrelshifter(
        .shift(1'b1),
        .data_operandA(data_operandA),
        .ctrl_shiftamt(ctrl_shiftamt),
        .data_result(sra_result)
    );

    comparator32 comp(
        .data_operandA(data_operandA),
        .data_operandB(data_operandB),
        .isNotEqual(comp_isNotEqual),
        .isLessThan(comp_isLessThan),
        .overflow(overflow),
        .is_subtract(isSubtract)
    );
    assign isNotEqual = comp.isNotEqual;
    assign isLessThan = comp.isLessThan;

    wire [31:0] in6;
    wire [31:0] in7;
    assign in6 = 32'b0;
    assign in7 = 32'b0;
    mux_8 result_mux(
        .out(data_result),
        .select(ctrl_ALUopcode[2:0]),
        .in0(adder_result),
        .in1(adder_result),
        .in2(and_result),
        .in3(or_result),
        .in4(sll_result),
        .in5(sra_result),
        .in6(in6),
        .in7(in7)
    );

endmodule