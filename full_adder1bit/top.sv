//testbench top is the top most file, in which DUT and Verification environment are connected. 

//include interfcae 
`include "interface.sv"

//include one test at a time
`include "random_test.sv"
//`include "directed_test.sv"

module top;
  
  //clock and reset signal declaration
  bit clk;
  bit rst;
  
  //clock generation
  always #5 clk = ~clk;
  
  //reset generation
  initial begin
    rst = 1;
    #15 rst =0;
  end
  
  
  //interface instance in order to connect DUT and testcase
  inf i_inf(clk,rst);
  
  //testcase instance, interface handle is passed to test 
  test t1(i_inf);
  
  //DUT instance, interface handle is passed to test 
  full_adder_1bit c1(.i_a(i_inf.i_a),.i_b(i_inf.i_b),.i_cin(i_inf.i_cin),.o_sum(i_inf.o_sum),.o_carry(i_inf.o_carry));
  
endmodule