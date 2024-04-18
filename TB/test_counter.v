///////////////////////////////////////////////////////////////////////////
// MODULE               : counter_tb                                     //
//                                                                       // 
// PURPOSE              : 8-bit up counter test bench                    //
//                                                                       //
// DESIGNER             : Dorit Medina                                   //
//                                                                       //
///////////////////////////////////////////////////////////////////////////

//Refrence model
// module counter_tb(ref_count, data_in, clk, rst_n, load, enable);
//     output [7:0] ref_count;
//     input [7:0] data_in;
//     input clk, rst_n, load, enable;

//     reg [7:0] count;
//   always @(posedge clk or negedge rst_n) begin
//   if(!rst_n)
//     ref_count = 8'h00;
//   else if(load)
//     ref_count = data_in;
//   else if(enable)
//     ref_count = count + 8'h01;
// end
// endmodule


module test_counter;

  reg clk, rst_n, load, enable;
  reg [7:0] data_in;
  wire [7:0] count;
  reg [7:0] ref_count;
  integer num_errors;
  event start;
  event done;
  event random_test;

  counter dut (
      count,
      data_in,
      clk,
      rst_n,
      load,
      enable
  );
 

  initial  // START
    begin
      clk = 0;
      rst_n = 0;
      load = 0;
      enable = 0;
      data_in = 8'h00;
      //count = 8'h00;
      ref_count = 8'h00;
      num_errors = 0;
      #10->start;
    end
//aftwer reset check the val of count
  initial begin  // Clock generator
    @(start);
    #10 forever #10 clk = !clk;
  end


  initial  // Test stimulus
    begin : TEST_CASE_SIMPLE
      @(start);
      rst_n  = 1;
      enable = 1;
      #40 rst_n = 0;
      #40 rst_n = 1;
      #40 data_in = 8'd0;
      #40 load = 1;
      #40 load = 0;
      #40 data_in = 8'd250;
      #40 enable = 0;
      #100->random_test;
    end

  initial begin : RANDOM_TEST
    @(random_test);
    repeat (100) begin
      rst_n <= $random;
      enable <= $random;
      data_in <= $random;
      load <= $random;
    end
    #100->done;
  end

  //Refrence model
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) ref_count <= 8'h00;
    else if (load) ref_count <= data_in;
    else if (enable) ref_count <= count + 8'h01;
  end

  // Compare the output of the DUT with the reference model
  always @(posedge clk or negedge rst_n) begin
    @(start);
    if (count !== ref_count) begin
      $display("Error: count = %d, ref_count = %d", count, ref_count);
      num_errors = num_errors + 1;
    end
  end


  always @(posedge clk) begin
    @(done)
    if (num_errors > 0) $display("Test FAILED!: %d errors", num_errors);
    else $display("Test PASSED!");

    #100 $finish;
  end

  // Display the time, reset, clock, load, data_in, enable, and count
  initial $monitor($stime, rst_n, clk, load, data_in, enable, count);

endmodule
