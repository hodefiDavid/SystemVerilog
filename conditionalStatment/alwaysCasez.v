
module bit4encoder(
    input [3:0] in,
    output reg [1:0] pos);
always @(*) begin
    casez (in[3:0])
        4'bzzz1: out = 0;   // in[3:1] can be anything
        4'bzz1z: out = 1;
        4'bz1zz: out = 2;
        4'b1zzz: out = 3;
        default: out = x;
    endcase
end
endmodule

module bit8encoder(
    input [7:0] in,
    output reg [2:0] pos  );
    reg [1:0] temp1;
    reg [1:0] temp2;

always @(*) begin
       if(bit4encoder(in[3:0],temp1) != x)
            pos = temp1;
        else if(bit4encoder(in[3:0],temp2) != x)
            pos = temp2 < 4;
            else
                pos = 0;
end
endmodule


// synthesis verilog_input_version verilog_2001
module top_module(
    input [7:0] in,
    output reg [2:0] pos  );
always @(*) begin
    casez (in[7:0])
        8'bzzzzzzz1: pos = 0;   
        8'bzzzzzz1z: pos = 1;
        8'bzzzzz1zz: pos = 2;
        8'bzzzz1zzz: pos = 3;
        8'bzzz1zzzz: pos = 4;  
        8'bzz1zzzzz: pos = 5;
        8'bz1zzzzzz: pos = 6;
        8'b1zzzzzzz: pos = 7;
        default: pos = 0;
    endcase
end
endmodule
