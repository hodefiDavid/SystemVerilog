`define ROUTER_SIZE 8

package env_pkg;
int hammer = 0;

virtual router_if v_router_if;
  
`include "BasePacket.svh"
`include "Packet.svh"
`include "BaseScoreboard.svh"
`include "Scoreboard.svh"
`include "Monitor.svh"
`include "Driver.svh"
`include "Stimulus.svh"
`include "TestEnv.svh"

endpackage : env_pkg

