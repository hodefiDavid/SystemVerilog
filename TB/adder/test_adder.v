// ///////////////////////////////////////////////////////////////////////////
// // MODULE               : adder_tb                                       //
// //                                                                       // 
// // PURPOSE              : 4-bit up adder test bench                      //
// //                                                                       //
// // DESIGNER             : David Hodefi                                   //
// //                                                                       //
// ///////////////////////////////////////////////////////////////////////////


module test_adder;

  reg clk, rst, enable;
  reg  [3:0] A;
  reg  [3:0] B;
  wire [4:0] DUT_Sum;
//   wire  [4:0] Ref_Sum;
  wire  [4:0] Ref_Sum;


  integer num_errors;
  event   start;
  event   done;
  event   random_test;




  adder4b dut (
      .A(A),
      .B(B),
      .Sum(DUT_Sum),
      .clk(clk),
      .rst(rst),
      .enable(enable)
  );

    adder4b_tb ref (
        .A(A),
        .B(B),
        .Ref_Sum(Ref_Sum),
        .clk(clk),
        .rst(rst),
        .enable(enable)
    );

  initial  // START
    begin
      clk = 0;
      rst = 1;
      enable = 1;
      num_errors = 0;
      A = 4'b0;
      B = 4'b0;
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
      rst  = 1;
      enable = 1;
      #40 rst = 0;
      #40 A = 4'b0011;
      #40 B = 4'b0011;
      #40 enable = 0;
      #40 enable = 1;
      #40 A = 4'b1111;
      #40 B = 4'b1111;
      #100->random_test;
    end

  initial begin : RANDOM_TEST
    @(random_test);
    repeat (500) #20 begin
      rst <= $random;
      enable <= $random;
      A <= $random;
      B <= $random;
    end
    #100->done;
  end


  // Compare the output of the DUT with the reference model
  always @(posedge clk or negedge rst) begin
    @(start);
    if (DUT_Sum !== Ref_Sum) begin
      $display("Error: DUT_Sum = %d, Ref_Sum = %d", DUT_Sum, Ref_Sum);
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
//   initial $monitor($stime, rst_n, clk, load, data_in, enable, count);

endmodule


// module adder4b_tb (
//     input [3:0] A,
//     input [3:0] B,
//     output [4:0] Ref_Sum,
//     input clk,
//     input rst,
//     input enable
// );

//     always @(posedge clk or posedge rst) begin
//         if (rst) begin
//             Ref_Sum <= 5'b0;
//         end else if (enable) begin
//             Ref_Sum <= A + B;
//         end else begin
//             Ref_Sum <= Ref_Sum;
//         end
//     end

// endmodule

// module test_adder;

//   reg clk, rst, enable;
//   reg  [3:0] A;
//   reg  [3:0] B;
//   wire [4:0] DUT_Sum;
//   wire [4:0] Ref_Sum;

//   integer num_errors;
//   event   start;
//   event   done;
//   event   random_test;

//   adder4b dut (
//       .A(A),
//       .B(B),
//       .Sum(DUT_Sum),
//       .clk(clk),
//       .rst(rst),
//       .enable(enable)
//   );

//   adder4b_tb ref (
//       .A(A),
//       .B(B),
//       .Ref_Sum(Ref_Sum),
//       .clk(clk),
//       .rst(rst),
//       .enable(enable)
//   );

//   initial begin
//     clk = 0;
//     rst = 1;
//     enable = 1;
//     num_errors = 0;
//     A = 4'b0;
//     B = 4'b0;
//     #10->start;
//   end

//   initial begin
//     @(start);
//     #10 forever #10 clk = !clk;
//   end

//   initial begin
//     @(start);
//     rst  = 1;
//     enable = 1;
//     #40 rst = 0;
//     #40 A = 4'b0011;
//     #40 B = 4'b0011;
//     #40 enable = 0;
//     #40 enable = 1;
//     #40 A = 4'b1111;
//     #40 B = 4'b1111;
//     #100->random_test;
//   end

//   initial begin
//     @(random_test);
//     repeat (500) #20 begin
//       rst <= $random;
//       enable <= $random;
//       A <= $random;
//       B <= $random;
//     end
//     #100->done;
//   end

//   always @(posedge clk or negedge rst) begin
//     @(start);
//     if (DUT_Sum !== Ref_Sum) begin
//       $display("Error: DUT_Sum = %d, Ref_Sum = %d", DUT_Sum, Ref_Sum);
//       num_errors = num_errors + 1;
//     end
//   end

//   always @(posedge clk) begin
//     @(done);
//     if (num_errors > 0) $display("Test FAILED!: %d errors", num_errors);
//     else $display("Test PASSED!");

//     #100 $finish;
//   end

// endmodule