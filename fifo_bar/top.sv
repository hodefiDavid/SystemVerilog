`include "fifo_interface.sv"
`include "test.sv"
`include "fifo.sv"


module top();
bit clk;
bit rst;
// clock generation

initial begin
forever
#5 clk=!clk;
end
initial begin
@(posedge clk)
rst=1;
@(posedge clk)
rst=0;

end

initial begin
#10000 $finish;
end

fifo_interface f_interface(.clk(clk),.rst(rst));
test t1(f_interface);
fifo dut(f_interface.dut);






endmodule