module twobitshifter(data_operandA, shift, data_result, enable);
    input [31:0] data_operandA;
    input shift, enable;
    output [31:0] data_result;

    wire [31:0] afterShift;

    assign afterShift = shift ?
        {data_operandA[31], data_operandA[31], data_operandA[31:2]}:
        {data_operandA[30:0], 2'b00};
    assign data_result = enable ? afterShift : data_operandA;
endmodule