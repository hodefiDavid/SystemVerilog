//Samples the interface signals, captures the transaction packet 
//and sends the packet to scoreboard.

class monitor;
  
  //create virtual interface handle
  virtual mem_intf vinf;
  
  //create mailbox handle
  mailbox mon2scb;
  
  //constructor
  function new(virtual mem_intf vinf,mailbox mon2scb);
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
      @(posedge vinf.clk)
      trans.addr  <= vinf.addr;
      trans.wr_en <= vinf.wr_en;
      trans.rd_en <=vinf.rd_en;          
      trans.wr_data  <= vinf.wr_data; 
      //@(posedge vinf.clk);
      trans.rd_data = vinf.rd_data ; 
     
      @(posedge vinf.clk);
      mon2scb.put(trans);
      trans.display("[ --Monitor-- ]"); // if something went wrong 
    end
  endtask
  
endclass