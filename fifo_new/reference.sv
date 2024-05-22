//referance model class for alu

class reference #(
    parameter AWIDTH = 4,  
    parameter DWIDTH = 4
    );
transaction res;
localparam DEPTH = 2** AWIDTH;  
//Queue to store the the data[DWIDTH-1:0] with fixed size of depth 
bit[DWIDTH-1:0] queue [$:DEPTH];
bit[DWIDTH-1:0] data;
function new();
    reset();
    this.res = new();
endfunction

function void reset();

endfunction

function transaction step(transaction trans);
        this.res = new();
          if (trans.read_en && this.queue.size() > 0) begin
            // Read data from the queue
            this.res.data_out = queue.pop_front();
            this.data = this.res.data_out;
        end
        if (trans.write_en) begin
            // Check if the queue is full
            if (queue.size() >= DEPTH) begin
                // The queue is full, handle this situation as needed
            end else begin
                // Write data into the queue
                queue.push_back(trans.data_in);
                this.res.data_out = data;
            end
        end
        this.res.full = (queue.size() == DEPTH);
        this.res.empty = (queue.size() == 0);
        return this.res;
    endfunction

 endclass

