///////////////////////////////////////////////////////////////////////////
// MODULE               : adder                                          //
//                                                                       //
// DESIGNER             : David Hodefi                                   //
//                                                                       //
// Verilog code for 4-bit adder                                          //
// This is the behavioral description of an 4-bit adder		             //
//                                                                       //
///////////////////////////////////////////////////////////////////////////

module memory4b (
    input clk,
    input rst,
    input enable,
    input rd_wr,  //rd_wr 0 -write, 1 read
    input [2:0] addr,
    input [7:0] wr_data,
    output [7:0] rd_data
);
///////////////////////////////////////////////////////////////////////////////////////////
//   reg [4:0] internal_sum;

//   always @(posedge clk or posedge rst) begin
//     if (rst) begin
//       rd_data <= 8'hFF;
//     end else if (enable) begin
//         if (rd_wr) begin
//             pass
//         end else begin
//             pass
//         end
//       internal_sum <= A + B;
//     end else begin
//       internal_sum <= Sum;
//     end
//   end

//   assign Sum = internal_sum;

endmodule
