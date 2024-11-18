module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	// add your code here
	wire [31:0] regfile[31:0]; 

    assign regfile[0] = 32'b0;

    wire [31:0] write_enable;
	assign write_enable = ctrl_writeEnable? 1'b1 << ctrl_writeReg: 32'b0;

    reg32 r1 (.clk(clock), .reset(ctrl_reset), .we(write_enable[1]),  .data_in(data_writeReg), .data_out(regfile[1]));
    reg32 r2 (.clk(clock), .reset(ctrl_reset), .we(write_enable[2]),  .data_in(data_writeReg), .data_out(regfile[2]));
    reg32 r3 (.clk(clock), .reset(ctrl_reset), .we(write_enable[3]),  .data_in(data_writeReg), .data_out(regfile[3]));
	reg32 r4 (.clk(clock), .reset(ctrl_reset), .we(write_enable[4]),  .data_in(data_writeReg), .data_out(regfile[4]));
	reg32 r5 (.clk(clock), .reset(ctrl_reset), .we(write_enable[5]),  .data_in(data_writeReg), .data_out(regfile[5]));
	reg32 r6 (.clk(clock), .reset(ctrl_reset), .we(write_enable[6]),  .data_in(data_writeReg), .data_out(regfile[6]));
	reg32 r7 (.clk(clock), .reset(ctrl_reset), .we(write_enable[7]),  .data_in(data_writeReg), .data_out(regfile[7]));
	reg32 r8 (.clk(clock), .reset(ctrl_reset), .we(write_enable[8]),  .data_in(data_writeReg), .data_out(regfile[8]));
	reg32 r9 (.clk(clock), .reset(ctrl_reset), .we(write_enable[9]),  .data_in(data_writeReg), .data_out(regfile[9]));
	reg32 r10 (.clk(clock), .reset(ctrl_reset), .we(write_enable[10]), .data_in(data_writeReg), .data_out(regfile[10]));
	reg32 r11 (.clk(clock), .reset(ctrl_reset), .we(write_enable[11]), .data_in(data_writeReg), .data_out(regfile[11]));
	reg32 r12 (.clk(clock), .reset(ctrl_reset), .we(write_enable[12]), .data_in(data_writeReg), .data_out(regfile[12]));
	reg32 r13 (.clk(clock), .reset(ctrl_reset), .we(write_enable[13]), .data_in(data_writeReg), .data_out(regfile[13]));
	reg32 r14 (.clk(clock), .reset(ctrl_reset), .we(write_enable[14]), .data_in(data_writeReg), .data_out(regfile[14]));
	reg32 r15 (.clk(clock), .reset(ctrl_reset), .we(write_enable[15]), .data_in(data_writeReg), .data_out(regfile[15]));
	reg32 r16 (.clk(clock), .reset(ctrl_reset), .we(write_enable[16]), .data_in(data_writeReg), .data_out(regfile[16]));
	reg32 r17 (.clk(clock), .reset(ctrl_reset), .we(write_enable[17]), .data_in(data_writeReg), .data_out(regfile[17]));
	reg32 r18 (.clk(clock), .reset(ctrl_reset), .we(write_enable[18]), .data_in(data_writeReg), .data_out(regfile[18]));
	reg32 r19 (.clk(clock), .reset(ctrl_reset), .we(write_enable[19]), .data_in(data_writeReg), .data_out(regfile[19]));
	reg32 r20 (.clk(clock), .reset(ctrl_reset), .we(write_enable[20]), .data_in(data_writeReg), .data_out(regfile[20]));
	reg32 r21 (.clk(clock), .reset(ctrl_reset), .we(write_enable[21]), .data_in(data_writeReg), .data_out(regfile[21]));
	reg32 r22 (.clk(clock), .reset(ctrl_reset), .we(write_enable[22]), .data_in(data_writeReg), .data_out(regfile[22]));
	reg32 r23 (.clk(clock), .reset(ctrl_reset), .we(write_enable[23]), .data_in(data_writeReg), .data_out(regfile[23]));
	reg32 r24 (.clk(clock), .reset(ctrl_reset), .we(write_enable[24]), .data_in(data_writeReg), .data_out(regfile[24]));
	reg32 r25 (.clk(clock), .reset(ctrl_reset), .we(write_enable[25]), .data_in(data_writeReg), .data_out(regfile[25]));
	reg32 r26 (.clk(clock), .reset(ctrl_reset), .we(write_enable[26]), .data_in(data_writeReg), .data_out(regfile[26]));
	reg32 r27 (.clk(clock), .reset(ctrl_reset), .we(write_enable[27]), .data_in(data_writeReg), .data_out(regfile[27]));
	reg32 r28 (.clk(clock), .reset(ctrl_reset), .we(write_enable[28]), .data_in(data_writeReg), .data_out(regfile[28]));
	reg32 r29 (.clk(clock), .reset(ctrl_reset), .we(write_enable[29]), .data_in(data_writeReg), .data_out(regfile[29]));
	reg32 r30 (.clk(clock), .reset(ctrl_reset), .we(write_enable[30]), .data_in(data_writeReg), .data_out(regfile[30]));
    reg32 r31 (.clk(clock), .reset(ctrl_reset), .we(write_enable[31]),  .data_in(data_writeReg), .data_out(regfile[31]));

    assign data_readRegA = regfile[ctrl_readRegA];
    assign data_readRegB = regfile[ctrl_readRegB];

endmodule
