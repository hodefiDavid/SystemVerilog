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
      //data in capture from the interface/driver fifo
      @(posedge vinf.clk)
      trans.write_en = vinf.write_en;
      trans.read_en = vinf.read_en;
      trans.data_in = vinf.data_in;
     
      fork begin
      //data in capture from the interface/dut fifo
      // @(negedge vinf.clk) 
      @(posedge vinf.clk)
      trans.full = vinf.full;
      trans.empty = vinf.empty;
      trans.data_out = vinf.data_out;
      

      mon2scb.put(trans);

      trans.display("[ --Monitor-- ]");
      end join_none 

    end
  endtask
  
endclass
