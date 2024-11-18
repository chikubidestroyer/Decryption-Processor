module bitwise_and(and_output, A, B);
        
    input [31:0] A, B;

    output [31:0] and_output;

    and and0(and_output[0], A[0], B[0]);
    and and1(and_output[1], A[1], B[1]);
    and and2(and_output[2], A[2], B[2]);
    and and3(and_output[3], A[3], B[3]);
    and and4(and_output[4], A[4], B[4]);
    and and5(and_output[5], A[5], B[5]);
    and and6(and_output[6], A[6], B[6]);
    and and7(and_output[7], A[7], B[7]);
    and and8(and_output[8], A[8], B[8]);
    and and9(and_output[9], A[9], B[9]);
    and and10(and_output[10], A[10], B[10]);
    and and11(and_output[11], A[11], B[11]);
    and and12(and_output[12], A[12], B[12]);
    and and13(and_output[13], A[13], B[13]);
    and and14(and_output[14], A[14], B[14]);
    and and15(and_output[15], A[15], B[15]);
    and and16(and_output[16], A[16], B[16]);
    and and17(and_output[17], A[17], B[17]);
    and and18(and_output[18], A[18], B[18]);
    and and19(and_output[19], A[19], B[19]);
    and and20(and_output[20], A[20], B[20]);
    and and21(and_output[21], A[21], B[21]);
    and and22(and_output[22], A[22], B[22]);
    and and23(and_output[23], A[23], B[23]);
    and and24(and_output[24], A[24], B[24]);
    and and25(and_output[25], A[25], B[25]);
    and and26(and_output[26], A[26], B[26]);
    and and27(and_output[27], A[27], B[27]);
    and and28(and_output[28], A[28], B[28]);
    and and29(and_output[29], A[29], B[29]);
    and and30(and_output[30], A[30], B[30]);
    and and31(and_output[31], A[31], B[31]);

endmodule