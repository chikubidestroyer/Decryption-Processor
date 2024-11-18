module shift_left_logical(sll_output, A, shift_amt);
        
    input [31:0] A;
    input [4:0] shift_amt;

    output [31:0] sll_output;

    wire [31:0] s16, s8, s4, s2, s1, m16, m8, m4, m2;

    slb16 shift16(s16, A);
    mux_2 choose16(m16, shift_amt[4], A, s16);

    slb8 shift8(s8, m16);
    mux_2 choose8(m8, shift_amt[3], m16, s8);

    slb4 shift4(s4, m8);
    mux_2 choose4(m4, shift_amt[2], m8, s4);

    slb2 shift2(s2, m4);
    mux_2 choose2(m2, shift_amt[1], m4, s2);

    slb1 shift1(s1, m2);
    mux_2 choose1(sll_output, shift_amt[0], m2, s1);


endmodule

module slb1(sll_output, A);
        
    input [31:0] A;

    output [31:0] sll_output;

    assign sll_output [0] = 1'b0;
    assign sll_output [1] = A[0];
    assign sll_output [2] = A[1];
    assign sll_output [3] = A[2];
    assign sll_output [4] = A[3];
    assign sll_output [5] = A[4];
    assign sll_output [6] = A[5];
    assign sll_output [7] = A[6];
    assign sll_output [8] = A[7];
    assign sll_output [9] = A[8];
    assign sll_output [10] = A[9];
    assign sll_output [11] = A[10];
    assign sll_output [12] = A[11];
    assign sll_output [13] = A[12];
    assign sll_output [14] = A[13];
    assign sll_output [15] = A[14];
    assign sll_output [16] = A[15];
    assign sll_output [17] = A[16];
    assign sll_output [18] = A[17];
    assign sll_output [19] = A[18];
    assign sll_output [20] = A[19];
    assign sll_output [21] = A[20];
    assign sll_output [22] = A[21];
    assign sll_output [23] = A[22];
    assign sll_output [24] = A[23];
    assign sll_output [25] = A[24];
    assign sll_output [26] = A[25];
    assign sll_output [27] = A[26];
    assign sll_output [28] = A[27];
    assign sll_output [29] = A[28];
    assign sll_output [30] = A[29];
    assign sll_output [31] = A[30];


endmodule

module slb2(sll_output, A);
        
    input [31:0] A;

    output [31:0] sll_output;

    assign sll_output [0] = 1'b0;
    assign sll_output [1] = 1'b0;
    assign sll_output [2] = A[0];
    assign sll_output [3] = A[1];
    assign sll_output [4] = A[2];
    assign sll_output [5] = A[3];
    assign sll_output [6] = A[4];
    assign sll_output [7] = A[5];
    assign sll_output [8] = A[6];
    assign sll_output [9] = A[7];
    assign sll_output [10] = A[8];
    assign sll_output [11] = A[9];
    assign sll_output [12] = A[10];
    assign sll_output [13] = A[11];
    assign sll_output [14] = A[12];
    assign sll_output [15] = A[13];
    assign sll_output [16] = A[14];
    assign sll_output [17] = A[15];
    assign sll_output [18] = A[16];
    assign sll_output [19] = A[17];
    assign sll_output [20] = A[18];
    assign sll_output [21] = A[19];
    assign sll_output [22] = A[20];
    assign sll_output [23] = A[21];
    assign sll_output [24] = A[22];
    assign sll_output [25] = A[23];
    assign sll_output [26] = A[24];
    assign sll_output [27] = A[25];
    assign sll_output [28] = A[26];
    assign sll_output [29] = A[27];
    assign sll_output [30] = A[28];
    assign sll_output [31] = A[29];


endmodule

module slb4(sll_output, A);
        
    input [31:0] A;

    output [31:0] sll_output;

    assign sll_output [0] = 1'b0;
    assign sll_output [1] = 1'b0;
    assign sll_output [2] = 1'b0;
    assign sll_output [3] = 1'b0;
    assign sll_output [4] = A[0];
    assign sll_output [5] = A[1];
    assign sll_output [6] = A[2];
    assign sll_output [7] = A[3];
    assign sll_output [8] = A[4];
    assign sll_output [9] = A[5];
    assign sll_output [10] = A[6];
    assign sll_output [11] = A[7];
    assign sll_output [12] = A[8];
    assign sll_output [13] = A[9];
    assign sll_output [14] = A[10];
    assign sll_output [15] = A[11];
    assign sll_output [16] = A[12];
    assign sll_output [17] = A[13];
    assign sll_output [18] = A[14];
    assign sll_output [19] = A[15];
    assign sll_output [20] = A[16];
    assign sll_output [21] = A[17];
    assign sll_output [22] = A[18];
    assign sll_output [23] = A[19];
    assign sll_output [24] = A[20];
    assign sll_output [25] = A[21];
    assign sll_output [26] = A[22];
    assign sll_output [27] = A[23];
    assign sll_output [28] = A[24];
    assign sll_output [29] = A[25];
    assign sll_output [30] = A[26];
    assign sll_output [31] = A[27];


endmodule

module slb8(sll_output, A);
        
    input [31:0] A;

    output [31:0] sll_output;

    assign sll_output [0] = 1'b0;
    assign sll_output [1] = 1'b0;
    assign sll_output [2] = 1'b0;
    assign sll_output [3] = 1'b0;
    assign sll_output [4] = 1'b0;
    assign sll_output [5] = 1'b0;
    assign sll_output [6] = 1'b0;
    assign sll_output [7] = 1'b0;
    assign sll_output [8] = A[0];
    assign sll_output [9] = A[1];
    assign sll_output [10] = A[2];
    assign sll_output [11] = A[3];
    assign sll_output [12] = A[4];
    assign sll_output [13] = A[5];
    assign sll_output [14] = A[6];
    assign sll_output [15] = A[7];
    assign sll_output [16] = A[8];
    assign sll_output [17] = A[9];
    assign sll_output [18] = A[10];
    assign sll_output [19] = A[11];
    assign sll_output [20] = A[12];
    assign sll_output [21] = A[13];
    assign sll_output [22] = A[14];
    assign sll_output [23] = A[15];
    assign sll_output [24] = A[16];
    assign sll_output [25] = A[17];
    assign sll_output [26] = A[18];
    assign sll_output [27] = A[19];
    assign sll_output [28] = A[20];
    assign sll_output [29] = A[21];
    assign sll_output [30] = A[22];
    assign sll_output [31] = A[23];


endmodule

module slb16(sll_output, A);
        
    input [31:0] A;

    output [31:0] sll_output;

    assign sll_output [0] = 1'b0;
    assign sll_output [1] = 1'b0;
    assign sll_output [2] = 1'b0;
    assign sll_output [3] = 1'b0;
    assign sll_output [4] = 1'b0;
    assign sll_output [5] = 1'b0;
    assign sll_output [6] = 1'b0;
    assign sll_output [7] = 1'b0;
    assign sll_output [8] = 1'b0;
    assign sll_output [9] = 1'b0;
    assign sll_output [10] = 1'b0;
    assign sll_output [11] = 1'b0;
    assign sll_output [12] = 1'b0;
    assign sll_output [13] = 1'b0;
    assign sll_output [14] = 1'b0;
    assign sll_output [15] = 1'b0;
    assign sll_output [16] = A[0];
    assign sll_output [17] = A[1];
    assign sll_output [18] = A[2];
    assign sll_output [19] = A[3];
    assign sll_output [20] = A[4];
    assign sll_output [21] = A[5];
    assign sll_output [22] = A[6];
    assign sll_output [23] = A[7];
    assign sll_output [24] = A[8];
    assign sll_output [25] = A[9];
    assign sll_output [26] = A[10];
    assign sll_output [27] = A[11];
    assign sll_output [28] = A[12];
    assign sll_output [29] = A[13];
    assign sll_output [30] = A[14];
    assign sll_output [31] = A[15];

endmodule