class transaction;
rand bit rd;
rand bit wr;
rand logic [3:0] wdata;
logic [3:0] rdata;
logic full;
logic empty; 
int rst;

//constraints:
constraint opp_read_write  {rd!=wr;}
//constraint only_read  {wr==0;}
//constraint only_write  {rd==0;}
//constraint read_or_write {!(write_en && read_en);}
  function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    $display("- read = %d, write = %d",rd,wr);
	$display("- wdata = %d, rdata = %d",wdata,rdata);
    $display("- full = %d empty = %d",full,empty);
    $display("-------------------------");
  endfunction
  
  
endclass