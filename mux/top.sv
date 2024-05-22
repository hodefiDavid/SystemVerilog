//testbench top is the top most file, in which DUT and Verification environment are connected. 

//include interfcae 
`include "interface.sv"
`include "mux.coundt.v"
//include one test at a time
`include "random_test.sv"
//`include "directed_test.sv"

module top;
  
  //clock and reset signal declaration
  bit clk;
  bit rst_n;
  
  //clock generation
  always #5 clk = ~clk;
  
  //reset generation
  initial begin
    rst_n = 0;
    #15 rst_n =1;
  end
  
  
  //interface instance in order to connect DUT and testcase
  inf i_inf(clk,rst_n);
  
  //testcase instance, interface handle is passed to test 
  test t1(i_inf);
  
  //DUT instance, interface handle is passed to test 

 mux mx (.in0(i_inf.in0), 
 .in1(i_inf.in1), 
 .in2(i_inf.in2),
  .in3(i_inf.in3),
   .select(i_inf.select), .out(i_inf.out),
    .rst(i_inf.rst_n), .clk(i_inf.clk)); 

endmodule