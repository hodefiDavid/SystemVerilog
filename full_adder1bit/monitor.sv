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
      trans.i_a = vinf.i_a;
      trans.i_b = vinf.i_b;
      trans.i_cin = vinf.i_cin;

      fork begin
      //data in capture from the interface/dut counter 8 bit
      // @(negedge vinf.clk) 
      @(posedge vinf.clk)
      trans.o_sum = vinf.o_sum;
      trans.o_carry = vinf.o_carry;

      mon2scb.put(trans);

      trans.display("[ --Monitor-- ]");
      end join_none 

    end
  endtask
  
endclass
