module comparator32(data_operandA, data_operandB, isNotEqual, isLessThan, overflow, is_subtract);
    input [31:0] data_operandA, data_operandB;
    input is_subtract;
    output isNotEqual, isLessThan, overflow;
    wire [31:0] sub_result, add_result;
    wire        Cout;


    cla32bit cla_subtractor (
        .data_operandA (data_operandA),
        .data_operandB (data_operandB),
        .sub    (1'b1),          // Set sub = 1 for subtraction
        .Sum    (sub_result),
        .Cout   (Cout)
    );

    cla32bit cla_adder (
        .data_operandA (data_operandA),
        .data_operandB (data_operandB),
        .sub    (1'b0),          // Set sub = 0 for addition
        .Sum    (add_result),
        .Cout   (Cout)
    );

    wire isZero = (sub_result == 32'b0);
    not (isNotEqual, isZero);

    wire A_sign, B_sign, result_sign;
    assign A_sign      = data_operandA[31];
    assign B_sign      = data_operandB[31];
    assign result_sign = sub_result[31]; 

    wire same_sign_add, result_diff_sign_add;
    wire same_sign_sub, result_diff_sign_sub;
    wire overflow_add, overflow_sub, diff_sign_sub;

    xnor (same_sign_add, A_sign, B_sign);
    xor (result_diff_sign_add, A_sign, add_result[31]);
    and (overflow_add, same_sign_add, result_diff_sign_add);

    xor (diff_sign_sub, A_sign, B_sign);
    xor (result_diff_sign_sub, A_sign, sub_result[31]);
    and (overflow_sub, diff_sign_sub, result_diff_sign_sub);

    assign overflow = (is_subtract) ? overflow_sub : overflow_add;



    // Compute isLessThan 
        //compute NOT gates
        wire not_overflow, not_result_sign;
        not (not_overflow, overflow);
        not (not_result_sign, result_sign);

        //compute AND gates
        wire and1, and2;
        and (and1, overflow, not_result_sign);
        and (and2, not_overflow, result_sign);

        // Final Or
        or (isLessThan, and1, and2);

endmodule
