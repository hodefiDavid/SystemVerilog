/*
Declaring wires
The circuits so far have been simple enough that the outputs are simple functions of the inputs. 
As circuits become more complex, you will need wires to connect internal components together. 
When you need to use a wire, you should declare it in the body of the module, 
somewhere before it is first used. (In the future, 
you will encounter more types of signals and variables that are also declared the same way, 
but for now, we'll start with a signal of type wire).
*/

`default_nettype none
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   ); 

    wire aAndB;
    wire cAndD;
    wire AnBorCnD;

    assign aAndB = a&b;
    assign cAndD = c&d;
    assign AnBorCnD = aAndB|cAndD;

    assign out = AnBorCnD;
    assign out_n = ~AnBorCnD;

endmodule


