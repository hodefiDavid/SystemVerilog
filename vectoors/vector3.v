// Given an 8-bit input vector [7:0], reverse its bit ordering.

module top_module( 
    input [7:0] in,
    output [7:0] out
);
    parameter SIZE = 8;
    
    genvar i;
    generate
        for (i = 0; i < SIZE; i++) begin : assign_loop
            assign out[i] = in[SIZE-1 -i];
        end
    endgenerate
endmodule

module top_module( 
    input [7:0] in,
    output [7:0] out
);
    assign out[0] = in[7];
    assign out[1] = in[6];
    assign out[2] = in[5];
    assign out[3] = in[4];
    assign out[4] = in[3];
    assign out[5] = in[2];
    assign out[6] = in[1];
    assign out[7] = in[0];
endmodule