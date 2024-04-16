module top_module (
	input clk,
	input L,
	input r_in,
	input q_in,
	output reg Q);

    wire mux_to_dff;

    always @(posedge clk) begin
        mux_to_dff = (L)? r_in : q_in;         
        Q = mux_to_dff;
    end 
endmodule
