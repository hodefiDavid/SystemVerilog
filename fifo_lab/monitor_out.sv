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
  // task main;
  //   forever begin
  //     transaction trans;
  //     trans = new();
  //     @(posedge vinf.clk)

  //     trans.data_out = vinf.data_out;
  //     trans.full = vinf.full; 
  //     trans.empty = vinf.empty; 
      
  //     trans.display_out("[ --Monitor_out-- ]");
  //     @(negedge vinf.clk);
  //     mon2scbout.put(trans);

  //   end
  // endtask
  


  //Samples the interface signal and sends the sampled packet to scoreboard
  task main;
    forever begin
      transaction trans;
      trans = new();
      //data in capture from the interface/driver counter 8 bit
      @(posedge vinf.clk)
      trans.data_out = vinf.data_out;
      trans.full = vinf.full; 
      trans.empty = vinf.empty; 

      fork begin
      //data in capture from the interface/dut counter 8 bit
      // @(negedge vinf.clk) 
      @(posedge vinf.clk)
         trans.read_en = vinf.read_en;
        trans.write_en = vinf.write_en;
        trans.data_in  = vinf.data_in;

      mon2scbout.put(trans);

      trans.display("[ --Monitor-- ]");
      end join_none 

    end
  endtask

  endclass