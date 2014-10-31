

module  axi2apb_mux 
		#(
			parameter NUM_SLAVES = 8
		) (
			input  logic                          clk,
			input  logic                          rstn,
			
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
	
	logic [31:0] ctrl_prdata_next;
	logic        ctrl_pslverr_next;
	
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
			ctrl_pslverr_next = slv_pslverr[ctrl_addr_mux];
		else
			ctrl_pslverr_next = 1'b1;
	end
   
	always_comb
	begin
		if (!dec_err)
			ctrl_prdata_next = slv_prdata[ctrl_addr_mux];
		else
			ctrl_prdata_next = 32'h0;
	end
   
   always @(posedge clk or negedge rstn)
     if (!rstn)
       begin
         ctrl_prdata  <=  32'h0;
         ctrl_pslverr <=   1'b0;
       end
     else if (ctrl_psel & ctrl_pready)
       begin
         ctrl_prdata  <=  ctrl_prdata_next;
         ctrl_pslverr <=  ctrl_pslverr_next;
       end
     else if (~ctrl_psel)
       begin
         ctrl_prdata  <=  32'h0;
         ctrl_pslverr <=   1'b0;
       end
   
endmodule

   


