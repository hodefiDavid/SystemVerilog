interface inf(input logic clk,rst_n);
  
  //declare the signals
  logic enable;
  logic load;
  logic [7:0] data_in;
  logic [7:0] count;


  modport DUT  (input clk, rst_n, enable, load, data_in, output count);
  
endinterface
