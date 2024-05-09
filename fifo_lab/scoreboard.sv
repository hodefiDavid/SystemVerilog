//gets the packet from the monitor, generates the expected results 
//and compares with the actual results received from the monitor
`include "reference.sv"

class scoreboard;
   
  //create mailbox handle
  mailbox mon2scbin;
  mailbox mon2scbout;
  reference rfm;
  //count the number of transactions
  int num_transactions;
  
  //constructor
  function new(mailbox mon2scbin, mailbox mon2scbout);
    //get the mailbox handle from  environment 
    this.mon2scbin = mon2scbin;
    this.mon2scbout = mon2scbout;
    this.rfm = new();
  endfunction
  
  //Compare the actual results with the expected results
  task main;
    //transaction that we receive from the monitor from the driver/Interface
    transaction trans_in;
    //transaction that we receive from the monitor from the DUT/Interface
    transaction trans_out;


    forever begin
      mon2scbin.get(trans_in);
      mon2scbout.get(trans_out);
      //here we are sending the transaction packet to reference model
      rfm.step(trans_in);
      // if(trans_in.rst)
      //   rfm.reset();
      //   else if(trans_in.read_en)
      //     rfm.read_data();
      //       else
      //         rfm.write_data(trans_in.data_in);
      //comparing the actual results with the expected results
      if(trans_out.full == rfm.full && trans_out.empty == rfm.empty && trans_out.data_out == rfm.data_out)
          $display("Result is as Expected");
        else begin

          $error("Wrong Result!");
          $error("data_out : Expeced: %d Actual: %d",rfm.data_out,trans_out.data_out);
          $error("empty : Expeced: %0d Actual: %0d",rfm.empty,trans_out.empty);
          $error("full : Expeced: %0d Actual: %0d",rfm.full,trans_out.full);

        end

        num_transactions++;
      trans_in.display("[ --Scoreboard_in-- ]");
      trans_out.display("[ --Scoreboard_out-- ]");
    end
  endtask



  
endclass