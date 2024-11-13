module fourbitshifter(data_operandA, shift, data_result, enable);
    input [31:0] data_operandA;
    input shift, enable;
    output [31:0] data_result;
    
    wire [31:0] afterShift;

    assign afterShift = shift ?
        {{4{data_operandA[31]}}, data_operandA[31:4]}:
        {data_operandA[27:0], 4'b0000};
    assign data_result = enable ? afterShift : data_operandA;
endmodule