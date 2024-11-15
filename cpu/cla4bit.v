module cla4bit(A, B, Cin, Sum, P_group, G_group);
    input  [3:0] A, B; 
    input        Cin;  
    output [3:0] Sum; 
    //output       Cout; 
    output       P_group, G_group; 

    wire [3:0] P;    // Propagate 
    wire [3:0] G;    // Generate 
    wire       C0, C1, C2, C3, C4;  // Carry signals

    assign C0 = Cin;

    // p_group and g_group signals
    xor p0(P[0], A[0], B[0]);
    xor p1(P[1], A[1], B[1]);
    xor p2(P[2], A[2], B[2]);
    xor p3(P[3], A[3], B[3]);

    and g0(G[0], A[0], B[0]);
    and g1(G[1], A[1], B[1]);
    and g2(G[2], A[2], B[2]);
    and g3(G[3], A[3], B[3]);

    // carry signals

        // C1 = G[0] + (P[0] * C0)
        wire P0C0;
        and (P0C0, P[0], C0);
        or  (C1, G[0], P0C0);

        // C2 = G[1] + (P[1] * G[0]) + (P[1] * P[0] * C0)
        wire P1G0, P1P0, P1P0C0, C2_temp1;
        and (P1G0, P[1], G[0]);
        and (P1P0, P[1], P[0]);
        and (P1P0C0, P1P0, C0);
        or  (C2_temp1, G[1], P1G0);
        or  (C2, C2_temp1, P1P0C0);

        // C3 = G[2] + (P[2] * G[1]) + (P[2] * P[1] * G[0]) + (P[2] * P[1] * P[0] * C0)
        wire P2G1, P2P1, P2P1G0, P2P1P0, P2P1P0C0;
        wire C3_temp1, C3_temp2;
        and (P2G1, P[2], G[1]);
        and (P2P1, P[2], P[1]);
        and (P2P1G0, P2P1, G[0]);
        and (P2P1P0, P2P1, P[0]);
        and (P2P1P0C0, P2P1P0, C0);
        or  (C3_temp1, G[2], P2G1);
        or  (C3_temp2, C3_temp1, P2P1G0);
        or  (C3, C3_temp2, P2P1P0C0);

        // C4 = G[3] + (P[3] * G[2]) + (P[3] * P[2] * G[1]) + (P[3] * P[2] * P[1] * G[0]) + (P[3] * P[2] * P[1] * P[0] * C0)
        wire P3G2, P3P2, P3P2G1, P3P2P1, P3P2P1G0, P3P2P1P0, P3P2P1P0C0;
        wire C4_temp1, C4_temp2, C4_temp3;
        and (P3G2, P[3], G[2]);
        and (P3P2, P[3], P[2]);
        and (P3P2G1, P3P2, G[1]);
        and (P3P2P1, P3P2, P[1]);
        and (P3P2P1G0, P3P2P1, G[0]);
        and (P3P2P1P0, P3P2P1, P[0]);
        and (P3P2P1P0C0, P3P2P1P0, C0);
        or  (C4_temp1, G[3], P3G2);
        or  (C4_temp2, C4_temp1, P3P2G1);
        or  (C4_temp3, C4_temp2, P3P2P1G0);
        or  (C4, C4_temp3, P3P2P1P0C0);

    //assign Cout = C4;

    // propgate and generate signals for second level
        wire P01, P012;
        and (P01, P[0], P[1]);
        and (P012, P01, P[2]);
        and (P_group, P012, P[3]);

        // G_group = G[3] + (P[3]*G[2]) + (P[3]*P[2]*G[1]) + (P[3]*P[2]*P[1]*G[0])
        wire G3_or_P3G2, G_temp;
        or  (G3_or_P3G2, G[3], P3G2);
        or  (G_temp, G3_or_P3G2, P3P2G1);
        or  (G_group, G_temp, P3P2P1G0);

    // Instantiate full adders
        full_adder fa0 (
            .A   (A[0]),
            .B   (B[0]),
            .Cin (C0),
            .Sum (Sum[0])
        );

        full_adder fa1 (
            .A   (A[1]),
            .B   (B[1]),
            .Cin (C1),
            .Sum (Sum[1])
        );

        full_adder fa2 (
            .A   (A[2]),
            .B   (B[2]),
            .Cin (C2),
            .Sum (Sum[2])
        );

        full_adder fa3 (
            .A   (A[3]),
            .B   (B[3]),
            .Cin (C3),
            .Sum (Sum[3])
        );
endmodule
