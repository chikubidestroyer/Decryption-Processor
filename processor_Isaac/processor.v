/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
	
    // IF components
    assign address_imem = FPC;
    wire [31:0] FPC, nextFPC, defaultNextFPC;

    wire multdiv_stall;

    wire interlock_stall;

    assign interlock_stall = ((XIRout[31:27] == 5'b01000) && (ctrl_readRegA == XIRout[26:22] || ctrl_readRegB == XIRout[26:22]));

    wire PC_stall;
    assign PC_stall = multdiv_stall || interlock_stall;

    PC pc(nextFPC, ~clock, PC_stall, reset, FPC);    
    cla_add default_next_pc(.s(defaultNextFPC), .a(FPC), .b(32'b1), .Cin(1'b0));
    assign nextFPC = reset? 32'b0: 
                            (branch_select) ? 
                                final_PC:
                                defaultNextFPC;
    assign address_imem = FPC;

    wire [31:0] DIRout, DPC, DIRIn;
    wire [1:0] DInsType;

    assign DIRIn = branch_select? 32'b0 : q_imem;

    wire D_stall;
    assign D_stall = multdiv_stall || interlock_stall;
                            
    wire [31:0] DTG;
    FD fd_pipeline(DIRout, DPC, DTG, DIRIn, defaultNextFPC, defaultNextFPC, ~clock, D_stall, reset);

    // Decode

    wire[4:0] opcode, rd, rs, rt, shamt, ALUop;
    Decoder Decode(.type(DInsType), .Opcode(opcode), .rd(rd), .rs(rs), .rt(rt), .shamt(shamt), .ALUop(ALUop), .instruction(DIRout));
    assign ctrl_readRegA = rs;
    assign ctrl_readRegB = (DInsType == 2'b00)?  rt: //R type
                            (DInsType == 2'b01)? rd: // I type
                            (DInsType == 2'b10) ? 5'b11110: // JI type, being rstatus
                            rd; // JII
    // Execute
    
    wire [31:0] XIRout, XAout, XBout, XIRin, XAin, XBin, XPCout, XTGout;

    assign XAin = (DIRout[31:27] == 10110) ? 32'b0: // bex
                    data_readRegA;
    
    assign XBin = data_readRegB; 

    assign XIRin = branch_select || interlock_stall? 32'b0 : DIRout;
    
    wire X_stall;
    assign X_stall =multdiv_stall;

    DX dx_pipeline(XIRout, XAout, XBout, XPCout, XTGout, XIRin, XAin, XBin, DPC, DTG, ~clock, X_stall, reset);

    wire[1:0] XIR_type;
    Decoder Xdecode (.type(XIR_type), .instruction(XIRout));

    wire [14:0] extended_15;
    assign extended_15 = XIRout[16]? 15'b111111111111111: 15'b0; // extending by 15 bits
    
    assign multdiv_stall = (XIRout[31:27] == 5'b0) && (XIRout[6:2] == 5'b0011x) && (~multdiv_ready) ? 1'b1 : 1'b0;


    wire [31:0] ALU_data_result;
    wire ALU_overflow, ALU_ne, ALU_lt;

    wire [4:0] ALUopcode;
    assign ALUopcode = (XIRout[31:27] == 5'b0) ? XIRout[6:2] :  // normal type R ALU operations
                        (XIRout[31:27] == 5'b00101 || XIRout[31:27] == 5'b00111 || XIRout[31:27] == 5'b01000) ? 5'b00000: // add for type I instructions
                        5'bz;

    wire isRdModifiedInW, isRdModifiedInM;
    isRdModified checkModificationW(WIRout, isRdModifiedInW);
    isRdModified checkModificationM(MIRout, isRdModifiedInM);

    wire [31:0] ALU_B_in, ALU_A_in; // what actually goes into the ALU
    assign ALU_B_in = (XIRout[31:27] == 5'b00101 || XIRout[31:27] == 5'b00111 || XIRout[31:27] == 5'b01000)? {extended_15, XIRout[16:0]}:
                    (MregToWriteTO == XIRout[16:12] && XIR_type != 2'b01 && XIR_type != 2'b10) ? WOin : // bypass from Memory Stage for Rt in type R ins
                    (MregToWriteTO == XIRout[26:22] && XIR_type == 2'b01)? (MIRout[31:27] == 5'b01000) ? WDin: WOin: // bypass from Memory Stage for Rd in type I ins
                    (MregToWriteTO == 5'b11110 && XIRout[31:27] == 5'b10110) ? WOin: // bypass from Mem stage for rstatus in bex ins
                    (ctrl_writeReg == XIRout[16:12] && XIR_type != 2'b01 && XIR_type != 2'b10) ? data_writeReg: // bypass from Write Back Stage for Rt in type R ins
                    (ctrl_writeReg == XIRout[26:22] && XIR_type == 2'b01)? data_writeReg: // bypass from Write back stage for Rd in type I ins
                    (ctrl_writeReg == 5'b11110 && XIRout[31:27] == 5'b10110) ? data_writeReg: // bypass from WB stage for rstatus in bex ins
                    XBout;
    assign ALU_A_in = (MregToWriteTO == XIRout[21:17]) ? (MIRout[31:27] == 5'b01000) ? WDin: WOin : // bypass from Memory Stage
                        (ctrl_writeReg == XIRout[21:17]) ? data_writeReg: // bypass from Write back stage
                        (XIRout[31:27] == 5'b10110) ? 5'b0: // set A as 0 for bex
                        XAout; 

    alu main_alu (.data_operandA(ALU_A_in), .data_operandB(ALU_B_in), .ctrl_ALUopcode(ALUopcode), .ctrl_shiftamt(XIRout[11:7]), 
                            .data_result(ALU_data_result), .overflow(ALU_overflow), .isNotEqual(ALU_ne), .isLessThan(ALU_lt));
    wire[31:0] ALU_result;

    // Branch Control
    wire [31:0] added_PC, final_PC;
    wire PC_overflow, isBranchIns, branchConditionsPassed;
    wire[14:0] N_sign_extend;
    assign N_sign_extend = XIRout[16]? 15'b111111111111111 : 15'b0;
    cla_add Xpc_adder (.a(XPCout), .b({N_sign_extend, XIRout[16:0]}) , .s(added_PC), .overflow(PC_overflow), .Cin(1'b0));
    assign isBranchIns = (XIRout[31:27] == 5'b00001) 
                        || (XIRout[31:27] == 5'b00010) 
                        || (XIRout[31:27] == 5'b00011) 
                        || (XIRout[31:27] == 5'b00100)
                        || (XIRout[31:27] == 5'b00110)
                        || (XIRout[31:27] == 5'b10110);
    assign branchConditionsPassed = isBranchIns ? 
                                        (XIRout[31:27] == 5'b00001) ? 1'b1: // j
                                        (XIRout[31:27] == 5'b00010)? ALU_ne: // bne
                                        (XIRout[31:27] == 5'b00011)? 1'b1: // jal
                                        (XIRout[31:27] == 5'b00100)? 1'b1: // jr
                                        (XIRout[31:27] == 5'b00110) ? (ALU_ne && ~ALU_lt): // blt
                                        (XIRout[31:27] == 5'b10110) ? ALU_ne: // bex
                                        1'bx
                                    : 1'b0;

    wire[4:0] T_sign_extend;
    assign T_sign_extend = XIRout[26]? 5'b11111 : 5'b0;
    assign final_PC = (XIRout[31:27] == 5'b00001) ? {T_sign_extend, XIRout[26:0]}: // j
                            (XIRout[31:27] == 5'b00010)? added_PC: // bne
                            (XIRout[31:27] == 5'b00011)? {T_sign_extend, XIRout[26:0]}: // jal
                            (XIRout[31:27] == 5'b00100)? // jr
                                (isRdModifiedInM && MregToWriteTO == XIRout[26:22]) ? 
                                    (MIRout[31:27] == 5'b01000) ? WDin:
                                    WOin
                                : (isRdModifiedInW && ctrl_writeReg == XIRout[26:22])?
                                    data_writeReg:
                                    XBout:
                            (XIRout[31:27] == 5'b00110) ? added_PC: // blt
                            (XIRout[31:27] == 5'b10110) ? {T_sign_extend, XIRout[26:0]}: //bex
                            32'bx;

    wire branch_select;
    assign branch_select = branchConditionsPassed && isBranchIns;

    wire [31:0] newIR; // for determining whether if IR has changed
    reg32 multdivControlCheckSame( ~clock, 1'b0, 1'b1, XIRout, newIR);

    wire isMult, isDiv;
    assign isMult = (XIRout[31:27] == 5'b00000 && XIRout[6:2] == 5'b00110 && newIR != XIRout)? 1'b1: 1'b0;
    assign isDiv = (XIRout[31:27] == 5'b00000 && XIRout[6:2] == 5'b00111 && newIR != XIRout)? 1'b1: 1'b0;
    wire [31:0] multdiv_result;
    wire multdiv_ready, multdiv_exception;

    wire exception;
    assign exception = (XIRout[31:27] == 5'b00000 && XIRout[6:3] == 5'b0011 && multdiv_ready)? multdiv_exception: ALU_overflow;
    multdiv alu_multdiv(.data_operandA(ALU_A_in), .data_operandB(ALU_B_in), 
        .ctrl_MULT(isMult), .ctrl_DIV(isDiv), 
        .clock(~clock), 
        .data_result(multdiv_result), .data_exception(multdiv_exception), .data_resultRDY(multdiv_ready));
    assign ALU_result = (XIRout[31:27] == 5'b00000 && XIRout[6:3] == 5'b0011 && multdiv_ready)? multdiv_result: ALU_data_result;

    wire [31:0] MIRout, MOout, MBout, MIRin, MOin, MBin;
    wire XisSave;
    assign XisSave = XIRout[31:27] == 5'b00111;
    wire M_stall, M_exception;
    assign MIRin = XIRout;
    assign MOin = (XIRout[31:27] == 5'b00011) ? XPCout: // jal
                    (XIRout[31:27] == 5'b10101) ? {T_sign_extend, XIRout[26:0]}: // setx
                    ALU_result;
    assign MBin = (MregToWriteTO == XIRout[26:22] && isRdModifiedInM && XisSave) ? MOout : // bypass from Memory Stage
                    (WIRout[26:22] == XIRout[26:22] && isRdModifiedInW && XisSave) ? data_writeReg: // bypass from Write back stage
                    XBout;
    assign M_stall = multdiv_stall;
    XM xm_pipeline(MOout, MBout, MIRout, M_exception, MOin, MBin, MIRin, exception, ~clock, M_stall, reset);

    // Memory

    wire [31:0] WIRout, WOout, WDout, WIRin, WOin, WDin;
    wire[1:0] MIR_type;
    Decoder Mdecode (.type(MIR_type), .instruction(MIRout));
    assign WIRin = MIRout; 
    assign WOin = 
            (MIRout[26:22] == 5'b0 && MIR_type != 2'b10) ? 32'b0: // when rd == 0, set output as 0
            ((MIRout[31:27] == 5'b00000 || MIRout[31:27] == 5'b00101) && ~M_exception)?  MOout:
            (MIRout[31:27] == 5'b00000 && MIRout[6:2] == 5'b00000)? 32'b1: // overflow on add
            (MIRout[31:27] == 5'b00101) ? 32'd2: // overflow on addi
            (MIRout[31:27] == 5'b00000 && MIRout[6:2] == 5'b00001) ? 32'd3: // overflow on sub
            (MIRout[31:27] == 5'b00000 && MIRout[6:2] == 5'b00110) ? 32'd4: // overflow on mult
            (MIRout[31:27] == 5'b00000 && MIRout[6:2] == 5'b00111) ? 32'd5: // exception on division
            (MIRout[31:27] == 5'b00011) ? MOout: // jal
            (MIRout[31:27] == 5'b10101) ? MOout: // setx
            32'd0; // write 0 to reg 0 ideally;
    wire[4:0] MregToWriteTO;
    assign MregToWriteTO = ((MIRout[31:27] == 5'b00000 || MIRout[31:27] == 5'b00101) && ~M_exception)?  MIRout [26:22]: // regular
            ((MIRout[31:27] == 5'b00000 || MIRout[31:27] == 5'b00101) && M_exception) ? 5'b11110: //exception occurred
            (MisLoad) ? MIRout[26:22]: // load
            (MIRout[31:27] == 5'b00011) ? 5'b11111: // jal
            (MIRout[31:27] == 5'b10101) ? 5'b11110: // setx
            5'd0; // write to reg 0


    wire W_stall, W_exception_out;
    assign W_stall = multdiv_stall;
    assign MisLoad = MIRout[31:27] == 5'b01000;
    assign MisSave = MIRout[31:27] == 5'b00111;
    
    assign address_dmem = MisLoad || MisSave? MOout: 5'dx;
    assign data = 
                (MIRout[31:27] == 5'b00111 && MIRout[26:22] == ctrl_writeReg)? data_writeReg:
                MBout;

    assign wren = MisSave;
    assign WDin = isRdModifiedInW? 
                        (MIRout[26:22] == WIRout[26:22])? data_writeReg : q_dmem
                    : q_dmem;

    wire [31:0] newMemIR; // for determining whether if IR has changed
    reg32 memCheckSame( ~clock, 1'b0, 1'b1, MIRout, newMemIR);
    
    wire mem_ready, in_mem_counter, out_mem_counter;
    assign in_mem_counter = (MIRout != newMemIR && MIRout[31:27] == 5'b01000)? 1'b1 : 1'b0;

    dffe_ref memCounter(out_mem_counter, in_mem_counter, ~clock, 1'b1, reset);
    wire loadRdy;
    assign loadRdy = ~out_mem_counter;


    MW mw_pipeline(WOout, WDout, WIRout, W_exception_out, WOin, WDin, WIRin, M_exception, ~clock, W_stall, reset);

    // Writeback

    wire WisLoad;
    assign WisLoad = WIRout[31:27] == 5'b01000;

    assign data_writeReg = (WisLoad) ? WDout: // load
                            WOout;
    assign ctrl_writeReg = ((WIRout[31:27] == 5'b00000 || WIRout[31:27] == 5'b00101) && ~W_exception_out)?  WIRout [26:22]: // regular
            ((WIRout[31:27] == 5'b00000 || WIRout[31:27] == 5'b00101) && W_exception_out) ? 5'b11110: //exception occurred
            (WisLoad) ? WIRout[26:22]: // load
            (WIRout[31:27] == 5'b00011) ? 5'b11111: // jal
            (WIRout[31:27] == 5'b10101) ? 5'b11110: // setx
            5'd0; // write to reg 0
    
    
    assign ctrl_writeEnable = ctrl_writeReg != 5'b00000 &&
                            (WIRout [31:27] == 5'b00000 
                            || WIRout [31:27] == 5'b00101 
                            || WisLoad 
                            || WIRout [31:27] == 5'b00011 
                            || WIRout [31:27] == 5'b10101);

	/* END CODE */

endmodule
