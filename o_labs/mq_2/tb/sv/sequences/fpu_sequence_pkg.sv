package fpu_sequence_pkg;

  import uvm_pkg::*;

  import fpu_txn_pkg::*;
  import fpu_agent_pkg::*;

  // scoreboard stuff
  `include "uvm_macros.svh";

  `include "fpu_sequence_setup.svh";
  `include "fpu_sequence_fair.svh";
  `include "fpu_sequence_random.svh";
  `include "fpu_sequence_neg_sqr.svh";
  `include "fpu_sequence_simple_sanity.svh";
  `include "fpu_sequence_patternset.svh";

endpackage // fpu_sequence_pkg
