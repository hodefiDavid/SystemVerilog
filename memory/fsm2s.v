/*
https://hdlbits.01xz.net/wiki/Fsm2s

*/


module top_module(
    input clk,
    input reset,    // Asynchronous reset to OFF
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

    always @(posedge clk) begin
        if(reset)
            state = OFF;
        else
            state = next_state;
        // State flip-flops with asynchronous reset
    end

    // Output logic
    assign out = (state == ON)? 1 : 0;

endmodule
