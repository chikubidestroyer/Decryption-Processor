module full_adder(A, B, Cin, Sum);
    input A, B, Cin;
    output Sum;
    wire AxorB;
    wire AandB;
    wire AxorB_and_Cin;

    xor (AxorB, A, B);
    xor (Sum, AxorB, Cin);

    and (AandB, A, B);
    and (AxorB_and_Cin, AxorB, Cin);
    or  ( AandB, AxorB_and_Cin);
endmodule
