interface inf (Input logic clk ,rst_n);
  
  //declare the signals for the interface ALU DUT

  bit [1:0] in0, in1,in2,in3;
  bit [1:0] select;
  bit [1:0] out;
  
           
  modport DUT( input in0,in1,in2,in3,select,rst_n,clk, output out);
  
endinterface