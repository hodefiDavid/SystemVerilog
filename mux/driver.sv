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
  // negedge reset signal that resets the interface signals in low mode
  task reset;
    wait(!vinf.rst_n);
    $display("[ --DRIVER-- ] ----- Reset Started -----");
    //reset all the interface signals of fifo DUT
   
    wait(vinf.rst_n);
    $display("[ --DRIVER-- ] ----- Reset Ended   -----");
  endtask
  
  //drives the transaction items into interface signals
  task main;
    forever begin
      transaction trans;
      gen2drv.get(trans);

      // wait for the positive edge of the clock signal - why??? i need to understand this
      @(posedge vinf.clk);
      //convert the transaction packet items into interface signals
        vinf.in0 = trans.in0;
        vinf.in1 = trans.in1;
        vinf.in2 = trans.in2;
        vinf.in3 = trans.in3;
        vinf.select = trans.select;
              
      trans.display_in("[ --Driver-- ]");
      num_transactions++;
    end
  endtask
  
endclass
