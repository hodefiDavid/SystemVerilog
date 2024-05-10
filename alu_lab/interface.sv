interface inf #(parameter WIDTH = 4) (input logic clk,rst);
  
  //declare the signals for the interface ALU DUT

  bit [WIDTH-1:0] a;
  bit [WIDTH-1:0] b;
  bit [1:0] select;
  bit [WIDTH-1:0] out;
  bit zero;
  bit carry;
  bit sign;
  bit parity;
  bit overflow;
           
  modport DUT(input a,b,select,clk,rst,
              output out,zero,carry,sign,parity,overflow);
  
endinterface