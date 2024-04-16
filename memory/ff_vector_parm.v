`timescale 1ns/100ps

module sizable_reg #(parameter size)
( input [size-1:0] d, input clk, rstn,
output reg [size-1:0] q);
always @( posedge clk, negedge rstn)
begin
if (~rstn)

#4 q <= 0;
else

#4 q <= d;
end

endmodule