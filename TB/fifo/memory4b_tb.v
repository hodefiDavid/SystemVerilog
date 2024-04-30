//Refrence model
module adder4b_tb (
    input [3:0] A,
    input [3:0] B,
    output [4:0] Ref_Sum,
    input clk,
    input rst,
    input enable
);
//////////////////////////////////////////////////////////////////////
//     reg [4:0] internal_sum;

// always @(posedge clk or posedge rst) begin
//     if (rst) begin
//         internal_sum = 5'b0;
//     end else if (enable) begin
//         internal_sum = A + B;
//     end else begin
//         internal_sum = Ref_Sum;
//     end
// end
// assign Ref_Sum = internal_sum;

endmodule