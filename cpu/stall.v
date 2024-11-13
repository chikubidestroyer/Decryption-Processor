module stall(fd_we,pc_we,dx_mux_control,fd_opcode,fd_rs,fd_rt,dx_opcode,dx_rd,mult_operation,multdiv_at_dx);
    input [4:0] fd_rs,fd_rt,dx_rd,fd_opcode, dx_opcode;
    input mult_operation,multdiv_at_dx;
    output fd_we,pc_we,dx_mux_control;

    
    // Load-Use Hazard Detection
    wire load_use_hazard = (dx_opcode == 5'b01000) && // LW instruction in DX stage
                        ((fd_rs == dx_rd) ||       // FD instruction uses DX.rd
                            ((fd_rt == dx_rd) && (fd_opcode != 5'b00111))); // Exclude SW

    // Stall Condition
    assign dx_mux_control = load_use_hazard || mult_operation;

    // Control Signals
    assign fd_we = ~dx_mux_control;
    assign pc_we = ~dx_mux_control;

endmodule