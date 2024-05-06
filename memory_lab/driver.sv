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
    
    vinf.addr <= 0;
    vinf.wr_en <= 0;
    vinf.rd_en <= 0;
    vinf.wr_data <= 0;
    vinf.rd_data <= 0;

    wait(!vinf.rst);
    $display("[ --DRIVER-- ] ----- Reset Ended   -----");
  endtask
  
  //drives the transaction items into interface signals
  task main;
    forever begin
      transaction trans;
      gen2drv.get(trans);
      @(posedge vinf.clk);
      vinf.addr <= trans.addr;
      vinf.wr_en <= trans.wr_en;
      vinf.rd_en <= trans.rd_en;
      vinf.wr_data <= trans.wr_data;
      vinf.rd_data <= trans.rd_data;
      trans.display("[ --Driver-- ]");
      @(posedge vinf.clk);
      //
      vinf.enable <= 0;
      //trans.sum     = vinf.sum;
      //@(posedge vinf.clk);
      num_transactions++;
    end
  endtask
  
endclass
