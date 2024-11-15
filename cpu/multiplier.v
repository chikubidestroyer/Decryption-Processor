module multiplier(
    input [31:0] multiplicand, multiplier,
    input ctrl_MULT, clock,
    output [31:0] data_result,
    output data_exception, data_resultRDY
);

    // Wires for multiplication logic
    wire [64:0] initial_in;
    assign initial_in = {32'b0, multiplier, 1'b0};

    wire [64:0] product_in;
    wire signed [64:0] after_add;
    mux_2_65 inital_reg( 
        .out(product_in),
        .in0(after_add >>> 1), //if we are not initializing the product just keep using the same product shifted right
        .in1(initial_in),  //initializes the product if we just started
        .select(ctrl_MULT)
    );

    wire [64:0] current_P;
    reg65bit product_reg(
        .clock(clock),
        .ctrl_writeEnable(~data_resultRDY),
        .ctrl_reset(1'b0),
        .data_writeReg(product_in),
        .data_readReg(current_P)
    );
    assign data_result = current_P[32:1];

    wire nothing;
    assign nothing = current_P[0] ^ current_P[1]; //to tell if we do the add/sub or not

    wire signed [31:0] upper_bits;
    cla32bit adder(
        .Sum(upper_bits),
        .Cout(),
        .data_operandA(current_P[64:33]),
        .data_operandB(multiplicand),
        .sub(current_P[1]) //are we subtracting only in the case of 10
    );

    wire signed [64:0] adder_sum;
    assign adder_sum[64:33] = upper_bits;
    assign adder_sum[32:0] = current_P[32:0];

    mux_2_65 do_something(
        .out(after_add),
        .in0(current_P),
        .in1(adder_sum),
        .select(nothing)
    );

    // Exception handling
        //was the sign extended correctly
        wire [31:0] top_bits = current_P[64:33];
        wire result_sign = data_result[31]; 
        wire overflow;
        assign overflow = (~result_sign & |top_bits) | (result_sign & ~(&top_bits) & |top_bits);

        //if a and b are non zero and the result is zero
        wire zeroExcept;
        assign zeroExcept = |multiplicand & |multiplier & ~(|data_result);

        //if a and b are negative and the result is negative
        wire negOverflow, posOverflow;
        assign negOverflow = ~(multiplicand[31] ^ multiplier[31]) & data_result[31];

        assign data_exception = overflow | zeroExcept | negOverflow;
    // Counter for multiplication operation
    counter counter_mult(
        .clock(clock),
        .ctrl_reset(ctrl_MULT),
        .enable(1'b1),
        .data_resultRDY(data_resultRDY)
    );
endmodule
