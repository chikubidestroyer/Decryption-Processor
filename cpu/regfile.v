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
	wire [31:0] writeDecode, writeEnable;
	wire [31:0] registers [0:31]; // 32 32-bit registers outputs
	assign registers[0] = 32'b0;
	genvar i;
	generate// generate 32 32-bit registers
		for (i =1; i< 32; i = i+1) begin : gen_reg
			reg32bit regis(
				.data_writeReg(data_writeReg),
				.clock(clock),
				.ctrl_writeEnable(writeEnable[i]),
				.ctrl_reset(ctrl_reset),
				.data_readReg(registers[i])
			);
		end
	endgenerate

	decoder dec_write(.out(writeDecode), .select(ctrl_writeReg));
	assign writeEnable[0] = 1'b0; //can't change register 0 ever
	genvar j;
	generate
		for(j =1; j<32; j = j+1) begin : gen_writeEnable
			and (writeEnable[j], ctrl_writeEnable, writeDecode[j]);
		end
	endgenerate

	wire [31:0] readDecodeA, readDecodeB;
	decoder decA(.out(readDecodeA), .select(ctrl_readRegA));
	decoder decB(.out(readDecodeB), .select(ctrl_readRegB));

	assign data_readRegA = readDecodeA[0] ? registers[0] :
							readDecodeA[1] ? registers[1] :
							readDecodeA[2] ? registers[2] :
							readDecodeA[3] ? registers[3] :
							readDecodeA[4] ? registers[4] :
							readDecodeA[5] ? registers[5] :
							readDecodeA[6] ? registers[6] :
							readDecodeA[7] ? registers[7] :
							readDecodeA[8] ? registers[8] :
							readDecodeA[9] ? registers[9] :
							readDecodeA[10] ? registers[10] :
							readDecodeA[11] ? registers[11] :
							readDecodeA[12] ? registers[12] :
							readDecodeA[13] ? registers[13] :
							readDecodeA[14] ? registers[14] :
							readDecodeA[15] ? registers[15] :
							readDecodeA[16] ? registers[16] :
							readDecodeA[17] ? registers[17] :
							readDecodeA[18] ? registers[18] :
							readDecodeA[19] ? registers[19] :
							readDecodeA[20] ? registers[20] :
							readDecodeA[21] ? registers[21] :
							readDecodeA[22] ? registers[22] :
							readDecodeA[23] ? registers[23] :
							readDecodeA[24] ? registers[24] :
							readDecodeA[25] ? registers[25] :
							readDecodeA[26] ? registers[26] :
							readDecodeA[27] ? registers[27] :
							readDecodeA[28] ? registers[28] :
							readDecodeA[29] ? registers[29] :
							readDecodeA[30] ? registers[30] :
							readDecodeA[31] ? registers[31] : 32'b0;

	assign data_readRegB = readDecodeB[0] ? registers[0] :
							readDecodeB[1] ? registers[1] :
							readDecodeB[2] ? registers[2] :
							readDecodeB[3] ? registers[3] :
							readDecodeB[4] ? registers[4] :
							readDecodeB[5] ? registers[5] :
							readDecodeB[6] ? registers[6] :
							readDecodeB[7] ? registers[7] :
							readDecodeB[8] ? registers[8] :
							readDecodeB[9] ? registers[9] :
							readDecodeB[10] ? registers[10] :
							readDecodeB[11] ? registers[11] :
							readDecodeB[12] ? registers[12] :
							readDecodeB[13] ? registers[13] :
							readDecodeB[14] ? registers[14] :
							readDecodeB[15] ? registers[15] :
							readDecodeB[16] ? registers[16] :
							readDecodeB[17] ? registers[17] :
							readDecodeB[18] ? registers[18] :
							readDecodeB[19] ? registers[19] :
							readDecodeB[20] ? registers[20] :
							readDecodeB[21] ? registers[21] :
							readDecodeB[22] ? registers[22] :
							readDecodeB[23] ? registers[23] :
							readDecodeB[24] ? registers[24] :
							readDecodeB[25] ? registers[25] :
							readDecodeB[26] ? registers[26] :
							readDecodeB[27] ? registers[27] :
							readDecodeB[28] ? registers[28] :
							readDecodeB[29] ? registers[29] :
							readDecodeB[30] ? registers[30] :
							readDecodeB[31] ? registers[31] : 32'b0;

endmodule
