module Decoder(
    output [1:0] type,
    output [4:0] Opcode, rd, rs, rt, shamt, ALUop,
    output [31:0] N, T,
    input [31:0] instruction);

    wire r, i, jI, jII;

    wire [4:0] opcode;
    assign opcode = instruction[31:27];

    assign type = r ? 2'b00 : 
                        i ? 2'b01 : 
                        jI ? 2'b10 :
                        jII ? 2'b11 : 2'bz;


    assign r = (opcode == 5'b00000) ? 1'b1: 1'b0;
    assign i = (
            opcode == 5'b00101 ||
            opcode == 5'b00111 ||
            opcode == 5'b01000 ||
            opcode == 5'b00010 ||
            opcode == 5'b00110
            ) ? 1'b1: 1'b0;

    assign jI = (
                opcode == 5'b00001 ||
                opcode == 5'b00011 ||
                opcode == 5'b10110 ||
                opcode == 5'b10101
                ) ? 1'b1: 1'b0;
    assign jII = (
                opcode == 5'b00100
                )? 1'b1:1'b0;

    assign rd = instruction[26:22];
    assign rs = instruction[21:17];
    assign rt = instruction[16:12];
    assign shamt = instruction[11:7];
    assign ALUop = instruction[6:2];
    assign N = instruction[16:0];
    assign T = instruction[26:0]; 

endmodule