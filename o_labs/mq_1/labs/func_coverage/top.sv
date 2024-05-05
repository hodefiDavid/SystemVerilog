//  `define TRACE_ON  0
//  `define DEBUG_ON  0

module top;
  import env_pkg::*;
  parameter simulation_cycle = 100 ;
  logic  SystemClock ;
  
  task reset();
    top_if.rst <= 1;
    top_if.valid <= 0;
    top_if.stream <= 0;
    repeat(2) @(posedge top_if.clock); 
    top_if.rst <= 0;
    repeat(15) @(posedge top_if.clock);
  endtask

  
  router_if top_if(SystemClock);
  router dut(
    .rst ( top_if.rst ),
    .clk ( top_if.clock ),
    .valid ( top_if.valid ),
    .stream ( top_if.stream ),
    .streamo ( top_if.streamo ),
    .busy ( top_if.busy ),
    .valido ( top_if.valido )
  );
  
  TestEnv t_env;

  initial begin
    SystemClock = 0 ;
    forever begin
      #(simulation_cycle/2) 
        SystemClock = ~SystemClock ;
    end
  end
  
  initial begin
    env_pkg::v_router_if = top_if;  // Package prefix unnecessary here because Package is imported above
    reset();
    t_env = new();  // create test environment
    hammer = 0;
    t_env.run();      // start things running
    // this lab constrains the router destination to the variable hammer
    // hammer is initially set to 0, so initially only destination hammer 0
    // is created.  When 100% coverage has been seen for destination 0, 
    // the value of hammer is incremented so the next destination is used
    // as the constraint.  This repeats until all destinations are complete
    do 
      	begin
    	  wait(Scoreboard::cov_met[hammer]); 
	  $display("\n*************************   H%0d finished\n",hammer);
    	  hammer++;			
    	end
    while (hammer < 8);
    
    $stop;
  end

endmodule  


