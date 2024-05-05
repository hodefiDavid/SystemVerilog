package fpu_test_pkg;

  import uvm_pkg::*;

  import fpu_txn_pkg::*;
  import fpu_agent_pkg::*;
  import fpu_analysis_pkg::*;
  import fpu_sequence_pkg::*;

  // scoreboard stuff
  `include "uvm_macros.svh";

  `include "fpu_environment.svh";
  `include "fpu_test_base.svh";
  //tests without error - use fpu_monitor_fpu_tb_bug
  `include "fpu_test_random_sequence.svh";
  `include "fpu_test_sequence_fair.svh";
  `include "fpu_test_neg_sqr_sequence.svh";
  `include "fpu_test_simple_sanity.svh";
  `include "fpu_test_patternset.svh";
/*  // tests with error - use fpu_monitor_fpu_no_tb_bug
  `include "fpu_test_random_sequence_bug.svh";
  `include "fpu_test_sequence_fair_bug.svh";
  `include "fpu_test_neg_sqr_sequence_bug.svh";
  `include "fpu_test_simple_sanity_bug.svh";
  `include "fpu_test_patternset_bug.svh"; 
*/

endpackage // fpu_test_pkg
