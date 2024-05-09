//gets the packet from the monitor, generates the expected results 
//and compares with the actual results received from the monitor

class scoreboard;
   
  //create mailbox handle
  mailbox mon2scb;
  
  //count the number of transactions
  int num_transactions;
  bit [7:0] precount;
  //constructor
  function new(mailbox mon2scb);
    //get the mailbox handle from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //Compare the actual results with the expected results
  task main;
    transaction trans;
    forever begin
      mon2scb.get(trans);

        if(trans.load)
         begin
        precount =trans.data_in;
        if (trans.count == trans.data_in)
         $display("Result is as Expected");
        else
          $error("Wrong Result.\n\tExpeced: %0d Actual: %0d",(trans.data_in),trans.count);
        end

        else if (trans.enable)
         begin
           precount ++ ;
       if(trans.count==precount) 
       
          $display("Result is as Expected");
        else
          $error("Wrong Result.\n\tExpeced: %0d Actual: %0d",(precount),trans.count);
     
      
        end 


        num_transactions++;
      trans.display("[ --Scoreboard-- ]");
    end
  endtask
  
endclass