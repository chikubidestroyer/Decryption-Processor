
// returns if Rd is modified by the instruction, this is used in the bypass logic to determine if bypass is needed
module isRdModified (
    input [31:0] ins,
    output isModified
);

assign isModified = (ins[31:27] == 5'b00000) ||
        (ins[31:27] == 5'b00101) ||
        (ins[31:27] == 5'b01000) ||
        (ins[31:27] == 5'b00000);
endmodule