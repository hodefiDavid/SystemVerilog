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
  fifo f1(.clk(i_inf.clk),
  .rst(i_inf.rst),
  .write_en(i_inf.write_en),
  .read_en(i_inf.read_en),
  .data_in(i_inf.data_in),
  .data_out(i_inf.data_out),
  .full(i_inf.full),
  .empty(i_inf.empty)
  );
  
endmodule