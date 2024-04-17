/*
This is a Moore state machine with two states, two inputs, and one output. Implement this state machine.

This exercise is the same as fsm2s, but using asynchronous reset.

https://hdlbits.01xz.net/wiki/Fsm2
*/


module top_module(
    input clk,
    input areset,    // Asynchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        
        case(state)

        ON: next_state <= (k)? OFF : ON;
        OFF: next_state <= (j)? ON : OFF;

        endcase

    end

    always @(posedge clk, posedge areset) begin
        if(areset)
            state = OFF;
        else
            state = next_state;
        // State flip-flops with asynchronous reset
    end

    // Output logic
    assign out = (state == ON)? 1 : 0;

endmodule