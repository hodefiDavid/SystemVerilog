`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
class environment;
  
  //generator and driver instance
  generator 	gen;
  driver    	drv;
  
  //mailbox handles
  mailbox gen2drv;
  
  //virtual interface
  virtual inf vinf;
  
  //constructor
  function new(virtual inf vinf);
    //get the interface from test
    this.vinf = vinf;

    //creating the mailbox (Same handle will be shared across generator and driver)
    gen2drv = new();
     
    //create generator and driver
    gen = new(gen2drv);
    drv = new(vinf,gen2drv);
  endfunction
  
  //test activity
  task pre_test();
    drv.reset();
  endtask
  
  task test();
    fork 
      gen.main();
      drv.main();
    join_any
  endtask
  
  task post_test();
    wait(gen.ended.triggered);
    wait(gen.repeat_count == drv.num_transactions); 
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
  
endclass