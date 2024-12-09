`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (
	input wire [7:0] char_buffer_data,
    input wire [1:0] cpu_en,
	input wire [4:0] shift_amt_data,
	input wire [1:0] program_sel,
	input wire [11:0] read_addr,
	output wire [31:0] read_data,
	output wire [31:0] read_regA,
	output wire [7:0] read_ram,
	output wire [15:0] LED,
	input wire clock,
	input wire reset
	);

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, DictMemAddress, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut, DictMemDataOut;


	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "./Test Files/Memory Files/BF";
	localparam DICT_FILE = "./DICTMEM/dictionary";
	

	wire cpu_reset;
	assign cpu_reset = ~(cpu_en == CPU_EXEC);

	// assign LED[7:0] = read_ram;
	// assign LED[15:8] = shift_amt_data;
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(cpu_reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut),
		
		// DICTIONARY ROM
		.address_dictmem(DictMemAddress), .q_dictmem(DictMemDataOut)
		); 
	
	// Instruction Memory (ROM)	

	wire[31:0] instData_BF, instData_EN;
	ROM #(.MEMFILE("Test Files/Memory Files/FINAL_EN.mem"))
	InstMem_EN(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData_EN));

	ROM #(.MEMFILE("Test Files/Memory Files/FINAL_BF.mem"))
	InstMem_BF(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData_BF));

	assign instData = (program_sel == 2'b01) ? instData_EN :
						(program_sel == 2'b10) ? instData_BF :
						32'b0;


	// Dictionary Memory (ROM)
	ROM #(.MEMFILE({DICT_FILE, ".mem"}))
	DictMem(
		.clk(clock), 
        .addr(DictMemAddress[11:0]), 
        .dataOut(DictMemDataOut)
	);

	
	wire reg6_we = (shift_amt_data != 0); // Write when shift amount changes

    wire final_rwe = reg6_we || rwe;
	wire [4:0] final_rd = reg6_we ? 5'd6 : rd;
	wire [31:0] final_rData = reg6_we ? {27'b0, shift_amt_data} : rData;
	wire [4:0] read_6 = 5'd28;
	wire [4:0] final_read_reg_a_addr = rs1;
	assign read_regA = {31'b0, final_rd == 5'd28 && final_rData == 32'b1};

	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(final_rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(final_rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(final_rData), .data_readRegA(regA), .data_readRegB(regB));

	wire [31:0] finalData;
	wire [11:0] finalAddr;
	wire finalWEn;

	reg [7:0] char_write_counter = 0;
	localparam CPU_IDLE = 2'b00;
	localparam CPU_WRITE = 2'b01;
	localparam CPU_EXEC = 2'b10;
	// Update char_write_counter when writing characters
	always @(posedge clock) begin
		if (cpu_en == CPU_WRITE) begin
			if (char_write_counter < 108) // 108 is buffer size (12*9)
				char_write_counter <= char_write_counter + 1;
		end
	end

	assign finalData = (cpu_en == CPU_WRITE) ? {24'b0, char_buffer_data} : (cpu_en == CPU_EXEC) ? memDataIn : 32'b0;
	assign final_addr = (cpu_en == CPU_WRITE) ? (12'd1500 + char_write_counter) : (cpu_en == CPU_EXEC) ? memAddr[11:0] : read_addr;
	assign finalWEn = (cpu_en == CPU_WRITE) ? 1'b1 : (cpu_en == CPU_EXEC) ? mwe : 1'b0;
	assign read_ram = finalData[7:0];

	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(finalWEn), 
		.addr(final_addr), 
		.dataIn(finalData), 
		.dataOut(memDataOut));

	assign read_data = memDataOut;
	assign LED[11:0] = final_addr;
	

endmodule
