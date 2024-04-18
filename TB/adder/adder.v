///////////////////////////////////////////////////////////////////////////
// MODULE               : adder                                          //
//                                                                       //
// DESIGNER             : David Hodefi                                   //
//                                                                       //
// Verilog code for 4-bit adder                                          //
// This is the behavioral description of an 4-bit adder		             //
//                                                                       //
///////////////////////////////////////////////////////////////////////////

module adder4b (input [3:0] A, input [3:0] B, output [4:0] Sum, input clk, input rst, input enable);

always @ (posedge clk or posedge rst) begin 
  if (rst) begin
     Sum = 4'b0;
  end else if(enable) begin
     Sum = A + B;
  end else begin
     Sum = Sum;
  end
end
   
endmodule
