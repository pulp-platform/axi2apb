/////////////////////////////////////////////////////////////////////
////                                                             ////
////  Based on work by:                                          ////
////       Eyal Hochberg (eyal@provartec.com)                    ////
////                                                             ////
////  Downloaded from: http://www.opencores.org                  ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2016 Authors                                  ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
//// This source file is free software; you can redistribute it  ////
//// and/or modify it under the terms of the GNU Lesser General  ////
//// Public License as published by the Free Software Foundation.////
////                                                             ////
//// This source is distributed in the hope that it will be      ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied  ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR     ////
//// PURPOSE.  See the GNU Lesser General Public License for more////
//// details. http://www.gnu.org/licenses/lgpl.html              ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

module  axi2apb_mux
  #(
    parameter NUM_SLAVES = 8
  )
  (
    input  logic  [3:0]                   ctrl_addr_mux,
    input  logic                          ctrl_psel,
    output logic [31:0]                   ctrl_prdata,
    output logic                          ctrl_pready,
    output logic                          ctrl_pslverr,

    output logic [NUM_SLAVES-1:0]         slv_psel,
    input  logic [NUM_SLAVES-1:0]         slv_pready,
    input  logic [NUM_SLAVES-1:0]         slv_pslverr,
    input  logic [NUM_SLAVES-1:0] [31:0]  slv_prdata
  );

  logic dec_err;

  assign dec_err = (ctrl_addr_mux >= NUM_SLAVES);

  always_comb
  begin
    for (int i=0; i<NUM_SLAVES; i++)
    begin
      slv_psel[i] = ctrl_psel & (ctrl_addr_mux == i) & ~dec_err;
    end
  end

  always_comb
  begin
    if (!dec_err)
      ctrl_pready = slv_pready[ctrl_addr_mux];
    else
      ctrl_pready = 1'b1;
  end

  always_comb
  begin
    if (!dec_err)
      ctrl_pslverr = slv_pslverr[ctrl_addr_mux];
    else
      ctrl_pslverr = 1'b1;
  end

  always_comb
  begin
    if (!dec_err)
      ctrl_prdata = slv_prdata[ctrl_addr_mux];
    else
      ctrl_prdata = 32'h0;
  end

endmodule

