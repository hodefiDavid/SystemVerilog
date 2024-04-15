module dcd2_4 (input a, b, output d0, d1, d2, d3);

assign {d3, d2, d1, do} =   ( {a, b} == 2'b00) ? 4'b0001 : 
                            ( {a, b} == 2'b01) ? 4'b0010 :
                            ( {a, b} == 2'b10) ? 4'b0100 :
                            ( {a, b} == 2'b11) ? 4'b1000 : 4'bXXXX;

endmodule