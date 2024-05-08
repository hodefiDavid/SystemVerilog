// design for a fifo 4 bit addres that holds 4 bit data in each one of them
// the fifo is 4 bit wide and 4 bit deep
// the fifo is implemented using a 4 bit wide 4 bit deep memory
// the fifo has a read and write pointer
// the fifo has a full and empty flag
// the fifo has a reset signal
// the fifo has a write enable signal
// the fifo has a read enable signal
// the fifo has a data in and data out signal
// the fifo has a clock signal
// the fifo has a module name fifo
module fifo(
    input wire clk,
    input wire rst,
    input wire write_en,
    input wire read_en,
    input wire [3:0] data_in,
    output wire [3:0] data_out,
    output wire full,
    output wire empty
);

    reg [3:0] memory [0:3];
    reg [1:0] write_ptr;
    reg [1:0] read_ptr;
    reg [3:0] data_out_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            write_ptr <= 2'b00;
            read_ptr <= 2'b00;
            memory[0] <= 4'b0000;
            memory[1] <= 4'b0000;
            memory[2] <= 4'b0000;
            memory[3] <= 4'b0000;
        end else begin
            if (write_en & !full) begin
                memory[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1;
            end
            if (read_en & !empty) begin
                data_out_reg <= memory[read_ptr];
                read_ptr <= read_ptr + 1;
            end
        end
    end

    assign full = (write_ptr+1'b1 == read_ptr);
    assign empty = (write_ptr == read_ptr);
    assign data_out = data_out_reg;

endmodule