module cla_add(overflow, s, a, b, Cin);

input [31:0] a, b;
input Cin;
output [31:0] s;
output overflow;

wire g0, g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12, g13, g14, g15, g16, g17, g18, g19, g20, g21, g22, g23, g24, g25, g26, g27, g28, g29, g30, g31;
wire p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31;

wire g03, g47, g811, g1215, g1619, g2023, g2427, g2831;
wire p03, p47, p811, p1215, p1619, p2023, p2427, p2831;

wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18, c19, c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, c30, c31, c32;

gen g_0(g0, a[0], b[0]);
pro p_0(p0, a[0], b[0]);

gen g_1(g1, a[1], b[1]);
pro p_1(p1, a[1], b[1]);

gen g_2(g2, a[2], b[2]);
pro p_2(p2, a[2], b[2]);

gen g_3(g3, a[3], b[3]);
pro p_3(p3, a[3], b[3]);

lv1_cla firstcla(c1, c2, c3, g03, p03, Cin, g0, g1, g2, g3, p0, p1, p2, p3);

gen g_4(g4, a[4], b[4]);
pro p_4(p4, a[4], b[4]);

gen g_5(g5, a[5], b[5]);
pro p_5(p5, a[5], b[5]);

gen g_6(g6, a[6], b[6]);
pro p_6(p6, a[6], b[6]);

gen g_7(g7, a[7], b[7]);
pro p_7(p7, a[7], b[7]);

lv1_cla secondcla(c5, c6, c7, g47, p47, c4, g4, g5, g6, g7, p4, p5, p6, p7);

gen g_8(g8, a[8], b[8]);
pro p_8(p8, a[8], b[8]);

gen g_9(g9, a[9], b[9]);
pro p_9(p9, a[9], b[9]);

gen g_10(g10, a[10], b[10]);
pro p_10(p10, a[10], b[10]);

gen g_11(g11, a[11], b[11]);
pro p_11(p11, a[11], b[11]);

lv1_cla thirdcla(c9, c10, c11, g811, p811, c8, g8, g9, g10, g11, p8, p9, p10, p11);

gen g_12(g12, a[12], b[12]);
pro p_12(p12, a[12], b[12]);

gen g_13(g13, a[13], b[13]);
pro p_13(p13, a[13], b[13]);

gen g_14(g14, a[14], b[14]);
pro p_14(p14, a[14], b[14]);

gen g_15(g15, a[15], b[15]);
pro p_15(p15, a[15], b[15]);

lv1_cla fourthcla(c13, c14, c15, g1215, p1215, c12, g12, g13, g14, g15, p12, p13, p14, p15);

lv2_cla first_lv2_cla(c4, c8, c12, c16, Cin, g03, g47, g811, g1215, p03, p47, p811, p1215);


gen g_16(g16, a[16], b[16]);
pro p_16(p16, a[16], b[16]);

gen g_17(g17, a[17], b[17]);
pro p_17(p17, a[17], b[17]);

gen g_18(g18, a[18], b[18]);
pro p_18(p18, a[18], b[18]);

gen g_19(g19, a[19], b[19]);
pro p_19(p19, a[19], b[19]);

lv1_cla fifthcla(c17, c18, c19, g1619, p1619, c16, g16, g17, g18, g19, p16, p17, p18, p19);

gen g_20(g20, a[20], b[20]);
pro p_20(p20, a[20], b[20]);

gen g_21(g21, a[21], b[21]);
pro p_21(p21, a[21], b[21]);

gen g_22(g22, a[22], b[22]);
pro p_22(p22, a[22], b[22]);

gen g_23(g23, a[23], b[23]);
pro p_23(p23, a[23], b[23]);

lv1_cla sixthcla(c21, c22, c23, g2023, p2023, c20, g20, g21, g22, g23, p20, p21, p22, p23);

gen g_24(g24, a[24], b[24]);
pro p_24(p24, a[24], b[24]);

gen g_25(g25, a[25], b[25]);
pro p_25(p25, a[25], b[25]);

gen g_26(g26, a[26], b[26]);
pro p_26(p26, a[26], b[26]);

gen g_27(g27, a[27], b[27]);
pro p_27(p27, a[27], b[27]);

lv1_cla seventhcla(c25, c26, c27, g2427, p2427, c24, g24, g25, g26, g27, p24, p25, p26, p27);

gen g_28(g28, a[28], b[28]);
pro p_28(p28, a[28], b[28]);

gen g_29(g29, a[29], b[29]);
pro p_29(p29, a[29], b[29]);

gen g_30(g30, a[30], b[30]);
pro p_30(p30, a[30], b[30]);

gen g_31(g31, a[31], b[31]);
pro p_31(p31, a[31], b[31]);

lv1_cla eighthcla(c29, c30, c31, g2831, p2831, c28, g28, g29, g30, g31, p28, p29, p30, p31);

lv2_cla second_lv2_cla(c20, c24, c28, c32, c16, g1619, g2023, g2427, g2831, p1619, p2023, p2427, p2831);

xor checkoverflow(overflow, c32, c31);

xor s0(s[0], a[0], b[0], Cin);

xor s1(s[1], a[1], b[1], c1);

xor s2(s[2], a[2], b[2], c2);

xor s3(s[3], a[3], b[3], c3);

xor s4(s[4], a[4], b[4], c4);

xor s5(s[5], a[5], b[5], c5);

xor s6(s[6], a[6], b[6], c6);

xor s7(s[7], a[7], b[7], c7);

xor s8(s[8], a[8], b[8], c8);

xor s9(s[9], a[9], b[9], c9);

xor s10(s[10], a[10], b[10], c10);

xor s11(s[11], a[11], b[11], c11);

xor s12(s[12], a[12], b[12], c12);

xor s13(s[13], a[13], b[13], c13);

xor s14(s[14], a[14], b[14], c14);

xor s15(s[15], a[15], b[15], c15);

xor s16(s[16], a[16], b[16], c16);

xor s17(s[17], a[17], b[17], c17);

xor s18(s[18], a[18], b[18], c18);

xor s19(s[19], a[19], b[19], c19);

xor s20(s[20], a[20], b[20], c20);

xor s21(s[21], a[21], b[21], c21);

xor s22(s[22], a[22], b[22], c22);

xor s23(s[23], a[23], b[23], c23);

xor s24(s[24], a[24], b[24], c24);

xor s25(s[25], a[25], b[25], c25);

xor s26(s[26], a[26], b[26], c26);

xor s27(s[27], a[27], b[27], c27);

xor s28(s[28], a[28], b[28], c28);

xor s29(s[29], a[29], b[29], c29);

xor s30(s[30], a[30], b[30], c30);

xor s31(s[31], a[31], b[31], c31);


endmodule


module lv1_cla(c1, c2, c3, g03, p03, c0, g0, g1, g2, g3, p0, p1, p2, p3);

input c0, g0, g1, g2, g3, p0, p1, p2, p3;
output c1, c2, c3, g03, p03;
wire w0, w1, w2;
wire wg0, wg1, wg2;

and a_0(w0, c0, p0);
or c_1(c1, w0, g0);

and a_1(w1, c1, p1);
or c_2(c2, w1, g1);

and a_2(w2, c2, p2);
or c_3(c3, w2, g2);

and p_03(p03, p0, p1, p2, p3);

and wg_0(wg0, g0, p1, p2, p3);
and wg_1(wg1, g1, p2, p3);
and wg_2(wg2, g2, p3);

or g_03(g03, wg0, wg1, wg2, g3);

endmodule;

module lv2_cla(c1, c2, c3, c4, c0, g0, g1, g2, g3, p0, p1, p2, p3, g03, p03);

input c0, g0, g1, g2, g3, p0, p1, p2, p3;
output c1, c2, c3, c4, g03, p03;
wire w0, w1, w2, w3;
wire wg0, wg1, wg2;

and a_0(w0, c0, p0);
or c_1(c1, w0, g0);

and a_1(w1, c1, p1);
or c_2(c2, w1, g1);

and a_2(w2, c2, p2);
or c_3(c3, w2, g2);

and a_3(w3, c3, p3);
or c_4(c4, w3, g3);

endmodule;