interface inf(input logic clk,rst);
  
  //declare the signals
    logic write_en;
    logic read_en;
    logic [3:0] data_in;
    logic [3:0] data_out;
    logic full;
    logic empty;


  //modport declaration
  modport DUT  (input clk, rst, write_en, read_en, data_in, output data_out, full, empty);
  
endinterface