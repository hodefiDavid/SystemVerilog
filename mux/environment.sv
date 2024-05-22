`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class environment;
  
  //generator and driver instance
  generator 	gen;
  driver    	drv;
  monitor   	mon;
  scoreboard	scb;
  
  //mailbox handle's
  mailbox gen2drv;
  mailbox mon_in2scb;
  mailbox mon_out2scb
  //virtual interface
  virtual inf vinf;
  
  //constructor
  function new(virtual inf vinf);
    //get the interface from test
    this.vinf = vinf;
    
    //creating the mailbox (Same handle will be shared 
    //across generator and driver)
    gen2drv = new();
    mon_in2scb = new();
    mon_out2scb = new();
    //creating generator and driver
    gen = new(gen2drv);
    drv = new(vinf,gen2drv);
    mon = new(vinf,mon_in2scb,mon_out2scb);
    scb = new(mon_in2scb,mon_out2scb);

  endfunction
  
  //test activity
  task pre_test();
    drv.reset();
  endtask
  
  task test();
    fork 
      gen.main();
      drv.main();
      mon.main();
      scb.main();
    join_any
  endtask
  
  task post_test();
    wait(gen.ended.triggered);
    wait(gen.repeat_count == drv.num_transactions); //Optional
    wait(gen.repeat_count == scb.num_transactions);
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
  
endclass
