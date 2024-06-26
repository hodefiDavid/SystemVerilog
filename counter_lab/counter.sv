module counter(inf.DUT i_inf);
  
  reg [7:0] tmp_count;
 
  // reset + add operation
  always @(posedge i_inf.clk, negedge i_inf.rst_n) begin
    if (!i_inf.rst_n)           
      tmp_count <= 0;
    else if (i_inf.load) 
      tmp_count <= i_inf.data_in;
    else if (i_inf.enable)   
      tmp_count <= tmp_count + 1;
  end
  assign i_inf.count = tmp_count;


endmodule
