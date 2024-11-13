module sixteenbitshifter(data_operandA, shift, data_result,enable);
    input [31:0] data_operandA;
    input shift, enable;
    output [31:0] data_result;

    wire [31:0] afterShift;
    
    assign afterShift = shift ?
        {{16{data_operandA[31]}}, data_operandA[31:16]}:
        {data_operandA[15:0], 16'b0};
    assign data_result = enable ? afterShift : data_operandA;

endmodule