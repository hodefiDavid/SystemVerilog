// This is the transaction file for the fifo DUT
class transaction #(parameter AWIDTH = 4,  
parameter DWIDTH = 4);

//declare the transaction fields for fifo DUT
//port in
rand bit write_en,read_en;
rand bit [DWIDTH-1:0] data_in;
//port out
bit full,empty;
bit [DWIDTH-1:0] data_out;

//constraint for the transaction fields
// write_en and read_en should be opposite
constraint c1 { write_en == ~read_en; }

  function void display(string name);
    $display("-------------------------");
    $display("- %s ", name);
    display_in("port in");
    display_out("port out");
    $display("-------------------------");

  endfunction

  function void display_in(string name);
    $display(name);
    $display("write_en = %b", write_en);
    $display("read_en = %b", read_en);
    $display("data_in = %b", data_in);

  endfunction

  function void display_out(string name);
    $display(name);
    $display("full = %b", full);
    $display("empty = %b", empty);
    $display("data_out = %b", data_out);
  endfunction

endclass

