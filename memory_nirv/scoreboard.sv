//gets the packet from the monitor, generates the expected results 
//and compares with the actual results received from the monitor

class scoreboard #(ADDR_WIDTH = 3, DATA_WIDTH=8 );
   
  //create mailbox handle
  mailbox mon2scb;
  
  //count the number of transactions
  int num_transactions;
  bit [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH];
  

  //constructor
  function new(mailbox mon2scb);
    //get the mailbox handle from  environment 
    this.mon2scb = mon2scb;

   
  foreach (mem[i]) begin
    mem[i] = 8'hFF;
  end
 
  endfunction
  
  //Compare the actual results with the expected results
  task main;
    transaction trans;
    forever begin
      mon2scb.get(trans);

        if(trans.wr_en)
         begin
       mem[trans.addr] = trans.wr_data;
         end 
        else if (trans.rd_en)
         begin
       if(trans.rd_data==mem[trans.addr]) 
          $display("Result is as Expected");
        else
          $error("Wrong Result.\n\tExpeced: %0d Actual: %0d",(mem[trans.addr]),trans.rd_data);
        end 


        num_transactions++;
      trans.display("[ --Scoreboard-- ]");
    end
  endtask
  
endclass