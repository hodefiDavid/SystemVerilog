//gets the packet from the generator and drives the transaction packet items into the interface 
//the interface is connected to the DUT, so that items driven into the interface will be driven 
//into the DUT

class driver;
  
  //count the number of transactions
  int num_transactions;
  
  //create virtual interface handle
  virtual inf vinf;
  
  //create mailbox handle
  mailbox gen2drv;
  
  //constructor
  function new(virtual inf vinf, mailbox gen2drv);
    //get the interface
    this.vinf = vinf;
    //get the mailbox handle from env 
    this.gen2drv = gen2drv;
  endfunction
  
  //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(vinf.rst);
    $display("[ --DRIVER-- ] ----- Reset Started -----");
    //reset all the interface signals of fifo DUT
    vinf.i_a = 0;
    vinf.i_b = 0;
    vinf.i_cin = 0;
    vinf.o_carry = 0;
    vinf.o_sum = 0;
    wait(!vinf.rst);
    $display("[ --DRIVER-- ] ----- Reset Ended   -----");
  endtask
  
  //drives the transaction items into interface signals
  task main;
    forever begin
      transaction trans;
      gen2drv.get(trans);
      @(posedge vinf.clk);
      //convert the transaction packet items into interface signals
      vinf.i_a = trans.i_a;
      vinf.i_b = trans.i_b;
      vinf.i_cin = trans.i_cin;
      
      trans.display_in("[ --Driver-- ]");
      num_transactions++;
    end
  endtask
  
endclass
