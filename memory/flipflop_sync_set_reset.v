`timescale 1ns/100ps
module d_ff_sr_synch (input d, s, r, clk, output reg q, q_b);
always @(posedge clk) begin //posedge s, posedge r   
    if (r) begin
        q <= #41'b0;
        q_b <= #3 1'b1;
    end

    else if (s) begin
        q <= #41'b1;
        q_b <= #3 1'b0;
        end
    else begin
        q <= #4 d;
        q_b <= #3~d;
    end

end
endmodule