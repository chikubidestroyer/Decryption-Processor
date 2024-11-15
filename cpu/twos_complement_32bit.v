module twos_complement_32bit(
    input [31:0] in,           // 32-bit input to be converted
    output [31:0] out          // 32-bit two's complement output
);

    // Invert all the bits of the input
    wire [31:0] inverted;
    assign inverted = ~in;

    // Add 1 to the inverted value to get the two's complement
    assign out = inverted + 1;

endmodule
