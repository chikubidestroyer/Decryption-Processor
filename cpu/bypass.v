module bypass(
    output [1:0] mux_A_sel,  // Selection signals for ALU input A bypass mux
    output [1:0] mux_B_sel,  // Selection signals for ALU input B bypass mux
    output       mux_D_sel,  // Selection signal for XM stage bypass mux
    input  [4:0] dx_rs,      // Source register rs in DX stage
    input  [4:0] dx_rt,      // Source register rt in DX stage
    input  [4:0] xm_rs,      // Source register rs in XM stage (included as per original code)
    input  [4:0] xm_rd,      // Destination register rd in XM stage
    input        xm_we,      // Write enable in XM stage
    input        sw_xm,      // Indicates if SW instruction is in XM stage
    input  [4:0] mw_rd,      // Destination register rd in MW stage
    input        mw_we,      // Write enable in MW stage
    input        sw_mw,       // Indicates if SW instruction is in MW stage
    input        sw_dx       // Indicates if SW instruction is in DX stage

);

    //DX.rs and XM.rd
    wire xm_match_rs = (dx_rs != 5'd0) && (dx_rs == xm_rd) && xm_we && !sw_xm;

    // DX.rs and MW.rd
    wire mw_match_rs = (dx_rs != 5'd0) && (dx_rs == mw_rd) && mw_we && !sw_mw;

    // MALU input A 
    assign mux_A_sel = xm_match_rs ? 2'b00 :       // Bypass from XM stage
                       mw_match_rs ? 2'b01 :       // Bypass from MW stage
                                     2'b10;        // Use register file value

    //  DX.rt and XM.rd
    //wire xm_match_rt = (dx_rt != 5'd0) && (dx_rt == xm_rd) && (xm_we || sw_xm);
    wire xm_match_rt = (dx_rt != 5'd0) && (dx_rt == xm_rd) && (xm_we || sw_xm) && !sw_dx;
    //  DX.rt and MW.rd
    wire mw_match_rt = (dx_rt != 5'd0) && (dx_rt == mw_rd) && mw_we && !sw_mw;

    // ALU input B 
    assign mux_B_sel = xm_match_rt ? 2'b00 :       // Bypass from XM stage
                       mw_match_rt ? 2'b01 :       // Bypass from MW stage
                                     2'b10;        // Use register file value

    //  XM stage bypass 
    // XM stage bypass
    assign mux_D_sel = (xm_rd == mw_rd) && mw_we && !sw_mw;

endmodule
