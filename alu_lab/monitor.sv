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
      //data in capture from the interface/driver counter 8 bit
      @(posedge vinf.clk)
      trans.a = vinf.a;
      trans.b = vinf.b;
      trans.select = vinf.select;

      fork begin
      //data in capture from the interface/dut counter 8 bit
      // @(negedge vinf.clk) 
      @(posedge vinf.clk)
      trans.out = vinf.out;
      trans.zero = vinf.zero;
      trans.carry = vinf.carry;
      trans.sign = vinf.sign;
      trans.parity = vinf.parity;
      trans.overflow = vinf.overflow;

      mon2scb.put(trans);

      trans.display("[ --Monitor-- ]");
      end join_none 

    end
  endtask
  
endclass
