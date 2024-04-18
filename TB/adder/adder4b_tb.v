//Refrence model
module adder4b_tb (
    input [3:0] A,
    input [3:0] B,
    output [4:0] Ref_Sum,
    input clk,
    input rst,
    input enable
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Ref_Sum = 5'b0;
    end else if (enable) begin
        Ref_Sum = A + B;
    end else begin
        Ref_Sum = Ref_Sum;
    end
end

endmodule