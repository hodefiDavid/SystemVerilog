package fpu_analysis_pkg;

  import uvm_pkg::*;
  import fpu_txn_pkg::*;

  // scoreboard stuff
  `include "uvm_macros.svh";

  `include "fpu_reference_model.svh";
  `include "fpu_comparator.svh"; 
  `include "fpu_scoreboard.svh";

endpackage // fpu_analysis_pkg
