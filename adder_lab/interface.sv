interface inf(input logic clk,rst);
  
  //declare the signals
  logic       enable;
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] sum;

  modport DUT  (input clk, rst, enable, a, b, output sum);
  
endinterface
