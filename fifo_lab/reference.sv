//referance model class for fifo 4 bit
class reference;
 
 //declare output and input signals
    bit flag_write=1;
    bit flag_read=0;

    bit [3:0] data_out;
    bit full;
    bit empty;
    transaction trans;

    bit [3:0] data_in;
    bit write_en;
    bit read_en;
    bit rst;

    bit [3:0] mem [3:0];
    bit [3:0] tag;
    bit [1:0] ptr_read;
    bit [1:0] ptr_write;

    //constructor - initialize the signals
    function new();
      reset();
    endfunction

    task reset();
    this.data_out = 4'b0;
    this.full = 1'b0;
    this.empty = 1'b1;

    this.data_in = 4'b0;
    this.write_en = 1'b0;
    this.read_en = 1'b0;
    this.rst = 1'b0;

    this.trans = new();
    this.tag = 4'b0;
    this.ptr_read = 2'b0;
    this.ptr_write = 2'b0;
    for(int i=0;i<4;i++)
        this.mem[i] = 4'b0; 

    endtask
    
function bit is_empty();
    if(this.tag == 4'b0000)
        return 1; 
    else
        return 0; 
endfunction       

function bit is_full();
    if(this.tag == 4'b1111)
        return 1; 
    else
        return 0; 
endfunction

    task step(transaction trans_in);
   
        //functunality for fifo 4bit
        if(trans_in.rst)
            this.reset();
        //if read is on but the fifo is empty
        else if(trans_in.read_en && is_empty());
        else if(trans_in.write_en && is_full()); 

        //if read is on and memory in the ptr_read is not empty
        else if(trans_in.read_en && !is_empty()) begin
        data_out = mem[ptr_read];
        this.tag[ptr_read] = 1'b0;
        // increment_ptr(this.flag_read);
        this.ptr_read++;

        end
        else if(trans_in.write_en && !is_full()) begin
        mem[ptr_write] = data_in;
        this.tag[ptr_write] = 1'b1;
        // increment_ptr(this.flag_write);
        this.ptr_write++;
        end
        this.empty = is_empty();
        this.full = is_full();


    endtask

    //increment the pointer read and write
    //if the pointer is at the end of the memory, it will be reset to 0
    //else it will be incremented by 1
    //if we will get in the flag 1, we will increment the write pointer
    //else we will increment the read pointer

    task increment_ptr(bit flag);
        if(flag)
            if(this.ptr_write == 2'b11)
             this.ptr_write = 2'b00;
            else
             this.ptr_write =  this.ptr_write + 2'b01;
        
        else
            if(this.ptr_read == 2'b11)
             this.ptr_read = 2'b00;
            else
             this.ptr_read =  this.ptr_read + 2'b01;
    endtask

 endclass

// // class reference;
// //     // Inputs
// //     rand bit clk;
// //     rand bit rst;
// //     rand bit write_en;
// //     rand bit read_en;
// //     rand logic [3:0] data_in;

// //     // Outputs
// //     bit [3:0] data_out;
// //     bit full;
// //     bit empty;

// //     // Internal variables
// //     bit [3:0] memory [0:3];
// //     bit [1:0] write_ptr;
// //     bit [1:0] read_ptr;
// //     bit [3:0] data_out_reg;

// //     // Constructor
// //     function new();
// //         write_ptr = 2'b00;
// //         read_ptr = 2'b00;
// //         memory[0] = 4'b0000;
// //         memory[1] = 4'b0000;
// //         memory[2] = 4'b0000;
// //         memory[3] = 4'b0000;
// //     endfunction

// //     function void reset();
// //         write_ptr = 2'b00;
// //         read_ptr = 2'b00;
// //         memory[0] = 4'b0000;
// //         memory[1] = 4'b0000;
// //         memory[2] = 4'b0000;
// //         memory[3] = 4'b0000;
// //         endfunction

// //     // Method to write data into FIFO
// //     task write_data(input logic [3:0] data);
// //         if (write_en && !full) begin
// //             memory[write_ptr] = data;
// //             write_ptr = write_ptr + 1;
// //         end
// //     endtask

// //     // Method to read data from FIFO
// //     task read_data();
// //         if (read_en && !empty) begin
// //             data_out_reg = memory[read_ptr];
// //             read_ptr = read_ptr + 1;
// //         end
// //     endtask

// //     // Method to check if FIFO is full
// //     function bit is_full();
// //         return (write_ptr + 1 == read_ptr);
// //     endfunction

// //     // Method to check if FIFO is empty
// //     function bit is_empty();
// //         return (write_ptr == read_ptr);
// //     endfunction

// // endclass
