class fifo_monitor;

  mailbox mlbx;
  virtual fifo_interface vinf;
  transaction trans;
  function new(mailbox mlbx, virtual fifo_interface vinf);
    this.mlbx = mlbx;
    this.vinf = vinf;
  endfunction

  task main();
    forever begin
      trans = new();
      @(posedge vinf.clk)  //sample the inputs
      trans.rd <= vinf.rd;
      trans.wr <= vinf.wr;
      trans.wdata <= vinf.wdata;
      trans.rst <= vinf.rst;
      @(negedge vinf.clk) 
      trans.rdata <= vinf.rdata;
      trans.empty <= vinf.empty;
      trans.full  <= vinf.full;
      mlbx.put(trans);
      //$display("####the monitor put count %d",trans.count);
      trans.display("monitor");
    end  //forever
  endtask

endclass
