
module  axi2apb_rd
		#(
		parameter AXI_ID_WIDTH   = 6,
		parameter AXI_DATA_WIDTH = 64
		) (

   input  logic                        clk,
   input  logic                        rstn,

   input  logic                        psel,
   input  logic                        penable,
   input  logic                        pwrite,

   input  logic               [31:0]   prdata,
   input  logic                        pslverr,
   input  logic                        pready,
      
   input  logic                        cmd_err,
   input  logic   [AXI_ID_WIDTH-1:0]   cmd_id,
   output logic                        finish_rd,
   
   output logic   [AXI_ID_WIDTH-1:0]   RID,
   output logic [AXI_DATA_WIDTH-1:0]   RDATA,
   output logic                [1:0]   RRESP,
   output logic                        RLAST,
   output logic                        RVALID,
   input  logic                        RREADY
);   
   
   parameter              RESP_OK     = 2'b00;
   parameter              RESP_SLVERR = 2'b10;
   parameter              RESP_DECERR = 2'b11;
   
   assign                 finish_rd = RVALID & RREADY & RLAST;
   
   always @(posedge clk or negedge rstn)
     if (~rstn)
       begin
         //RRESP  <=  2'h0;
         //RLAST  <=  1'b0;
         RVALID <=  1'b0;
       end
     else if (finish_rd)
       begin
       	//RRESP  <=  2'h0;
       	//RLAST  <=  1'b0;
       	RVALID <=  1'b0;
       end
     else if (psel & penable & (~pwrite) & pready)
       begin
         RID    <=  cmd_id;
         RDATA  <=  prdata;
         RRESP  <=  cmd_err ? RESP_SLVERR : pslverr ? RESP_DECERR : RESP_OK;
         RLAST  <=  1'b1;
         RVALID <=  1'b1;
       end
       
endmodule

   


