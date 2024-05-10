`include "transaction.sv"
`include "fifo_driver.sv"
`include "fifo_generator.sv"
`include "fifo_monitor.sv"
`include "fifo_scoreboard.sv"

class fifo_env;
  virtual fifo_interface vinf;
  mailbox gen2drive;
  mailbox mon2scbd;
  fifo_driver driver;
  fifo_generator generator;
  fifo_monitor monitor;
  fifo_scoreboard scoreboard;
  function new(virtual fifo_interface vinf);
    gen2drive = new();
    mon2scbd = new();
    this.vinf = vinf;
    generator = new(gen2drive);
    driver = new(gen2drive, vinf);
    monitor = new(mon2scbd, vinf);
    scoreboard = new(mon2scbd);
  endfunction
  task pre_test();
    driver.reset();
  endtask
  task test();
    fork
      driver.main();
      generator.main();
      monitor.main();
      scoreboard.main();
    join_any
  endtask

  task post_test();
    wait (generator.generator_done.triggered);
    wait (generator.num_of_generate == driver.number_of_drive);
    wait (scoreboard.num_of_check == driver.number_of_drive);
    //$display("scoreboard.num_of_pass= %d generator.num_of_generate=%d",scoreboard.num_of_pass,generator.num_of_generate);
    if (scoreboard.num_of_pass == generator.num_of_generate) begin
      $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
      $display("~~~~~~~~~~~~~~~~~~~~~~ALL TEST PASSED~~~~~~~~~~~~~~~~~~~~~~");
      $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    end  //if
  endtask

  task run();
    pre_test();
    test();
    post_test();
  endtask
endclass
