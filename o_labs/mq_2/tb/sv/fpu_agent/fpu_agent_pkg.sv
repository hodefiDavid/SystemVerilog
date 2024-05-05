package fpu_agent_pkg;

  import uvm_pkg::*;
  import fpu_txn_pkg::*;

  `include "uvm_macros.svh";
  `include "fpu_agent_config.svh";
  `include "fpu_sequence_driver.svh";
  `include "fpu_monitor_base.svh";
  `include "fpu_monitor_fpu_tb_bug.svh";
  `include "fpu_monitor_fpu_no_tb_bug.svh";
  `include "fpu_coverage.svh";
  `include "fpu_agent.svh";

endpackage // fpu_agent_pkg

