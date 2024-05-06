//Samples the interface output signals, captures the transaction packet 
//and sends the packet to scoreboard.

class monitor_out;
  
  //create virtual interface handle
  virtual inf vinf;
  
  //create mailbox handle
  mailbox mon2scbout;
  
  //constructor
  function new(virtual inf vinf,mailbox mon2scbout);
    //get the interface
    this.vinf = vinf;
    //get the mailbox handle from environment 
    this.mon2scbout = mon2scbout;
  endfunction
  
  //Samples the interface signal and sends the sampled packet to scoreboard
  task main;
    forever begin
      transaction trans;
      trans = new();
      //@(posedge vinf.clk);
      wait(vinf.enable);
      @(posedge vinf.clk);
      @(posedge vinf.clk);
      trans.sum = vinf.sum;
      trans.display("[ --Monitor_out-- ]");
      mon2scbout.put(trans);
    end
  endtask
  
endclass