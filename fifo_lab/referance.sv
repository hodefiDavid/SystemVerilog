//referance model class for fifo 4 bit
class referance;
 
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
    bit tag [3:0];
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
    
    task bit is_empty()
            if(this.tag == 2'b00)
                return 1; 
            else
                return 0; 
    endtask

   task bit is_full()
            if(this.tag == 2'b11)
                return 1; 
            else
                return 0; 
    endtask

    task transaction step(transaction trans_in);
        //functunality for fifo 4bit
        if(trans_in.rst)
            this.reset();
        //if read is on but the fifo is empty
        else if(trans_in.read_en && is_empty())
        else if(trans_in.write_en && is_full())
        //if read is on and memory in the ptr_read is not empty
        else if(trans_in.read_en && this.tag[ptr_read] == 1'b1) begin
        data_out = mem[ptr_read];
        this.tag[ptr_read] = 1'b0;
        increment_ptr(this.flag_read);
        end
        else if(trans_in.write_en && this.tag[ptr_write] == 1'b0) begin
        mem[ptr_write] = data_in;
        this.tag[ptr_write] = 1'b1;
        increment_ptr(this.flag_write);
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