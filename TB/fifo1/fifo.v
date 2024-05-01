// Code your design here
module fifo #(
    parameter width = 4,
    depth = 5
) (
    input rd,
    wr,
    rst,
    clk,
    input [width-1:0] wdata,
    output reg [width-1:0] rdata,
    output reg empty,
    full
);



  reg [width-1:0] memory[depth-1:0];
  integer i;
  integer pointer = 0;
  //assign empty=pointer? 0 : 1;
  //assign full=(pointer==depth-1)? 1 : 0;
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      for (i = 0; i < depth; i = i + 1) begin
        memory[i] = 0;
      end  //for
    end  //if



    /*if (rd)
$display("read mode: pointer-%0d data read %0h",pointer,rdata);
else if (wr)
$display("write mode: pointer-%0d data write %0h",pointer,wdata);
end*/
    case ({
      rd, wr
    })
      2'b01: begin  //write
        $display("write mode: pointer-%0d data write %0h", pointer, wdata);
        memory[pointer] = wdata;
        empty = 0;
        if (pointer < depth - 1) begin
          full = 0;
          pointer = pointer + 1;
        end else begin
          full = 1;
        end
        $display("memory at pointer %d is %d", pointer, memory[pointer]);

      end  //case 01

      2'b10: begin  //rd
        $display("read mode: pointer-%0d data read %0h", pointer, rdata[pointer]);
        if (pointer >= 0) begin
          rdata = memory[pointer];
          
          full  = 0;

        end
        if (pointer > 0) begin
          empty   = 0;
          pointer = pointer - 1;
        end //if
else begin
          empty = 1;
        end
      end  //case 10
      //default:
      //$display("illegal rd wr input at time %t read is %d and write is %d",$time,rd,wr);
    endcase

  end
endmodule
