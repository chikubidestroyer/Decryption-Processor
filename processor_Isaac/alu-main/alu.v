module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // add your code here:
    wire [31:0] add_output, subtract_output, and_output, or_output, sll_output, sra_output;
    
    wire overflow_add;
    // Add operation
    cla_add add_op(overflow_add, add_output, data_operandA, data_operandB, 1'b0);

    wire [31:0] inverted_B;

    not not_b0(inverted_B[0], data_operandB[0]);
    not not_b1(inverted_B[1], data_operandB[1]);
    not not_b2(inverted_B[2], data_operandB[2]);
    not not_b3(inverted_B[3], data_operandB[3]);
    not not_b4(inverted_B[4], data_operandB[4]);
    not not_b5(inverted_B[5], data_operandB[5]);
    not not_b6(inverted_B[6], data_operandB[6]);
    not not_b7(inverted_B[7], data_operandB[7]);
    not not_b8(inverted_B[8], data_operandB[8]);
    not not_b9(inverted_B[9], data_operandB[9]);
    not not_b10(inverted_B[10], data_operandB[10]);
    not not_b11(inverted_B[11], data_operandB[11]);
    not not_b12(inverted_B[12], data_operandB[12]);
    not not_b13(inverted_B[13], data_operandB[13]);
    not not_b14(inverted_B[14], data_operandB[14]);
    not not_b15(inverted_B[15], data_operandB[15]);
    not not_b16(inverted_B[16], data_operandB[16]);
    not not_b17(inverted_B[17], data_operandB[17]);
    not not_b18(inverted_B[18], data_operandB[18]);
    not not_b19(inverted_B[19], data_operandB[19]);
    not not_b20(inverted_B[20], data_operandB[20]);
    not not_b21(inverted_B[21], data_operandB[21]);
    not not_b22(inverted_B[22], data_operandB[22]);
    not not_b23(inverted_B[23], data_operandB[23]);
    not not_b24(inverted_B[24], data_operandB[24]);
    not not_b25(inverted_B[25], data_operandB[25]);
    not not_b26(inverted_B[26], data_operandB[26]);
    not not_b27(inverted_B[27], data_operandB[27]);
    not not_b28(inverted_B[28], data_operandB[28]);
    not not_b29(inverted_B[29], data_operandB[29]);
    not not_b30(inverted_B[30], data_operandB[30]);
    not not_b31(inverted_B[31], data_operandB[31]);

    wire overflow_sub;
    cla_add subtract_op(overflow_sub, subtract_output, data_operandA, inverted_B, 1'b1);

    bitwise_and and_op(and_output, data_operandA, data_operandB);

    bitwise_or or_op(or_output, data_operandA, data_operandB);

    shift_left_logical sll_op(sll_output, data_operandA, ctrl_shiftamt);
    shift_right_arithmetic sra_op(sra_output, data_operandA, ctrl_shiftamt);

    mux_8 final_result(data_result, ctrl_ALUopcode[2:0], add_output, subtract_output, and_output, or_output, sll_output, sra_output, 32'b?, 32'b?);

    assign overflow = (ctrl_ALUopcode[0]) ? overflow_sub : overflow_add;
    xor lt(isLessThan, subtract_output[31], overflow);
    check_zero check_eq(subtract_output, isNotEqual);
    

endmodule