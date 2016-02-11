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

module  axi2apb_ctrl
  (
    input  logic clk,
    input  logic rstn,

    input  logic finish_wr,
    input  logic finish_rd,

    input  logic cmd_empty,
    input  logic cmd_read,
    input  logic WVALID,

    output logic psel,
    output logic penable,
    output logic pwrite,
    input  logic pready
  );

  logic wstart;
  logic rstart;

  logic busy;
  logic pack;
  logic cmd_ready;


  assign cmd_ready = (~busy) & (~cmd_empty);
  assign wstart = cmd_ready & (~cmd_read) & (~psel) & WVALID;
  assign rstart = cmd_ready & cmd_read & (~psel);

  assign pack = psel & penable & pready;

  always @(posedge clk or negedge rstn)
    if (!rstn)
      busy <=  1'b0;
    else if (psel)
      busy <=  1'b1;
    else if (finish_rd | finish_wr)
      busy <=  1'b0;

  always @(posedge clk or negedge rstn)
    if (!rstn)
      psel <=  1'b0;
    else if (pack)
      psel <=  1'b0;
    else if (wstart | rstart)
      psel <=  1'b1;

  always @(posedge clk or negedge rstn)
    if (!rstn)
      penable <=  1'b0;
    else if (pack)
      penable <=  1'b0;
    else if (psel)
      penable <=  1'b1;

  always @(posedge clk or negedge rstn)
    if (!rstn)
      pwrite  <=  1'b0;
    else if (pack)
      pwrite  <=  1'b0;
    else if (wstart)
      pwrite  <=  1'b1;


endmodule

