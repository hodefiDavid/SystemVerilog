/*
Verilog has a ternary conditional operator ( ? : ) much like C:

(condition ? if_true : if_false)

This can be used to choose one of two values based on condition (a mux!) on one line, without using an if-then inside a combinational always block.

Examples:

(0 ? 3 : 5)     // This is 5 because the condition is false.
(sel ? b : a)   // A 2-to-1 multiplexer between a and b selected by sel.

always @(posedge clk)         // A T-flip-flop.
  q <= toggle ? ~q : q;

always @(*)                   // State transition logic for a one-input FSM
  case (state)
    A: next = w ? B : A;
    B: next = w ? A : B;
  endcase

assign out = ena ? q : 1'bz;  // A tri-state buffer

((sel[1:0] == 2'h0) ? a :     // A 3-to-1 mux
 (sel[1:0] == 2'h1) ? b :
                      c )
A Bit of Practice
Given four unsigned numbers, find the minimum. Unsigned numbers can be compared with standard comparison operators (a < b). Use the conditional operator to make two-way min circuits, then compose a few of them to create a 4-way min circuit. You'll probably want some wire vectors for the intermediate results.

Expected solution length: Around 5 lines.
*/

module minmax_2(
    input [7:0] a, b,
    output [7:0] min, max);

    assign min = (a<b)? a : b;
    assign max = (a>b)? a : b;


endmodule


module top_module (
    input [7:0] a, b, c, d,
    output [7:0] min);//
    wire [7:0] min1, max1,min2, max2,max3;
    minmax_2 M1 (a,b,min1, max1);
    minmax_2 M2 (c,d,min2, max2);
    minmax_2 M3 (min1,min2,min, max3);

    // assign intermediate_result1 = compare? true: false;

endmodule