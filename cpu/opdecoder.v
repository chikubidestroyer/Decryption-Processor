module opdecoder(
    input  [31:0] instruction,
    output [4:0] opcode, rd, rs, rt, shamt, alu_op,
    output [16:0] imm,
    output [26:0] jump_target,
    output rType, iType, jType1,  jType2
);


assign opcode      = instruction[31:27];
assign rd          = instruction[26:22];
assign rs          = instruction[21:17];
assign rt          = instruction[16:12];
assign shamt       = instruction[11:7];
assign alu_op      = instruction[6:2];
assign imm         = instruction[16:0];
assign jump_target = instruction[26:0];

assign rType = (opcode == 5'b00000);


wire is_addi, is_sw, is_lw;
assign is_addi = (opcode == 5'b00101); // ADDI
assign is_sw   = (opcode == 5'b00111); // SW
assign is_lw   = (opcode == 5'b01000); // LW
assign iType   = is_addi || is_sw || is_lw;


wire is_j, is_jal, is_bex, is_setx;
assign is_j     = (opcode == 5'b00001); // J
assign is_jal   = (opcode == 5'b00011); // JAL
assign is_bex   = (opcode == 5'b10110); // BEX
assign is_setx  = (opcode == 5'b10101); // SETX
assign jType1   = is_j || is_jal || is_bex || is_setx;


assign jType2 = (opcode == 5'b00100); // JR

endmodule
