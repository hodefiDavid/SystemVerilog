interface fifo_interface(input clk,rst);
 bit rd,wr;
 bit [7:0] wdata;
 bit [7:0] rdata;
 logic empty,full;
 
 modport dut(input .clk(clk),.rst(rst),.rd(rd),.wr(wr),.wdata(wdata), output .rdata(rdata),.empty(empty),.full(full));
endinterface