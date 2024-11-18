module booth_multiplier (
    input [31:0] A,
    input [31:0] B,
    input start,
    input clock,
    input reset,
    output [31:0] result,
    output ready,
    output overflow
);

    wire [64:0] partial_product_in, partial_product_out;
    wire [64:0] next_partial_product;
    wire [31:0] A_neg;
    wire [31:0] add_result, sub_result;
    wire [5:0] count, next_count;
    wire count_enable;
    wire overflow_flag;
    wire ready_flag;

    reg65 partial_product_reg (.clk(clock), .reset(reset), .we(1'b1), .data_in(partial_product_in), .data_out(partial_product_out));
    reg32 counter_reg (.clk(clock), .reset(reset), .we(1'b1), .data_in(next_count), .data_out(count));

    assign partial_product_in = (start) ? {32'b0, B, 1'b0} : next_partial_product;

    wire [31:0] count_sub_one;
    cla_add next_count_sub_1(.s(count_sub_one), .a((32'hffff)), .b(count), .Cin(1'b0));
    assign next_count = (start) ? 6'd32 : count_sub_one;

    cla_add add_A(.s(add_result), .a(A), .b(partial_product_out[64:33]), .Cin(1'b0));
    cla_add sub_A(.s(sub_result), .a(~A), .b(partial_product_out[64:33]), .Cin(1'b1));

    wire [64:0] temp_partial_product;

    wire do_i_add, do_i_sub;
    comp_8 add_q(.A(partial_product_out[1:0]), .B(2'b01), .EQ(do_i_add));
    comp_8 sub_q(.A(partial_product_out[1:0]), .B(2'b10), .EQ(do_i_sub));

    assign temp_partial_product = (do_i_add) ? {add_result, partial_product_out[32:0]} :
                                  (do_i_sub) ? {sub_result, partial_product_out[32:0]} :
                                  partial_product_out;

    assign next_partial_product = {temp_partial_product[64], temp_partial_product[64:1]};

    // Check for overflow when multiplication is complete

    overflow_checker overflow_q(A, B, partial_product_out, result, overflow_flag);
    comp_8 ready_q(.A(count), .B(6'd0), .EQ(ready_flag));

    // Output assignments
    assign result = partial_product_out[32:1];
    assign overflow = overflow_flag;
    assign ready = ready_flag;

endmodule