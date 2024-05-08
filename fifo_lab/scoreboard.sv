//gets the packet from the monitor, generates the expected results 
//and compares with the actual results received from the monitor

class scoreboard;
   
  //create mailbox handle
  mailbox mon2scbin;
  mailbox mon2scbout;
  
  //count the number of transactions
  int num_transactions;
  
  //constructor
  function new(mailbox mon2scbin, mailbox mon2scbout);
    //get the mailbox handle from  environment 
    this.mon2scbin = mon2scbin;
    this.mon2scbout = mon2scbout;
  endfunction
  
  //Compare the actual results with the expected results
  task main;
    transaction trans_in;
    transaction trans_out;
    forever begin
      mon2scbin.get(trans_in);
      mon2scbout.get(trans_out);
      if(trans_out.sum == (trans_in.a+trans_in.b))
          $display("Result is as Expected");
        else
          $error("Wrong Result.\n\tExpeced: %0d Actual: %0d",(trans_in.a+trans_in.b),trans_out.sum);
        num_transactions++;
      trans_in.display("[ --Scoreboard_in-- ]");
      trans_out.display("[ --Scoreboard_out-- ]");
    end
  endtask



  
endclass