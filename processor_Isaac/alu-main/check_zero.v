module check_zero(
    input [31:0] Input_A,
    output all_zero     
);

    wire or1, or2, or3, or4, or5, or6, or7, or8;
    wire or9, or10, or11, or12, or13, or14, or15, or16;
    wire or17, or18, or19, or20, or21, or22, or23, or24;
    wire or25, or26, or27, or28, or29, or30, or31, or32;

    or (or1,  Input_A[0],  Input_A[1]);
    or (or2,  or1,  Input_A[2]);
    or (or3,  or2,  Input_A[3]);
    or (or4,  or3,  Input_A[4]);
    or (or5,  or4,  Input_A[5]);
    or (or6,  or5,  Input_A[6]);
    or (or7,  or6,  Input_A[7]);
    or (or8,  or7,  Input_A[8]);
    or (or9,  or8,  Input_A[9]);
    or (or10, or9,  Input_A[10]);
    or (or11, or10, Input_A[11]);
    or (or12, or11, Input_A[12]);
    or (or13, or12, Input_A[13]);
    or (or14, or13, Input_A[14]);
    or (or15, or14, Input_A[15]);
    or (or16, or15, Input_A[16]);
    or (or17, or16, Input_A[17]);
    or (or18, or17, Input_A[18]);
    or (or19, or18, Input_A[19]);
    or (or20, or19, Input_A[20]);
    or (or21, or20, Input_A[21]);
    or (or22, or21, Input_A[22]);
    or (or23, or22, Input_A[23]);
    or (or24, or23, Input_A[24]);
    or (or25, or24, Input_A[25]);
    or (or26, or25, Input_A[26]);
    or (or27, or26, Input_A[27]);
    or (or28, or27, Input_A[28]);
    or (or29, or28, Input_A[29]);
    or (or30, or29, Input_A[30]);
    or (or31, or30, Input_A[31]);


    or (all_zero, or31, or30);
 

endmodule
