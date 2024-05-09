//Samples the interface signals, captures the transaction packet 
//and sends the packet to scoreboard.

class monitor;
  
  //create virtual interface handle
  virtual inf vinf;
  
  //create mailbox handle
  mailbox mon2scb;
  
  //constructor
  function new(virtual inf vinf,mailbox mon2scb);
    //get the interface
    this.vinf = vinf;
    //get the mailbox handle from environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //Samples the interface signal and sends the sampled packet to scoreboard
  task main;
    forever begin
      transaction trans;
      trans = new();
      @(posedge vinf.clk);
      if (vinf.load)  begin                  //load=1
      trans.data_in  = vinf.data_in;
      trans.count = vinf.count ;
      trans.load =vinf.load; 
      end 
      else if(vinf.enable) begin                 //enable=1
      trans.data_in  = vinf.data_in; 
      trans.enable = vinf.enable;
      //@(posedge vinf.clk);
      trans.count = vinf.count ;
      end
      @(posedge vinf.clk);
      mon2scb.put(trans);
      trans.display("[ --Monitor-- ]"); // if something went wrong 
    end
  endtask
  
endclass