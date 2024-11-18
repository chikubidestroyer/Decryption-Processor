module mux_2(out, select, in0, in1);
    input select;
    input [31:0] in0, in1;
    output [31:0] out;
    assign out = select ? in1 : in0;
endmodule
 

module mux_4(out, select, in0, in1, in2, in3);
    input [1:0] select;
    input [31:0] in0, in1, in2, in3;
    output [31:0] out;
    wire [31:0] w1,w2;
    mux_2 first_top(w1, select[0], in0, in1);
    mux_2 first_bottom(w2, select[0], in2, in3);
    mux_2 second(out, select[1], w1, w2);
endmodule

module mux_8(out, select, in0, in1, in2, in3, in4, in5, in6, in7);
    input [2:0] select;
    input [31:0] in0, in1, in2, in3, in4, in5, in6, in7;
    output [31:0] out;
    wire [31:0] w1,w2;
    mux_4 first_top(w1, select[1:0], in0, in1, in2, in3);
    mux_4 first_bottom(w2, select[1:0], in4, in5, in6, in7);
    mux_2 second(out, select[2], w1, w2);
endmodule