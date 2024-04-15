module xor_2 (
    input in_a,
    input in_b,
    output out);
    assign out = in_a^in_b;

endmodule

module xnor_2 (
    input in_a,
    input in_b,
    output out);

    assign out = ~(in_a^in_b);
endmodule

module top_module (
    input in1,
    input in2,
    input in3,
    output out);
    wire nor12;
    xnor_2 M1 (in1,in2,nor12);
    xor_2 M2 (nor12,in3,out);
endmodule