//gets the packet from the monitor, generates the expected results 
//and compares with the actual results received from the monitor
`include "reference.sv"

class scoreboard;
   
  //create mailbox handle
  mailbox mon_in2scb;
  mailbox mon_out2scb;
  reference rfm;
  transaction res; 

  //count the number of transactions
  int num_transactions;
  
  int num_errors;
  int num_success;

  //constructor
  function new(mailbox mon_in2scb, mailbox mon_out2scb);
    //get the mailbox handle from  environment 
    this.mon_in2scb = mon_in2scb;
    this.mon_out2scb = mon_out2scb;
    this.rfm = new();
    this.res = new();
  endfunction
  
  //Compare the actual results with the expected results
  task main;
    //transaction that we receive from the monitor from the driver/Interface
    transaction trans;
    //transaction that we receive from the monitor from the DUT/Interface


    forever begin
      $display("num of transactions: %d", num_transactions);
      $display("num of errors: %d", num_errors);
      $display("num of success: %d", num_success);
      mon2scb.get(trans);
      //here we are sending the transaction packet to reference model
      res = rfm.step(trans);
      //compare the actual results with the expected results
      if(res.out == trans.out) begin
          $display("Result is as Expected");
          num_success++;
      end
        else begin

          $error("Wrong Result!");
          trans.display("[ --Scoreboard DUT-- ]");
          res.display("[ --Scoreboard REF-- ]");
          num_errors++;
        end
        num_transactions++;
    end
  endtask



  
endclass