interface inf
    #(  
  parameter ADDR_WIDTH = 3,
  parameter DATA_WIDTH = 8
  )
  (input logic clk,rst);
  //declare the signals
  logic [ADDR_WIDTH-1:0]  addr;

  //control signals
  logic                   wr_en;
  logic                   rd_en;
  //add constrain to enable only one of the control signals at a time
  //the DUT shuld not be able to read and write at the same time

    //data signals
  logic  [DATA_WIDTH-1:0]  wr_data;
  logic  [DATA_WIDTH-1:0] rd_data;
  // in order to diffrientiate between the transaction in and out
  logic enable;

  modport DUT  (input clk, rst, addr, wr_en, rd_en, wr_data, output rd_data);
  
endinterface
