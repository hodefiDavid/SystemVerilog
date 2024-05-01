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
    vinf.a <= 0;
    vinf.b <= 0;
    vinf.enable <= 0;
    wait(!vinf.rst);
    $display("[ --DRIVER-- ] ----- Reset Ended   -----");
  endtask
  
  //drives the transaction items into interface signals
  task main;
    forever begin
      transaction trans;
      gen2drv.get(trans);
      @(posedge vinf.clk);
      vinf.enable <= 1;
      vinf.a      <= trans.a;
      vinf.b      <= trans.b;
      @(posedge vinf.clk);
      vinf.enable <= 0;
      trans.sum     = vinf.sum;
      @(posedge vinf.clk);
      trans.display("[ --Driver-- ]");
      num_transactions++;
    end
  endtask
  
endclass
