
class fpu_test_loop extends uvm_test;
  `uvm_component_utils(fpu_test_loop)
      
fpu_env environment;

function new(string name = "fpu_test_loop", uvm_component parent=null);
  super.new(name, parent);
endfunction // new

function void build_phase(uvm_phase phase);
  super.build_phase(phase);      
  environment = new("environment", this);
endfunction

endclass
