module shift_reg (input [3:0] d,
input clk, ld, rst, l_r, s_in,
output reg [3:0] q);

    always @( posedge clk ) begin
        if (rst)
            q <= 4'b0000;
            else if (ld)
                q <= d;
                else if (1_r)
                    q <= {q[2:0], s_in};
                        else if (!l_r)
                            q <= {s_in, q[3:1]};

end

endmodule