module shift_right_arithmetic (sra_output, A, shift_amt);

    input [31:0] A;
    input [4:0] shift_amt;

    output [31:0] sra_output;

    wire [31:0] s16, s8, s4, s2, s1, m16, m8, m4, m2;

    srb16 shift16(s16, A);
    mux_2 choose16(m16, shift_amt[4], A, s16);

    srb8 shift8(s8, m16);
    mux_2 choose8(m8, shift_amt[3], m16, s8);

    srb4 shift4(s4, m8);
    mux_2 choose4(m4, shift_amt[2], m8, s4);

    srb2 shift2(s2, m4);
    mux_2 choose2(m2, shift_amt[1], m4, s2);

    srb1 shift1(s1, m2);
    mux_2 choose1(sra_output, shift_amt[0], m2, s1);

endmodule

module srb1(sra_output, A);
        
    input [31:0] A;

    output [31:0] sra_output;

    assign sra_output [0] = A[1];
    assign sra_output [1] = A[2];
    assign sra_output [2] = A[3];
    assign sra_output [3] = A[4];
    assign sra_output [4] = A[5];
    assign sra_output [5] = A[6];
    assign sra_output [6] = A[7];
    assign sra_output [7] = A[8];
    assign sra_output [8] = A[9];
    assign sra_output [9] = A[10];
    assign sra_output [10] = A[11];
    assign sra_output [11] = A[12];
    assign sra_output [12] = A[13];
    assign sra_output [13] = A[14];
    assign sra_output [14] = A[15];
    assign sra_output [15] = A[16];
    assign sra_output [16] = A[17];
    assign sra_output [17] = A[18];
    assign sra_output [18] = A[19];
    assign sra_output [19] = A[20];
    assign sra_output [20] = A[21];
    assign sra_output [21] = A[22];
    assign sra_output [22] = A[23];
    assign sra_output [23] = A[24];
    assign sra_output [24] = A[25];
    assign sra_output [25] = A[26];
    assign sra_output [26] = A[27];
    assign sra_output [27] = A[28];
    assign sra_output [28] = A[29];
    assign sra_output [29] = A[30];
    assign sra_output [30] = A[31];
    assign sra_output [31] = A[31];


endmodule

module srb2(sra_output, A);
        
    input [31:0] A;

    output [31:0] sra_output;

    assign sra_output [0] = A[2];
    assign sra_output [1] = A[3];
    assign sra_output [2] = A[4];
    assign sra_output [3] = A[5];
    assign sra_output [4] = A[6];
    assign sra_output [5] = A[7];
    assign sra_output [6] = A[8];
    assign sra_output [7] = A[9];
    assign sra_output [8] = A[10];
    assign sra_output [9] = A[11];
    assign sra_output [10] = A[12];
    assign sra_output [11] = A[13];
    assign sra_output [12] = A[14];
    assign sra_output [13] = A[15];
    assign sra_output [14] = A[16];
    assign sra_output [15] = A[17];
    assign sra_output [16] = A[18];
    assign sra_output [17] = A[19];
    assign sra_output [18] = A[20];
    assign sra_output [19] = A[21];
    assign sra_output [20] = A[22];
    assign sra_output [21] = A[23];
    assign sra_output [22] = A[24];
    assign sra_output [23] = A[25];
    assign sra_output [24] = A[26];
    assign sra_output [25] = A[27];
    assign sra_output [26] = A[28];
    assign sra_output [27] = A[29];
    assign sra_output [28] = A[30];
    assign sra_output [29] = A[31];
    assign sra_output [30] = A[31];
    assign sra_output [31] = A[31];


endmodule

module srb4(sra_output, A);
        
    input [31:0] A;

    output [31:0] sra_output;

    assign sra_output [0] = A[4];
    assign sra_output [1] = A[5];
    assign sra_output [2] = A[6];
    assign sra_output [3] = A[7];
    assign sra_output [4] = A[8];
    assign sra_output [5] = A[9];
    assign sra_output [6] = A[10];
    assign sra_output [7] = A[11];
    assign sra_output [8] = A[12];
    assign sra_output [9] = A[13];
    assign sra_output [10] = A[14];
    assign sra_output [11] = A[15];
    assign sra_output [12] = A[16];
    assign sra_output [13] = A[17];
    assign sra_output [14] = A[18];
    assign sra_output [15] = A[19];
    assign sra_output [16] = A[20];
    assign sra_output [17] = A[21];
    assign sra_output [18] = A[22];
    assign sra_output [19] = A[23];
    assign sra_output [20] = A[24];
    assign sra_output [21] = A[25];
    assign sra_output [22] = A[26];
    assign sra_output [23] = A[27];
    assign sra_output [24] = A[28];
    assign sra_output [25] = A[29];
    assign sra_output [26] = A[30];
    assign sra_output [27] = A[31];
    assign sra_output [28] = A[31];
    assign sra_output [29] = A[31];
    assign sra_output [30] = A[31];
    assign sra_output [31] = A[31];


endmodule

module srb8(sra_output, A);
        
    input [31:0] A;

    output [31:0] sra_output;

    assign sra_output [0] = A[8];
    assign sra_output [1] = A[9];
    assign sra_output [2] = A[10];
    assign sra_output [3] = A[11];
    assign sra_output [4] = A[12];
    assign sra_output [5] = A[13];
    assign sra_output [6] = A[14];
    assign sra_output [7] = A[15];
    assign sra_output [8] = A[16];
    assign sra_output [9] = A[17];
    assign sra_output [10] = A[18];
    assign sra_output [11] = A[19];
    assign sra_output [12] = A[20];
    assign sra_output [13] = A[21];
    assign sra_output [14] = A[22];
    assign sra_output [15] = A[23];
    assign sra_output [16] = A[24];
    assign sra_output [17] = A[25];
    assign sra_output [18] = A[26];
    assign sra_output [19] = A[27];
    assign sra_output [20] = A[28];
    assign sra_output [21] = A[29];
    assign sra_output [22] = A[30];
    assign sra_output [23] = A[31];
    assign sra_output [24] = A[31];
    assign sra_output [25] = A[31];
    assign sra_output [26] = A[31];
    assign sra_output [27] = A[31];
    assign sra_output [28] = A[31];
    assign sra_output [29] = A[31];
    assign sra_output [30] = A[31];
    assign sra_output [31] = A[31];


endmodule

module srb16(sra_output, A);
        
    input [31:0] A;

    output [31:0] sra_output;

    assign sra_output [0] = A[16];
    assign sra_output [1] = A[17];
    assign sra_output [2] = A[18];
    assign sra_output [3] = A[19];
    assign sra_output [4] = A[20];
    assign sra_output [5] = A[21];
    assign sra_output [6] = A[22];
    assign sra_output [7] = A[23];
    assign sra_output [8] = A[24];
    assign sra_output [9] = A[25];
    assign sra_output [10] = A[26];
    assign sra_output [11] = A[27];
    assign sra_output [12] = A[28];
    assign sra_output [13] = A[29];
    assign sra_output [14] = A[30];
    assign sra_output [15] = A[31];
    assign sra_output [16] = A[31];
    assign sra_output [17] = A[31];
    assign sra_output [18] = A[31];
    assign sra_output [19] = A[31];
    assign sra_output [20] = A[31];
    assign sra_output [21] = A[31];
    assign sra_output [22] = A[31];
    assign sra_output [23] = A[31];
    assign sra_output [24] = A[31];
    assign sra_output [25] = A[31];
    assign sra_output [26] = A[31];
    assign sra_output [27] = A[31];
    assign sra_output [28] = A[31];
    assign sra_output [29] = A[31];
    assign sra_output [30] = A[31];
    assign sra_output [31] = A[31];


endmodule