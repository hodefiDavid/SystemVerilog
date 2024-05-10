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
    alu c1(.a(i_inf.a),.b(i_inf.b),.select(i_inf.select),
           .out(i_inf.out),.zero(i_inf.zero),.carry(i_inf.carry),.sign(i_inf.sign),
           .parity(i_inf.parity),.overflow(i_inf.overflow));

endmodule