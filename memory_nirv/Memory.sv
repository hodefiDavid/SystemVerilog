module memory
  #(  
  parameter ADDR_WIDTH = 3,
  parameter DATA_WIDTH = 8
  )
  (
    mem_intf.DUT  intf
  ); 
  
  int i;
  
  //Memory
  logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH];

  //Reset 
  always @(posedge intf.rst) 
    for(i=0;i<2**ADDR_WIDTH;i++) mem[i]=8'hFF;
   
  // Write data to Memory
  always @(posedge  intf.clk) 
    if ( intf.wr_en)    mem[ intf.addr] <=  intf.wr_data;
   
  // Read data from memory
  always @(posedge  intf.clk)
    if ( intf.rd_en)  intf.rd_data <= mem[ intf.addr];

endmodule
