module fifo
//#(parameter width=4, depth=5)
(fifo_interface.dut inf);


reg [4-1:0] mem [5-1:0]; 
integer i;
int pointer=-1;
assign {inf.full,inf.empty}={(pointer==5-1),(pointer==-1)};
always @(posedge inf.clk, posedge inf.rst) begin

if (inf.rst) begin
for (i=0 ; i<5 ; i=i+1) begin
mem[i]=0;
end //for
pointer=-1;
end //if

/*else if ((pointer=-1 & !inf.wr) ||(pointer==0 & inf.rd)) begin //going to be empty
inf.full <=0;
inf.empty <=1;
end
else if ((pointer==4 & !inf.rd) ||(pointer==3 & inf.wr)) begin //going to be full
inf.full <=1;
inf.empty <=0;
end
*/


else begin
//inf.full <=0;
//inf.empty <=1;
case({inf.rd,inf.wr})
2'b01: begin //write
if (pointer<4) begin
mem[pointer+1] <= inf.wdata;
pointer++;
end
end
2'b10: begin //read
if (pointer>-1) begin
inf.rdata<=mem[0];
for(i=1 ; i< pointer+1 ; i++) 
mem[i-1]<=mem[i];
pointer--;
end
end
endcase
end

end


endmodule