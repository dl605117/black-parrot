module bp_fe_ras
#(parameter width_p = inv,
  parameter ras_ele = inv,
)
( input clk_i
, input reset_i
, input is_call_i
, input ovr_ret_i
, input [width_p-1:0] return_addr_i
, output [width_p-1:0] return_addr_o
)

logic [width_p-1:0] return_addr [0:ras_ele-1];
logic [`BSG_SAFE_CLOG2(ras_ele)-1:0] lru [0:ras_ele-1];


integer j;
always_ff @(posedge clk_i) begin
  if(reset_i) begin
  	for(j =0; j < ras_ele; j++) begin
  	  lru[j] <= j;
  	end
  end
  else begin
   if(is_call_i) begin
     for(j=0; j < ras_ele; j++) begin
       lru[j] <= lru[j] - 1;
     end
   end
   else if (ovr_ret_i) begin
     for(j=0; j < ras_ele; j++) begin
       lru[j] <= lru[j] + 1;
     end
   end
   else begin
   	 for(j=0; j < ras_ele; j++) begin
   	   lru[j] <= lru[j];
   	 end
   end
  end
end

 genvar i;
 generate
   for(i = 0; i < ras_ele; i++) begin
   	 bsg_dff_reset_en
 		#(.width_p(width_p))
 		ras
  	(.clk_i(clk_i)
   	,.reset_i(reset_i)
   	,.en_i(is_call_i && lru[i] == 0)

   	,.data_i(return_addr_i)
   	,.data_o(return_addr[i])
   	);
   end
endgenerate

integer k;
always_comb begin
	return_addr_o = 0;
	for ( k = 0; k < ras_ele; k++ ) begin
		if ( lru[k] == ras_ele-1 )
			return_addr_o = return_addr[k];
	end
end

endmodule