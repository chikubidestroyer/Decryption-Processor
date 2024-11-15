module eightbitshifter(data_operandA, shift, data_result, enable);
    input [31:0] data_operandA;
    input shift, enable;
    output [31:0] data_result;
    
    wire [31:0] afterShift;

    assign afterShift = shift ?
        {{8{data_operandA[31]}}, data_operandA[31:8]}:
        {data_operandA[23:0], 8'b0};

    assign data_result = enable ? afterShift : data_operandA;

endmodule