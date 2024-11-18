module divider(
    input [31:0] D,
    input [31:0] V,
    input start,
    input clock,
    input reset,
    output [31:0] quotient,
    output [31:0] remainder,
    output ready,
    output exception
);

    wire is_D_neg, is_V_neg;
    assign is_D_neg = D[31];
    assign is_V_neg = V[31];

    wire [31:0] D_neg, V_neg, A, B;

    cla_add nD(.s(D_neg), .a(~D), .b(32'b0), .Cin(1'b1));
    cla_add nV(.s(V_neg), .a(~V), .b(32'b0), .Cin(1'b1));

    assign A = is_D_neg? D_neg: D;
    assign B = is_V_neg? V_neg: V;

    wire [31:0] temp_quotient, temp_remainder, neg_q, neg_r;
    unsigned_divider div(A, B, start, clock, reset, temp_quotient, temp_remainder, ready, exception);
    cla_add nq(.s(neg_q), .a(~temp_quotient), .b(32'b0), .Cin(1'b1));
    cla_add nr(.s(neg_r), .a(~temp_remainder), .b(32'b0), .Cin(1'b1));
    assign quotient = (is_D_neg ^ is_V_neg)? neg_q: temp_quotient;
    assign remainder = is_D_neg? neg_r: temp_remainder;
endmodule;

module unsigned_divider (
    input [31:0] A,
    input [31:0] B,
    input start,
    input clock,
    input reset,
    output [31:0] quotient,
    output [31:0] remainder,
    output ready,
    output exception
);

    wire [63:0] RQ_in, RQ_out, RQ_next;
    wire [5:0] count, next_count;
    wire count_enable;
    wire overflow_flag;
    wire ready_flag;

    reg6 counter_reg (.clk(clock), .reset(reset), .we(1'b1), .data_in(next_count), .data_out(count));

    assign RQ_next = (start) ? {32'b0, A} : RQ_out;

    wire do_i_add;
    comp_1 MSB_1(.A(RQ_next[63]), .B(1'b1), .EQ(do_i_add));

    wire [63:0] RQ_after_shift;
    assign RQ_after_shift = {RQ_next[62:0], 1'b0};

    wire [31:0] sub_result;
    cla_add sub_B(.s(sub_result), .a(~B), .b(RQ_after_shift[63:32]), .Cin(1'b1));
    wire [31:0] add_result;
    cla_add add_B(.s(add_result), .a(B), .b(RQ_after_shift[63:32]), .Cin(1'b0));

    wire [63:0] RQ_after_dec_2;
    assign RQ_after_dec_2 = do_i_add ? {add_result, RQ_after_shift[31:0]}: {sub_result, RQ_after_shift[31:0]};

    wire do_i_set_1;
    comp_1 MSB_2(.A(RQ_after_dec_2[63]), .B(1'b0), .EQ(do_i_set_1));

    assign RQ_in = do_i_set_1? {RQ_after_dec_2[63:1], 1'b1}: {RQ_after_dec_2[63:1], 1'b0};

    reg64 RQ (.clk(clock), .reset(reset), .we(1'b1), .data_in(RQ_in), .data_out(RQ_out));
    
    wire [31:0] count_sub_one;
    cla_add next_count_sub_1(.s(count_sub_one), .a((32'hffff)), .b(count), .Cin(1'b0));
    assign next_count = (start) ? 6'd31 : count_sub_one;

    // Check for overflow when multiplication is complete

    comp_32 check_div_by_zero(.A(B), .B(32'b0), .EQ(exception));

    comp_6 ready_q(.A(count), .B(6'd0), .EQ(ready_flag));

    wire do_i_add_to_rem;

    comp_1 last_decision(.A(RQ_out[63]), .B(1'b1), .EQ(do_i_add_to_rem));
    wire [31:0] added_remainder;
    cla_add rem_add(.s(added_remainder), .a(RQ_out[63:32]), .b(B), .Cin(1'b0));
    assign remainder = (do_i_add_to_rem) ? added_remainder : RQ_out[63:32];
    // Output assignments
    assign quotient = RQ_out[31:0];
    assign ready = ready_flag;

endmodule