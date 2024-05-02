//testbench top is the top most file, in which DUT and Verification environment are connected. 

//include interfcae 
`include "interface.sv"

//include one test at a time
`include "random_test.sv"
//`include "directed_test.sv"

module testbench_top;
  
  //clock and reset signal declaration
  bit clk;
  bit rst;
  
  //clock generation
  always #5 clk = ~clk;
  
  //reset generation
  initial begin
    rst = 0;
    #15 rst = 1;
  end
  
  
  //interface instance in order to connect DUT and testcase
  inf i_inf(clk,rst);
  
  //testcase instance, interface handle is passed to test 
  test t1(i_inf);
  
  //DUT instance, interface handle is passed to test 
  counter a1(i_inf);
  
endmodule
