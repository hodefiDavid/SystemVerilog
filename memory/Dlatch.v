/*
Implement the following circuit:

Exams m2014q4a.png

Note that this is a latch, 
so a Quartus warning about having inferred a latch is expected.
*/

module top_module (
    input d, 
    input ena,
    output q);
always@*
    begin
    if(ena)
        q = d;
    else
        q = q;
    end

endmodule