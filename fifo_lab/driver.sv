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
    // vinf.<= 0;
    //reset all the interface signals of fifo DUT
    vinf.read_en <= 0;
    vinf.write_en <= 0;
    vinf.data_in  <= 0;
    vinf.data_out <= 0;
    vinf.full     <= 0;
    vinf.empty    <= 1;
    wait(!vinf.rst);
    $display("[ --DRIVER-- ] ----- Reset Ended   -----");
  endtask
  
  //drives the transaction items into interface signals
  task main;
    forever begin
      transaction trans;
      gen2drv.get(trans);
      @(posedge vinf.clk);

      vinf.read_en <= trans.read_en;
      vinf.write_en <= trans.write_en;
      vinf.data_in  <= trans.data_in;

      trans.display_in("[ --Driver-- ]");
      
      // @(posedge vinf.clk);
      num_transactions++;
    end
  endtask
  
endclass
