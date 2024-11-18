module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // add your code here
    
    wire [31:0] mult_result;
    wire mult_ready;
    wire mult_overflow;

    // Instantiate Booth's Multiplier
    booth_multiplier mult_unit (
        .A(data_operandA),
        .B(data_operandB),
        .start(ctrl_MULT),
        .clock(clock),
        .result(mult_result),
        .ready(mult_ready),
        .overflow(mult_overflow)
    );

    wire [31:0] div_result;
    wire div_ready;
    wire div_exception;
    divider div_unit(
        .D(data_operandA),
        .V(data_operandB),
        .start(ctrl_DIV),
        .clock(clock),
        .quotient(div_result),
        .ready(div_ready),
        .exception(div_exception)
    );
    wire expecting_mult, ex_out;
    mux_4_1_bit expecting_result(expecting_mult, {ctrl_MULT, ctrl_DIV}, ex_out, 1'b0, 1'b1, 1'bx);

    dffe_ref expecting_which (
                .q(ex_out),   // Output bit `i`
                .d(expecting_mult),    // Input bit `i`
                .clk(clock),         // Clock signal
                .en(1'b1),           // Write enable signal
                .clr(1'b0)        // Reset signal
            );
    // Handling output signals
    assign data_result = mult_ready && ex_out? mult_result: 
                        div_ready && !ex_out? div_result: 32'bx;
    assign data_exception = mult_ready && ex_out? mult_overflow:
                        div_ready && !ex_out? div_exception: 1'bx;
    assign data_resultRDY = mult_ready && ex_out? mult_ready:
                        div_ready && !ex_out? div_ready: 1'b0;

endmodule
