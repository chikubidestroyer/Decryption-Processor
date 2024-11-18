module comp_32 (
    input [31:0] A, B,
    output EQ, GT
);

    wire EQ1, GT1; // Intermediate wires for the first 16 bits
    wire EQ2, GT2; // Intermediate wires for the last 16 bits

    // Compare the upper 16 bits
    comp_16 comp_upper (
        .A(A[31:16]),
        .B(B[31:16]),
        .EQ(EQ1),
        .GT(GT1)
    );

    // Compare the lower 16 bits
    comp_16 comp_lower (
        .A(A[15:0]),
        .B(B[15:0]),
        .EQ(EQ2),
        .GT(GT2)
    );

    // Determine overall equality
    assign EQ = EQ1 && EQ2;

    // Determine if A is greater than B
    assign GT = GT1 || (EQ1 && GT2);

endmodule

module comp_16 (
    input [15:0] A, B,
    output EQ, GT
);

    wire EQ1, GT1; // Intermediate signals for the upper 8 bits
    wire EQ2, GT2; // Intermediate signals for the lower 8 bits

    // Compare the upper 8 bits
    comp_8 comp_upper (
        .A(A[15:8]),
        .B(B[15:8]),
        .EQ(EQ1),
        .GT(GT1)
    );

    // Compare the lower 8 bits
    comp_8 comp_lower (
        .A(A[7:0]),
        .B(B[7:0]),
        .EQ(EQ2),
        .GT(GT2)
    );

    // Determine overall equality
    assign EQ = EQ1 && EQ2;

    // Determine if A is greater than B
    assign GT = GT1 || (EQ1 && GT2);

endmodule

module comp_8(

    input [7:0] A, B,

    output EQ, GT

    );

 
    wire EQs[7:0], GTs[7:0];

    assign EQs[7] = 1;

    assign GTs[7] = 0;

 

    comp_2 compbit7(.EQ1(EQs[7]), .GT1(GTs[7]),

          .A(A[7:6]), .B(B[7:6]),

          .EQ0(EQs[5]), .GT0(GTs[5]));

 

    comp_2 compbit6(.EQ1(EQs[5]), .GT1(GTs[5]),

          .A(A[5:4]), .B(B[5:4]),

          .EQ0(EQs[3]), .GT0(GTs[3]));

    

    comp_2 compbit5(.EQ1(EQs[3]), .GT1(GTs[3]),

          .A(A[3:2]), .B(B[3:2]),

          .EQ0(EQs[1]), .GT0(GTs[1]));

    

    comp_2 compbit4(.EQ1(EQs[1]), .GT1(GTs[1]),

          .A(A[1:0]), .B(B[1:0]),

          .EQ0(EQ), .GT0(GT));

endmodule

module comp_2(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [1:0] A, B;
    output EQ0, GT0;

    wire EQ0;
    wire neg_B0;
    wire temp_EQ0;
    wire temp_GT0;
    wire temp_2_GT0;
    wire nEQGT;

    not negb(neg_B0, B[0]);

    mux_8_1_bit firstmux(temp_EQ0, {A[1], A[0], B[1]}, neg_B0, 1'b0, B[0], 1'b0, 1'b0, neg_B0, 1'b0, B[0]);
    and finalEQ(EQ0, temp_EQ0, EQ1, ~GT1);

    mux_8_1_bit sencondmux(temp_GT0, {A[1], A[0], B[1]}, 1'b0, 1'b0, neg_B0, 1'b0, 1'b1, 1'b0, 1'b1, neg_B0);
    and tempGT(temp_2_GT0, EQ1, ~GT1, temp_GT0);
    and dfghjk(nEQGT, ~EQ1, GT1);
    or finalGT(GT0, temp_2_GT0, nEQGT);

endmodule

module comp_1 (
    input A, B,
    output EQ, GT
);

    // EQ (equal) is high if both bits are the same
    assign EQ = ~(A ^ B);

    // GT (greater-than) is high if A > B
    assign GT = A & ~B;

endmodule
module comp_6 (
    input [5:0] A, B,
    output EQ, GT
);

    wire EQ_upper, GT_upper, EQ_lower, GT_lower;

    // Compare the upper 2 bits (A[5:4] with B[5:4])
    comp_2 upper_compare (
        .A(A[5:4]), 
        .B(B[5:4]), 
        .EQ1(1'b1),  // Start with EQ1 = 1 (upper bits are assumed equal initially)
        .GT1(1'b0),  // Start with GT1 = 0 (assume no greater result initially)
        .EQ0(EQ_upper), 
        .GT0(GT_upper)
    );

    // Compare the lower 4 bits (A[3:0] with B[3:0]) only if upper bits are equal
    comp_4 lower_compare (
        .A(A[3:0]), 
        .B(B[3:0]), 
        .EQ1(EQ_upper),  // Pass upper comparison result
        .GT1(GT_upper), 
        .EQ0(EQ), 
        .GT0(GT)
    );

endmodule

module comp_4 (
    input [3:0] A, B,
    input EQ1, GT1,  // Inputs from previous stage (higher bits)
    output EQ0, GT0  // Outputs for this stage (lower bits)
);

    wire EQ_upper, GT_upper, EQ_lower, GT_lower;

    // Compare the upper 2 bits (A[3:2] with B[3:2])
    comp_2 upper_compare (
        .A(A[3:2]), 
        .B(B[3:2]), 
        .EQ1(EQ1), 
        .GT1(GT1), 
        .EQ0(EQ_upper), 
        .GT0(GT_upper)
    );

    // Compare the lower 2 bits (A[1:0] with B[1:0])
    comp_2 lower_compare (
        .A(A[1:0]), 
        .B(B[1:0]), 
        .EQ1(EQ_upper), 
        .GT1(GT_upper), 
        .EQ0(EQ0), 
        .GT0(GT0)
    );

endmodule
