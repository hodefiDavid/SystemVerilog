//Create 8 D flip-flops with active high synchronous reset. 
//All DFFs should be triggered by the positive edge of clk.

module top_module (
    input clk,
    input reset,            // Synchronous reset
    input [7:0] d,
    output [7:0] q
);

//for asynchronous     always@(posedge clk or posedge reset) begin
    always@(posedge clk) begin

        if(reset)
            q <= 8'b0;
        else
            q <= d;
    end


endmodule