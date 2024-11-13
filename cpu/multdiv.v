module multdiv(
    input [31:0] data_operandA, data_operandB,
    input ctrl_MULT, ctrl_DIV, clock,
    output [31:0] data_result,
    output data_exception, data_resultRDY
);

    // Internal signals to connect to submodules
    wire [31:0] mult_result, div_result;
    wire mult_exception, mult_resultRDY, div_exception, div_resultRDY;

    
    // Multiplication Module
    multiplier mult_module (
        .multiplicand(data_operandA),
        .multiplier(data_operandB),
        .ctrl_MULT(ctrl_MULT),
        .clock(clock),
        .data_result(mult_result),
        .data_exception(mult_exception),
        .data_resultRDY(mult_resultRDY)
    );

    // Division Module
    divider div_module (
        .dividend(data_operandA),
        .divisor(data_operandB),
        .start(ctrl_DIV),
        .clk(clock),
        .quotient(div_result),
        .exception(div_exception),
        .done(div_resultRDY)
    );

    wire isDiv;
    dffe_ref divOrMult(
        .q(isDiv),
        .d(ctrl_DIV),
        .clk(clock),
        .en(ctrl_DIV || ctrl_MULT),
        .clr(1'b0)
    );

    // Manage Outputs
    assign data_result = isDiv ? div_result : mult_result;
    assign data_exception = isDiv ? div_exception : mult_exception;
    assign data_resultRDY = isDiv ? div_resultRDY : mult_resultRDY;

endmodule
