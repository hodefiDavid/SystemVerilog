`ifndef TestEnv
`define TestEnv

//****************
class TestEnv;

 // create handles
 mailbox #(Packet) s2d_mb[];
 mailbox #(Packet) log_mon, log_stim;

 // dynamic array of handles
 Driver		d[];
 Monitor	m[];
 
 // Scoreboard & Stimulus Generator objects
 Scoreboard     sb;
 Stimulus	s;
 
 function new();

   
   // create packet logging mailboxes to feed Scoreboard
   log_mon  = new();
   log_stim = new();
   
   // create scoreboard & configure feeding mailbox handles
   sb = new(.stim_mb(log_stim), .mon_mb(log_mon) );
   
   // size the dynamic arrays of monitor, driver and stimulus objects
   d      = new[`ROUTER_SIZE];
   m      = new[`ROUTER_SIZE];
   s2d_mb = new[`ROUTER_SIZE];
   
   // Populate dynamic arrays & configure internal handles
   for ( int id = 0; id < `ROUTER_SIZE; id++)
     begin
       s2d_mb[id] = new(1);
       d[id] = new(.id(id), .mb(s2d_mb[id]));
       m[id] = new(.id(id), .log_mb(log_mon));
     end  

   // build the stimulus generator and configure  mailbox handles 
   s = new( .driv_num(`ROUTER_SIZE) );
   s.connect(.log_mb(log_stim), .driv_mb(s2d_mb));
     
 endfunction

 
 task  run();
   // start everything
   for ( int id = 0; id < `ROUTER_SIZE; id++) begin
     fork
       m[id].run;
       d[id].run;
     join_none
     #1;
   end
   
   fork
       s.run;
       sb.run;
   join_none
   #1;
 endtask

endclass : TestEnv

`endif//*****************************  
