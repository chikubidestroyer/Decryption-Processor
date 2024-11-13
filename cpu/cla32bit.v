module cla32bit(data_operandA, data_operandB, sub, Sum, Cout);
    input [31:0] data_operandA;
    input [31:0] data_operandB;
    input        sub;
    output [31:0] Sum;
    output        Cout;
    wire [31:0] B_in;
    wire [7:0]  P_group;     // Block propagate 
    wire [7:0]  G_group;     // Block generate 
    wire        C0, C1, C2, C3, C4, C5, C6, C7, C8; // Carry signals

    assign C0 = sub; // subtraction carry in

    // Compute inverse B
        xor (B_in[0],  data_operandB[0],  sub);
        xor (B_in[1],  data_operandB[1],  sub);
        xor (B_in[2],  data_operandB[2],  sub);
        xor (B_in[3],  data_operandB[3],  sub);
        xor (B_in[4],  data_operandB[4],  sub);
        xor (B_in[5],  data_operandB[5],  sub);
        xor (B_in[6],  data_operandB[6],  sub);
        xor (B_in[7],  data_operandB[7],  sub);
        xor (B_in[8],  data_operandB[8],  sub);
        xor (B_in[9],  data_operandB[9],  sub);
        xor (B_in[10], data_operandB[10], sub);
        xor (B_in[11], data_operandB[11], sub);
        xor (B_in[12], data_operandB[12], sub);
        xor (B_in[13], data_operandB[13], sub);
        xor (B_in[14], data_operandB[14], sub);
        xor (B_in[15], data_operandB[15], sub);
        xor (B_in[16], data_operandB[16], sub);
        xor (B_in[17], data_operandB[17], sub);
        xor (B_in[18], data_operandB[18], sub);
        xor (B_in[19], data_operandB[19], sub);
        xor (B_in[20], data_operandB[20], sub);
        xor (B_in[21], data_operandB[21], sub);
        xor (B_in[22], data_operandB[22], sub);
        xor (B_in[23], data_operandB[23], sub);
        xor (B_in[24], data_operandB[24], sub);
        xor (B_in[25], data_operandB[25], sub);
        xor (B_in[26], data_operandB[26], sub);
        xor (B_in[27], data_operandB[27], sub);
        xor (B_in[28], data_operandB[28], sub);
        xor (B_in[29], data_operandB[29], sub);
        xor (B_in[30], data_operandB[30], sub);
        xor (B_in[31], data_operandB[31], sub);

    // 8 blocks of 4-bit CLA
        cla4bit cla_block0 (
            .A       (data_operandA[3:0]),
            .B       (B_in[3:0]),
            .Cin     (C0),
            .Sum     (Sum[3:0]),
            .P_group (P_group[0]),
            .G_group (G_group[0])
        );

        cla4bit cla_block1 (
            .A       (data_operandA[7:4]),
            .B       (B_in[7:4]),
            .Cin     (C1),
            .Sum     (Sum[7:4]),
            .P_group (P_group[1]),
            .G_group (G_group[1])
        );

        cla4bit cla_block2 (
            .A       (data_operandA[11:8]),
            .B       (B_in[11:8]),
            .Cin     (C2),
            .Sum     (Sum[11:8]),
            .P_group (P_group[2]),
            .G_group (G_group[2])
        );

        cla4bit cla_block3 (
            .A       (data_operandA[15:12]),
            .B       (B_in[15:12]),
            .Cin     (C3),
            .Sum     (Sum[15:12]),
            .P_group (P_group[3]),
            .G_group (G_group[3])
        );

        cla4bit cla_block4 (
            .A       (data_operandA[19:16]),
            .B       (B_in[19:16]),
            .Cin     (C4),
            .Sum     (Sum[19:16]),
            .P_group (P_group[4]),
            .G_group (G_group[4])
        );

        cla4bit cla_block5 (
            .A       (data_operandA[23:20]),
            .B       (B_in[23:20]),
            .Cin     (C5),
            .Sum     (Sum[23:20]),
            .P_group (P_group[5]),
            .G_group (G_group[5])
        );

        cla4bit cla_block6 (
            .A       (data_operandA[27:24]),
            .B       (B_in[27:24]),
            .Cin     (C6),
            .Sum     (Sum[27:24]),
            .P_group (P_group[6]),
            .G_group (G_group[6])
        );

        cla4bit cla_block7 (
            .A       (data_operandA[31:28]),
            .B       (B_in[31:28]),
            .Cin     (C7),
            .Sum     (Sum[31:28]),
            .P_group (P_group[7]),
            .G_group (G_group[7])
        );

    // carry signals
        // C1 = G_group[0] + (P_group[0] * C0)
        wire P0C0;
        and (P0C0, P_group[0], C0);
        or  (C1, G_group[0], P0C0);

        // C2 = G_group[1] + (P_group[1] * C1)
        wire P1C1;
        and (P1C1, P_group[1], C1);
        or  (C2, G_group[1], P1C1);

        // C3 = G_group[2] + (P_group[2] * C2)
        wire P2C2;
        and (P2C2, P_group[2], C2);
        or  (C3, G_group[2], P2C2);

        // C4 = G_group[3] + (P_group[3] * C3)
        wire P3C3;
        and (P3C3, P_group[3], C3);
        or  (C4, G_group[3], P3C3);

        // C5 = G_group[4] + (P_group[4] * C4)
        wire P4C4;
        and (P4C4, P_group[4], C4);
        or  (C5, G_group[4], P4C4);

        // C6 = G_group[5] + (P_group[5] * C5)
        wire P5C5;
        and (P5C5, P_group[5], C5);
        or  (C6, G_group[5], P5C5);

        // C7 = G_group[6] + (P_group[6] * C6)
        wire P6C6;
        and (P6C6, P_group[6], C6);
        or  (C7, G_group[6], P6C6);

        // C8 = G_group[7] + (P_group[7] * C7)
        wire P7C7;
        and (P7C7, P_group[7], C7);
        or  (C8, G_group[7], P7C7);

        assign Cout = C8; // carry out

endmodule
