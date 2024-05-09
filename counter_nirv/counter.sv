///////////////////////////////////////////////////////////////////////////
// MODULE               : counter                                        //
//                                                                       //
// DESIGNER             : Dorit Medina                                   //
//                                                                       //
// Verilog code for 8-bit counter                                        //
// This is the behavioral description of an 8-bit counter		 //
//                                                                       //
///////////////////////////////////////////////////////////////////////////

module counter(inf.DUT i_inf);


always @(posedge i_inf.clk, posedge i_inf.rst) 
  if (i_inf.rst)
     i_inf.count = 8'h00;
  else if (i_inf.load)
     i_inf.count <= i_inf.data_in;
  else if (i_inf.enable)
     i_inf.count <= i_inf.count + 8'h01;
   
endmodule
