//Samples the interface signals, captures the transaction packet 
//and sends the packet to scoreboard.

class monitor;
  
  //create virtual interface handle
  virtual inf vinf;
  
  //create mailbox handle
  mailbox mon_in2scb;
  mailbox mon_out2scb;


  //constructor
  function new(virtual inf vinf,mailbox mon_in2scb, mailbox mon_out2scb);
    //get the interface
    this.vinf = vinf;
    //get the mailbox handle from environment 
    this.mon_in2scb = mon_in2scb;
    this.mon_out2scb = mon_out2scb;
  endfunction
  
  //Samples the interface signal and sends the sampled packet to scoreboard
  task main;
    forever begin
    
      //data in capture from the interface/driver ALU
      @(posedge vinf.clk)
      transaction trans_in;
      trans = new();
      trans_in.in0 =vinf.in0;
      trans_in.in1 = vinf.in1;
      trans_in.in2 = vinf.in2;
      trans_in.in3 = vinf.in3;
      trans_in.select = vinf.select;  

      mon_in2scb.put(trans_in);

      fork begin
      //data in capture from the interface/dut ALU
      // @(negedge vinf.clk) 
      @(posedge vinf.clk)
      transaction trans_out;
      trans = new();

      trans_out.out = vinf.out;

      mon_out2scb.put(trans);

      trans.display("[ --Monitor-- ]");
      end join_none 

    end
  endtask
  
endclass
