class fifo_driver;
  mailbox mlbx;
  virtual fifo_interface vinf;
  int number_of_drive;
  function new(mailbox mlbx, virtual fifo_interface vinf);
    this.mlbx = mlbx;
    this.vinf = vinf;

  endfunction
  task reset;
    wait (vinf.rst);
    wait (!vinf.rst);

  endtask

  task main();
    forever begin
      transaction trans;
      mlbx.get(trans);
      @(posedge vinf.clk) 
      vinf.rd <= trans.rd;
      vinf.wr <= trans.wr;
      vinf.wdata <= trans.wdata;

      number_of_drive++;
      trans.display("driver");
    end  //forever
  endtask  //main

endclass
