///////////////////////////////////////////////////////////////////////////
// MODULE               : counter                                        //
//                                                                       //
// DESIGNER             : Dorit Medina                                   //
//                                                                       //
// Verilog code for 8-bit counter                                        //
// This is the behavioral description of an 8-bit counter		 //
//                                                                       //
///////////////////////////////////////////////////////////////////////////

module counter (count, data_in, clk, rst_n, load, enable);
output [7:0] count;
input [7:0] data_in;
input clk, rst_n, load, enable;

reg [7:0] count;

always @ (posedge clk or negedge rst_n)
  if (!rst_n)
     count = 8'h00;
  else if (load)
     count <= data_in;
  else if (enable)
     count <= count + 8'h01;
     
   
endmodule
