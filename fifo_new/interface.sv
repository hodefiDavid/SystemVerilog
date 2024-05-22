
// This is the interface file for the fifo DUT
interface inf #(parameter AWIDTH = 4,  
parameter DWIDTH = 4) (input logic clk,rst);
  
  //declare the signals for the interface fifo DUT
// input 	   clk, rst, write_en, read_en,
// input	      [DWIDTH-1:0] data_in,
// output      full, empty,
// output reg  [DWIDTH-1:0] data_out
bit write_en,read_en;
bit [DWIDTH-1:0] data_in;
bit full,empty;
bit [DWIDTH-1:0] data_out;

           
  modport DUT(
    input 	   clk, rst, write_en, read_en,
    input	       data_in,
    output      full, empty,
    output    data_out);
  
endinterface