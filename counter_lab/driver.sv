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
    wait(!vinf.rst_n);
    $display("[ --DRIVER-- ] ----- Reset Started -----");

    vinf.enable <= 1;
    vinf.load <= 0;
    vinf.data_in <= 0;
    vinf.count <= 0;
    wait(vinf.rst_n); 
    $display("[ --DRIVER-- ] ----- Reset Ended   -----");
  endtask
  
  //drives the transaction items into interface signals
  task main;
    forever begin
      transaction trans;
      gen2drv.get(trans);
      @(posedge vinf.clk);
      // vinf.enable <= trans.enable;
      vinf.load      <= trans.load;
      vinf.data_in      <= trans.data_in;
      @(posedge vinf.clk);
      trans.count     = vinf.count;
      @(posedge vinf.clk);
      trans.display("[ --Driver-- ]");
      num_transactions++;
    end
  endtask
  
endclass
