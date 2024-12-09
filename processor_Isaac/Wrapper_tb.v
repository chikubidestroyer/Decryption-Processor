`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to test your processor for functionality.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. 
 * You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v 
 * and memory modules to work with the Wrapper interface as provided.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must set the parameter when compiling to use the memory file of 
 * the test you created using the assembler and load the appropriate 
 * verification file.
 *
 * For example, you would add sample as your parameter after assembling sample.s
 * using the command
 *
 * 	 iverilog -o proc -c FileList.txt -s Wrapper_tb -PWrapper_tb.FILE=\"sample\"
 *
 * Note the backslashes (\) preceding the quotes. These are required.
 *
 **/

module Wrapper_tb #(parameter FILE = "BF") (
    input wire [7:0] char_buffer_data,
    input wire char_buffer_we,
	input wire [4:0] shift_amt_data,
	input wire [1:0] program_sel,
	input wire [11:0] read_addr,
	output wire [31:0] read_data,
	output wire [31:0] read_regA
);
	// FileData
	localparam DIR = "Test Files/";
	localparam MEM_DIR = "Memory Files/";
	localparam OUT_DIR = "Output Files/";
	localparam VERIF_DIR = "Verification Files/";
	localparam DEFAULT_CYCLES = 5000;

	// Inputs to the processor
	reg clock = 0, reset = 0;

	// I/O for the processor
	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, DictMemAddress, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut, DictMemDataOut;

	// Wires for Test Harness
	wire[4:0] rs1_test, rs1_in;
	reg testMode = 0; 
	reg[20:0] num_cycles = DEFAULT_CYCLES;
	reg[15*8:0] exp_text;
	reg null;

	// Connect the reg to test to the for loop
	assign rs1_test = reg_to_test;

	// Hijack the RS1 value for testing
	assign rs1_in = testMode ? rs1_test : rs1;

	// Expected Value from File
	reg signed [31:0] exp_result;

	// Where to store file error codes
	integer expFile, diffFile, actFile, expScan; 

	// Do Verification
	reg verify = 1;

	// Metadata
	integer errors = 0,
			cycles = 0,
			reg_to_test = 0;

	// Add to module port list
	


	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut),
		
		// Dictionary Memory
		.address_dictmem(DictMemAddress),
		.q_dictmem(DictMemDataOut)); 
	
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
	
	// Register File
	wire reg6_we = (shift_amt_data != 0); // Write when shift amount changes

    wire final_rwe = reg6_we || rwe;
	wire [4:0] final_rd = reg6_we ? 5'd6 : rd;
	wire [31:0] final_rData = reg6_we ? {27'b0, shift_amt_data} : rData;
	wire [4:0] read_6 = 5'd6;
	assign read_regA = regA;

	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(final_rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(final_rd),
		.ctrl_readRegA(read_6), .ctrl_readRegB(rs2), 
		.data_writeReg(final_rData), .data_readRegA(regA), .data_readRegB(regB));

	wire [31:0] finalData;
	wire [11:0] finalAddr;
	wire finalWEn;

	reg [7:0] char_write_counter = 0;

	// Update char_write_counter when writing characters
	always @(posedge clock) begin
		if (char_buffer_we) begin
			if (char_write_counter < 108) // 108 is buffer size (12*9)
				char_write_counter <= char_write_counter + 1;
		end
	end

	assign finalData = char_buffer_we ? {24'b0,char_buffer_data} : memDataIn;
	assign final_addr = char_buffer_we ? (12'd1500 + char_write_counter) : memAddr[11:0];
	assign finalWEn = char_buffer_we ? 1'b1 : mwe;

	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(finalWEn), 
		.addr(final_addr), 
		.dataIn(finalData), 
		.dataOut(memDataOut));

	assign read_data = memDataOut;

	localparam DICT_FILE = "./DICTMEM/dictionary";

	// Dictionary Memory (ROM)
	ROM #(.MEMFILE({DICT_FILE, ".mem"}))
	DictMem(
		.clk(clock), 
        .addr(DictMemAddress[11:0]), 
        .dataOut(DictMemDataOut)
	);

	// Create the clock
	always
		#10 clock = ~clock; 

	//////////////////
	// Test Harness //
	//////////////////

	initial begin
		// Check if the parameter exists
		if(FILE == 0) begin
			$display("Please specify the test");
			$finish;
		end

		$display({"Loading ", FILE, ".mem\n"});

		// Read the expected file
		expFile = $fopen({DIR, VERIF_DIR, FILE, "_exp.txt"}, "r");

			// Check for any errors in opening the file
		if(!expFile) begin
			$display("Couldn't read the expected file.",
				"\nMake sure there is a %0s_exp.txt file in the \"%0s\" directory.", FILE, {DIR ,VERIF_DIR});
			$display("Continuing for %0d cycles without checking for correctness,\n", DEFAULT_CYCLES);
			verify = 0;
		end

		// Output file name
		$dumpfile({DIR, OUT_DIR, FILE, ".vcd"});
		// Module to capture and what level, 0 means all wires
		$dumpvars(0, Wrapper_tb);

		$display();

		// Create the files to store the output
		actFile = $fopen({DIR, OUT_DIR, FILE, "_actual.txt"},   "w");

		if (verify) begin
			diffFile = $fopen({DIR, OUT_DIR, FILE, "_diff.txt"},  "w");

			// Get the number of cycles from the file
			expScan = $fscanf(expFile, "num cycles:%d", 
				num_cycles);

			// Check that the number of cycles was read
			if(expScan != 1) begin
				$display("Error reading the %0s file.", {FILE, "_exp.txt"});
				$display("Make sure that file starts with \n\tnum cycles:NUM_CYCLES");;
				$display("Where NUM_CYCLES is a positive integer\n");
			end
		end

		// Clear the Processor at the beginning
		reset = 1;
		#1
		reset = 0;

		// Run for the number of cycles specified 
		for (cycles = 0; cycles < num_cycles; cycles = cycles + 1) begin
			
			// Every rising edge, write to the actual file
			@(posedge clock);
			if (rwe && rd != 0) begin
				$fdisplay(actFile, "Cycle %3d: Wrote %0d into register %0d", cycles, rData, rd);
			end
		end

		$fdisplay(actFile, "============== Testing Mode ==============");

		if (verify)
			$display("\t================== Checking Registers ==================");

		// Activate the test harness
		testMode = 1;

		// Check the values in the regfile
		for (reg_to_test = 0; reg_to_test < 32; reg_to_test = reg_to_test + 1) begin
			
			if (verify) begin
				// Obtain the register value
				expScan =  $fscanf(expFile, "%s", exp_text);
				expScan = $sscanf(exp_text, "r%d=%d", null, exp_result);

				// Check for errors when reading
				if (expScan != 2) begin
					$display("Error reading value for register %0d.", reg_to_test);
					$display("Please make sure the value is in the format");
					$display("\tr%0d=EXPECTED_VALUE", reg_to_test);

					// Close the Files
					$fclose(expFile);
					$fclose(actFile);
					$fclose(diffFile);

					#100;
					$finish;
				end
			end 
			
			// Allow the regfile output value to stabilize
			#1;

			// Write the register value to the actual file
			$fdisplay(actFile, "Reg %2d: %11d", rs1_test, regA);
			
			// Compare the Values 
			if (verify) begin
				if (exp_result !== regA) begin
					$fdisplay(diffFile, "Reg: %2d Expected: %11d Actual: %11d",
						rs1_test, $signed(exp_result), $signed(regA));
					$display("\tFAILED Reg: %2d Expected: %11d Actual: %11d",
						rs1_test, $signed(exp_result), $signed(regA));
					errors = errors + 1;
				end else begin
					$display("\tPASSED Reg: %2d", rs1_test);
				end
			end
		end

		// Close the Files
		$fclose(expFile);
		$fclose(actFile);

		if (verify)
			$fclose(diffFile);

		// Display the tests and errors
		if (verify)
			$display("\nFinished %0d cycle%c with %0d error%c", cycles, "s"*(cycles != 1), errors, "s"*(errors != 1));
		else 
			$display("Finished %0d cycle%c", cycles, "s"*(cycles != 1));

		#100;
		$finish;
	end
endmodule
