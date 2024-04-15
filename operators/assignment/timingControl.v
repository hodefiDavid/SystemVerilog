// always @, event, wait
module test;

reg changes, clk;
event my_event;

always @ (posedge clk) begin
$display("@ posedge clk at $0t", $time);
end
always @ (changes) begin
$display("@ changes %0d at %0t", changes, $time) ;
end

always begin
wait (changes) ; //accuor only when we get one at changes (like an if statment)
$display("wait changes $0d at $0t", changes, $time);
#1;
end

always @ (my_event) begin
$display("@ my_event at %0t", $time);
end

initial begin
$dumpvars (1, test);

#5;
changes = 0;
clk = 0;

#5 changes = 1;
#5 changes = 0;

#5 clk = 1;
#5 clk = 0;

->my_event;
#10 ->my_event;

#10;
$finish;
end

endmodule

