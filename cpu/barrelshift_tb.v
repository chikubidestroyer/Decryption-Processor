`timescale 1ns / 1ps

module barrelshift_tb;

    // Testbench signals
    reg [31:0] data_operandA;
    reg [4:0] ctrl_shiftamt;
    reg shift;
    wire [31:0] data_result;

    // Instantiate the barrel_shifter module
    barrelshift uut (
        .data_operandA(data_operandA),
        .ctrl_shiftamt(ctrl_shiftamt),
        .shift(shift),
        .data_result(data_result)
    );

    initial begin
        // Monitor changes
        $monitor("Time=%0t ns | shift=%b | ctrl_shiftamt=%d | data_operandA=%h | data_result=%h", 
                 $time, shift, ctrl_shiftamt, data_operandA, data_result);

        // Test Case 1: No shift
        data_operandA = 32'h12345678;
        ctrl_shiftamt = 5'd0;
        shift = 0; // SLL
        #10;

        // Test Case 2: Shift left by 1 bit
        data_operandA = 32'h89ABCDEF;
        ctrl_shiftamt = 5'd1;
        shift = 0; // SLL
        #10;

        // Test Case 3: Shift right arithmetic by 1 bit
        data_operandA = 32'hF0000001;
        ctrl_shiftamt = 5'd1;
        shift = 1; // SRA
        #10;

        // Test Case 4: Shift left by 4 bits
        data_operandA = 32'h12345678;
        ctrl_shiftamt = 5'd4;
        shift = 0; // SLL
        #10;

        // Test Case 5: Shift right arithmetic by 8 bits
        data_operandA = 32'hF2345678;
        ctrl_shiftamt = 5'd8;
        shift = 1; // SRA
        #10;

        // Test Case 6: Shift left by 16 bits
        data_operandA = 32'h12345678;
        ctrl_shiftamt = 5'd16;
        shift = 0; // SLL
        #10;

        // Test Case 7: Shift right arithmetic by 31 bits
        data_operandA = 32'h80000000; // Negative number
        ctrl_shiftamt = 5'd31;
        shift = 1; // SRA
        #10;

        // Test Case 8: Shift left by 10 bits
        data_operandA = 32'h89ABCDEF;
        ctrl_shiftamt = 5'd10;
        shift = 0; // SLL
        #10;

        // Test Case 9: Shift right arithmetic by 0 bits (no shift)
        data_operandA = 32'hF2345678;
        ctrl_shiftamt = 5'd0;
        shift = 1; // SRA
        #10;

        // Test Case 10: Shift left by 31 bits
        data_operandA = 32'h00000001;
        ctrl_shiftamt = 5'd31;
        shift = 0; // SLL
        #10;

        // Finish simulation
        $finish;
    end

endmodule
