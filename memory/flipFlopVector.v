`timescale 1ns/100ps

reg [7:0] q_int;

AIL

module vector_ff ( input [7:0] d, input clk, rst, oe,
output [7:0] q);

always @( posedge clk )
if (rst)
#4 q_int <= 8'b0000_0000;
else

#4 q_int <= d
assign q = oe ? q_int : 8'bZ;
endmodule
