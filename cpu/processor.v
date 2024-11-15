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

    //FETCH CYCLE
    //program counter
    wire [31:0] pc_add_1, pc_next, pc_post;
    wire select_pc;
    wire pc_we;
    wire isBranch;
    
        reg32bit pc_reg(
            .data_writeReg(pc_next),
            .data_readReg(address_imem),
            .clock(!clock),
            .ctrl_writeEnable(pc_we),
            .ctrl_reset(reset)
        );
        cla32bit pc_adder(
            .data_operandA(address_imem),
            .data_operandB(32'b1),
            .sub(1'b0),
            .Sum(pc_add_1),
            .Cout()
        );
        mux_2 jump_mux(
            .out(pc_next),
            .in0(pc_add_1),
            .in1(pc_post),
            .select(isBranch)
        );
    
    //fd_latch
    wire [31:0] fd_IR_in;
    assign fd_IR_in = isBranch ? 32'b0 : q_imem;
    wire fd_we;
    wire [31:0] fd_PC_out,fd_IR_out;
        fd_latch fd(
            .programCount_in(pc_add_1),
            .IR_in(fd_IR_in),
            .clock(!clock),
            .reset(reset),
            .fd_we(fd_we),
            .programCount_out(fd_PC_out),
            .IR_out(fd_IR_out)
        );


    //decode cycle
        //outputs of mw latch
        wire [31:0] mw_O_out,mw_D_out,mw_IR_out;

    wire [4:0] opcode_fd,rd_fd,rt_fd;
    wire j2Type_fd;
        opdecoder decode_fd(
            .instruction(fd_IR_out),
            .opcode(opcode_fd),
            .rd(rd_fd),
            .rs(ctrl_readRegA),
            .rt(rt_fd),
            .shamt(),
            .alu_op(),
            .imm(),
            .jump_target(),
            .rType(),
            .iType(),
            .jType1(),
            .jType2(j2Type_fd)
        );

    wire [4:0] rd_rt_choice;
        assign rd_rt_choice = ((opcode_fd == 5'b00111) || (opcode_fd == 5'b00010) || (opcode_fd == 5'b00110) || j2Type_fd) // sw, bne, blt, 
                ? rd_fd : rt_fd;
        assign ctrl_readRegB = (opcode_fd == 5'b10110) ? 5'b11110 : rd_rt_choice; //bex
    
    wire mult_operation,ctrl_mult,ctrl_div;
    wire dx_mux_control;
    wire [31:0] dx_IR_in1, dx_IR_in2;
    
        mux_2 choose_ir(//insert nop for mult/div
            .out(dx_IR_in1),
            .in0(fd_IR_out),
            .in1(32'b0),
            .select (dx_mux_control)
        ); 
        
        mux_2 branch_ir( //should flush pipelines on branch
            .out(dx_IR_in2),
            .in0(dx_IR_in1),
            .in1(32'b0),
            .select(isBranch)
        );
   
    wire [31:0] dx_PC_out,dx_A_out,dx_B_out,dx_IR_out;
    dx_latch dx(
        .programCount_in(fd_PC_out),
        .IR_in(dx_IR_in2),
        .data_readRegA(data_readRegA),
        .data_readRegB(data_readRegB),
        .clock(!clock),
        .reset(reset),
        .dx_en(!(mult_operation || ctrl_mult || ctrl_div)), //temp value
        .programCount_out(dx_PC_out),
        .IR_out(dx_IR_out),
        .a(dx_A_out),
        .b(dx_B_out)
    );
    //execute cycle
    wire [31:0] alu_out;
    wire isNotEqual, isLessThan, alu_overflow;
    
    wire [4:0] opcode_dx,shamt_dx,alu_op_dx, rd_dx,a_dx,b_dx;
    wire [16:0] imm_dx;
    wire [26:0] target_dx;
    wire rType_dx,iType_dx,j1Type_dx,j2Type_dx;
    
    wire [31:0] alu_in_b;
    wire [4:0] alu_op_in;
    
        opdecoder decode_dx(
            .instruction(dx_IR_out),
            .opcode(opcode_dx),
            .rd(rd_dx),
            .rs(a_dx),
            .rt(b_dx),
            .shamt(shamt_dx),
            .alu_op(alu_op_dx),
            .imm(imm_dx),
            .jump_target(target_dx),
            .rType(rType_dx),
            .iType(iType_dx),
            .jType1(j1Type_dx),
            .jType2(j2Type_dx)
        );

    //stall
    stall stalled(
            .fd_we(fd_we),
            .pc_we(pc_we),
            .dx_mux_control(dx_mux_control),
            .fd_opcode(opcode_fd),
            .fd_rs(ctrl_readRegA),
            .fd_rt(ctrl_readRegB),
            .dx_opcode(opcode_dx),
            .dx_rd(rd_dx),
            .mult_operation(mult_operation),
            .multdiv_at_dx(ctrl_mult || ctrl_div)
        );
    wire [31:0] reg_A_bypass,reg_B_bypass;

    wire [31:0] imm_extended;
    assign imm_extended[16:0] = imm_dx[16:0];
    assign imm_extended[31:17] = imm_dx[16] ? 15'b111111111111111 : 15'b0;
        
    
    wire [1:0] use_imm;
    assign use_imm[0] = iType_dx && !(opcode_dx == 5'b00010) && !(opcode_dx == 5'b00110); //for iTypes
    assign use_imm[1] = ((opcode_dx == 5'b00010) || (opcode_dx == 5'b00110)); //for branch and jump
    assign alu_in_b = use_imm[0] ? imm_extended : reg_B_bypass;
        mux_4 alu_op_mux(
            .out(alu_op_in),
            .in0(alu_op_dx),
            .in1(5'b0), //beq
            .in2(5'b00001), //blt
            .in3(alu_op_dx),
            .select(use_imm)
        );
        alu processor_alu(reg_A_bypass, alu_in_b, alu_op_in, shamt_dx, alu_out, isNotEqual, isLessThan, alu_overflow);

    //branch or jump
    wire [31:0] b_pc,j1Type_pc, j2Type_pc;
        cla32bit branch_adder(
            .data_operandA(dx_PC_out),
            .data_operandB(imm_extended),
            .sub(1'b0),
            .Sum(b_pc),
            .Cout()
        );
    assign j1Type_pc = j1Type_dx ? target_dx : b_pc; //j type
    assign j2Type_pc = j2Type_dx ? alu_in_b : j1Type_pc;//jr
    assign pc_post = j2Type_pc;
    assign isBranch = (opcode_dx == 5'b00010 && alu_out != 5'b0) || //bne
        (opcode_dx == 5'b00110 && !alu_out[31] && alu_out != 5'b0) || //blt
        (j1Type_dx && opcode_dx != 5'b10101 && opcode_dx != 5'b10110) || //jtype
        j2Type_dx || (opcode_dx == 5'b10110 && alu_in_b!=32'b0); // jr 
    //assign r31 for jal
    wire [31:0] jal_in;
    assign jal_in [31:27] = dx_IR_out[31:27];
    assign jal_in [26:22] = opcode_dx == 5'b00011 ? 5'b11111 : setx [26:22] ;
    assign jal_in [21:0] = dx_IR_out[21:0]; 
    // overflow
    wire [31:0] xm_IR_ovfl; //write to r30 if overflow
    wire overflow;

    assign overflow = alu_overflow | (multdiv_exception & data_resultRDY);
    assign xm_IR_ovfl [31:27] = dx_IR_out[31:27];
    assign xm_IR_ovfl [26:22] = overflow ? 5'b11110 : rd_dx;
    assign xm_IR_ovfl [21:0] = dx_IR_out[21:0];
    wire [31:0] exception_code;
    assign exception_code = (overflow) ? (
        (data_resultRDY && (alu_op_md == 5'b00110)) ? 32'd4 :  // Mult overflow using latched alu_op
        (data_resultRDY && (alu_op_md == 5'b00111)) ? 32'd5 :  // Div exception using latched alu_op
        (opcode_dx == 5'b00101) ? 32'd2 :          // Addi overflow
        (alu_op_dx == 5'b00000) ? 32'd1 :          // Add overflow
        (alu_op_dx == 5'b00001) ? 32'd3 :          // Sub overflow
        32'd0
    ) : alu_out;
    // wire [31:0] add_ovfl,addi_ovfl,sub_ovfl; //specific overflow for add, addi, sub
    // assign add_ovfl = (overflow && alu_op_dx==5'b0) ? 32'b1 : alu_out;
    // assign addi_ovfl = (overflow && opcode_dx==5'b00101) ? 32'b10 : add_ovfl;
    // assign sub_ovfl = (overflow && alu_op_dx==5'b00001) ? 32'b11 : addi_ovfl;
    
    // assign mult_ovfl = (overflow && alu_op_dx==5'b00110) ? 32'b100 : mult_result;
    // assign div_ovfl = (overflow && alu_op_dx==5'b00111) ? 32'b101 : mult_ovfl;
    
    wire [31:0] setx,setx_data; //set exception 
    assign setx [31:27] = dx_IR_out[31:27];
    assign setx [26:22] = (opcode_dx == 5'b10101)? 5'b11110 : xm_IR_ovfl[26:22];
    assign setx [21:0] = dx_IR_out[21:0];

    assign setx_data = (opcode_dx == 5'b10101) ? target_dx : exception_code;

    wire [31:0] data_xm;
    assign data_xm = (opcode_dx == 5'b00011) ? dx_PC_out : setx_data;
    
    //assign to latch
    wire [31:0] xm_jal,xm_nop; 
    assign xm_nop = mult_operation ? 32'b0 : jal_in;

    wire [31:0] xm_O_out,xm_B_out,xm_IR_out;
    xm_latch xm(
        .o_in(data_xm),
        .b_in(reg_B_bypass),
        .IR_in(xm_nop),
        .clock(!clock),
        .reset(reset),
        .xm_en(1'b1), //temp value
        .xm_o_out(xm_O_out),
        .xm_b_out(xm_B_out),
        .xm_ir_out(xm_IR_out)
    );
    //multiplication this shit broken
    wire data_resultRDY;
    wire [31:0] instruct;
    wire [31:0] mult_result;
    wire[31:0] mult_a, mult_b;
    assign ctrl_mult = (opcode_dx==5'b0) && (alu_op_in == 5'b00110);
    assign ctrl_div = (opcode_dx==5'b0) && (alu_op_in == 5'b00111);
    
        dffe_ref mult_op(
            .q(mult_operation),
            .d(ctrl_mult || ctrl_div),
            .clk(clock),
            .en(ctrl_mult || ctrl_div || data_resultRDY),
            .clr(reset)
        );

        reg32bit ir(
            .data_writeReg(dx_IR_out),
            .data_readReg(instruct),
            .clock(clock),
            .ctrl_writeEnable(ctrl_mult || ctrl_div),
            .ctrl_reset(reset)
        );
    
    wire [31:0] multdiv_A, multdiv_B;
        reg32bit mult_regA(
            .data_writeReg(reg_A_bypass),
            .data_readReg(multdiv_A),
            .clock(clock),
            .ctrl_writeEnable(ctrl_mult || ctrl_div),
            .ctrl_reset(reset)
        );
        reg32bit mult_regB(
            .data_writeReg(alu_in_b),
            .data_readReg(multdiv_B),
            .clock(clock),
            .ctrl_writeEnable(ctrl_mult || ctrl_div),
            .ctrl_reset(reset)
        );

    wire [31:0] mult_input_A,mult_input_B;
    assign mult_input_A = ctrl_mult || ctrl_div ? reg_A_bypass : multdiv_A;
    assign mult_input_B = ctrl_mult || ctrl_div ? alu_in_b : multdiv_B;
    wire multdiv_exception;
        multdiv multdiv_unit(
            .data_operandA(mult_input_A),
            .data_operandB(mult_input_B),
            .ctrl_MULT(ctrl_mult),
            .ctrl_DIV(ctrl_div),
            .clock(clock),
            .data_result(mult_result),
            .data_exception(multdiv_exception),
            .data_resultRDY(data_resultRDY)
        );
    
    wire [31:0] md_product_out, md_ir_out;
        multdiv_latch md(
            .product_out(md_product_out),
            .ir_out(md_ir_out),
            .product_in(mult_result),
            .ir_in(instruct),
            .clock(!clock),
            .input_en(data_resultRDY),
            .clr(ctrl_mult || ctrl_div)
        );
    
    
    //Memory cycle

    wire [4:0] opcode_xm, rd_xm,a_xm,b_xm ,alu_op_xm;
    wire rType_xm;
    
        opdecoder decode_xm(
            .instruction(xm_IR_out),
            .opcode(opcode_xm),
            .rd(rd_xm),
            .rs(a_xm),
            .rt(b_xm),
            .shamt(),
            .alu_op(alu_op_xm),
            .imm(),
            .jump_target(),
            .rType(rType_xm),
            .iType(),
            .jType1(),
            .jType2()
        );

    wire [31:0] xm_bypass;
    assign address_dmem = xm_O_out;
    assign data = xm_bypass;
    wire sw;
    and we(sw,!xm_IR_out[31],!xm_IR_out[30],xm_IR_out[29],xm_IR_out[28],xm_IR_out[27]); //are we doing a store word
    assign wren = sw;

    mw_latch mw(
        .o_in(xm_O_out),
        .d_in(q_dmem),
        .IR_in(xm_IR_out),
        .clock(!clock),
        .reset(reset),
        .mw_en(1'b1), //temp value
        .mw_o_out(mw_O_out),
        .mw_d_out(mw_D_out),
        .mw_ir_out(mw_IR_out)
    );
    //Writebackcycle
    wire [4:0] opcode_mw, rd_mw,a_mw, alu_op_mw;
    wire rtype_mw;

    
        opdecoder decode_mw(
            .instruction(mw_IR_out),
            .opcode(opcode_mw),
            .rd(rd_mw),
            .rs(a_mw),
            .rt(),
            .shamt(),
            .alu_op(alu_op_mw),
            .imm(),
            .jump_target(),
            .rType(rtype_mw),
            .iType(),
            .jType1(),
            .jType2()
        );
    
    wire [4:0] opcode_md,rd_md,a_md,alu_op_md;
        opdecoder decode_multdiv(
            .instruction(md_ir_out),
            .opcode(opcode_md),
            .rd(rd_md),
            .rs(a_md),
            .rt(),
            .shamt(),
            .alu_op(alu_op_md),
            .imm(),
            .jump_target(),
            .rType(),
            .iType(),
            .jType1(),
            .jType2()
        );

    wire [1:0] mw_mux_ctrl;
    wire lw_mw;
    wire [31:0] choose_data;
    and sw_fd(lw_mw,!opcode_mw[4], opcode_mw[3], !opcode_mw[2],!opcode_mw[1],!opcode_mw[0]);
    assign mw_mux_ctrl[0] = lw_mw;
    assign mw_mux_ctrl[1] = (overflow && data_resultRDY) ||  // exceptions
                        (mult_operation && data_resultRDY);
    
    wire [31:0] multdiv_or_exception;
    mux_2 multdiv_exception_mux(
        .out(multdiv_or_exception),
        .in0(md_product_out),     // normal mult/div result
        .in1(exception_code),     // exception code
        .select(overflow && data_resultRDY)
    );
        mux_4 sw_mux(
            .out(choose_data),
            .in0(mw_O_out), //alu data
            .in1(mw_D_out), //memory data
            .in2(multdiv_or_exception),// mult/div data
            .in3(md_product_out),
            .select(mw_mux_ctrl)
        );

    assign ctrl_writeReg = (overflow && data_resultRDY) ? 5'b11110 :  // write to r30 for exceptions
                      mw_mux_ctrl[1] ? rd_md :                     // mult/div result
                      rd_mw;

    
    assign ctrl_writeEnable = rtype_mw || (!opcode_mw[4] && !opcode_mw[3] && opcode_mw[2] && !opcode_mw[1] && opcode_mw[0]) 
    || (!opcode_mw[4] && opcode_mw[3] && !opcode_mw[2] && !opcode_mw[1] && !opcode_mw[0] || opcode_mw == 5'b10101 || opcode_mw == 5'b00011)
    || (overflow && data_resultRDY);  // enable writing during exceptions
	assign data_writeReg = choose_data;
	
    //bypassing
    wire [1:0] mux_A_ctrl, mux_B_ctrl;
    wire mux_D_control;
    wire ctrl_writeEnable_xm = rType_xm || (!opcode_xm[4] && !opcode_xm[3] && opcode_xm[2] && !opcode_xm[1] && opcode_xm[0]) //rtype and addi
         || (!opcode_xm[4] && opcode_xm[3] && !opcode_xm[2] && !opcode_xm[1] && !opcode_xm[0] || opcode_xm == 5'b10101  //lw and setx
         || opcode_xm == 5'b00011);//jal


    wire [4:0] regA_bypass_in, regB_bypass_in_rType, regB_bypass_in_rd, regB_bypass_in;
    assign regA_bypass_in = ctrl_writeEnable || ctrl_writeEnable_xm ? a_dx : 5'b0;
    assign regB_bypass_in_rType = rType_dx ? b_dx : 5'b0;

    wire use_rd_control;
    assign use_rd_control = (opcode_dx ==5'b00010 || opcode_dx == 5'b00100 || opcode_dx == 5'b00110);

    assign regB_bypass_in_rd = use_rd_control ? rd_dx : 
                            regB_bypass_in_rType;

    // For sw instructions, use rs (source register)
    // For everything else, use the previously computed value
    assign regB_bypass_in = (opcode_dx == 5'b10110) ? 5'b11110 :
                        (opcode_dx == 5'b00111) ? rd_dx :   // sw case
                        regB_bypass_in_rd;

    wire sw_mw,sw_xm, sw_dx;
    assign sw_mw = opcode_mw == 5'b00111;
    assign sw_xm = opcode_xm ==5'b00111;
    assign sw_dx = opcode_dx == 5'b00111;
    bypass bypassing(
        .mux_A_sel(mux_A_ctrl),
        .mux_B_sel(mux_B_ctrl),
        .mux_D_sel(mux_D_control),
        .dx_rs(regA_bypass_in),
        .dx_rt(regB_bypass_in),
        .xm_rs(a_mw),
        .xm_rd(rd_xm),
        .xm_we(ctrl_writeEnable_xm),
        .sw_xm(sw_xm),
        .mw_rd(rd_mw),
        .mw_we(ctrl_writeEnable),
        .sw_mw(sw_mw),
        .sw_dx(sw_dx)
    );
    mux_4 bypass_A(
        .out(reg_A_bypass),
        .select(mux_A_ctrl),
        .in0(xm_O_out),
        .in1(choose_data),
        .in2(dx_A_out),
        .in3(32'b0)
    );
    mux_4 bypass_B(
        .out(reg_B_bypass),
        .select(mux_B_ctrl),
        .in0(xm_O_out),
        .in1(choose_data),
        .in2(dx_B_out),
        .in3(32'b0)
    );
    mux_2 bypass_D(
        .out(xm_bypass),
        .in0(xm_B_out),
        .in1(choose_data),
        .select(mux_D_control)
    );


endmodule
