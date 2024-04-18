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

    reg [4:0] internal_sum;

always @ (posedge clk or posedge rst) begin 
   if (rst) begin
       internal_sum <= 5'b0;
   end else if(enable) begin
       internal_sum <= A + B;
   end else begin
       internal_sum <= Sum;
   end
end

assign Sum = internal_sum;
    
endmodule
