module overflow_checker(
    input [31:0] A,
    input [31:0] B,
    input [64:0] partial_product_out,
    input [31:0] result,
    output overflow_flag
);

    wire EQ_0_part, EQ_1_part, EQ_A_B, GT_A_B, EQ_result;
    
    // Check if partial_product_out[64:33] is zero or all ones
    comp_32 comp_partial_product(
        .A(partial_product_out[64:33]),
        .B(32'b0),
        .EQ(EQ_0_part)
    );
    comp_32 comp_partial_product_2(
        .A(partial_product_out[64:33]),
        .B(32'hFFFFFFFF),
        .EQ(EQ_1_part)
    );

    // Check if A and B are equal
    comp_8 comp_A_B(
        .A(A[31]),
        .B(B[31]),
        .EQ(EQ_A_B)
    );

    // Check if the result is zero
    comp_8 comp_result(
        .A(result[31]),
        .B(1'b0),
        .EQ(EQ_result)
    );

    wire A_z, B_z;
    comp_32 checkzeroA(
        .A(A),
        .B(32'b0),
        .EQ(A_z)
    );
    comp_32 checkzeroB(
        .A(B),
        .B(32'b0),
        .EQ(B_z)
    );

    // Determine overflow_flag based on the conditions
    assign overflow_flag = 
        (~EQ_0_part && ~EQ_1_part) ? 1'b1 :
        (EQ_A_B && !EQ_result) ? 1'b1 : 
        (~EQ_A_B && EQ_result) && !(A_z || B_z) ? 1'b1 : 
        1'b0;

endmodule
