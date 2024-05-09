interface mem_intf  #(  
  parameter ADDR_WIDTH = 3,
  parameter DATA_WIDTH = 8
  ) (input logic clk,rst);
  
  //declare the signals
  logic      [ADDR_WIDTH-1:0]  addr;
  logic      wr_en;
  logic      rd_en;
  logic      [DATA_WIDTH-1:0]  wr_data;
  logic      [DATA_WIDTH-1:0] rd_data;

  modport DUT  (input clk, rst,addr, wr_en, rd_en ,wr_data, output rd_data);
  
endinterface
