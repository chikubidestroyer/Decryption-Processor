module decoder(out, select);
    input [4:0] select;
    output [31:0] out;
    
    assign out = 1 << select;  // Simple decoder using shift left
endmodule
