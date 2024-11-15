module onebitshifter(data_operandA, data_result, shift, enable);
    input [31:0] data_operandA;
    output [31:0] data_result;
    input shift, enable;

    wire [31:0] afterShift;

    assign afterShift = shift ?
        {data_operandA[31], data_operandA[31:1]}:
        {data_operandA[30:0], 1'b0};
    assign data_result = enable ? afterShift : data_operandA;
endmodule