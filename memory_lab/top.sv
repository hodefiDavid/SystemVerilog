//testbench top is the top most file, in which DUT and Verification environment are connected. 

//include interfcae 
`include "interface.sv"

//include one test at a time
 `include "random_test.sv"
//`include "directed_test.sv"
// `include "memory.sv"

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
    #1000 $finish;
  end
  
  
  //interface instance in order to connect DUT and testcase
  inf i_inf(clk,rst);

  // Override parameter values using defparam
  defparam i_inf.ADDR_WIDTH = 3;
  defparam i_inf.DATA_WIDTH = 8;

  //testcase instance, interface handle is passed to test 
  test t1(i_inf);
  
  //DUT instance, interface signals are connected to the DUT ports
  memory DUT (
    .clk(i_inf.clk),
    .rst(i_inf.rst),
    .addr(i_inf.addr),
    .wr_en(i_inf.wr_en),
    .rd_en(i_inf.rd_en),
    .wr_data(i_inf.wr_data),
    .rd_data(i_inf.rd_data)
   );

  initial begin
 	$dumpfile("dump.vcd");
	$dumpvars;
  end 
  
endmodule
