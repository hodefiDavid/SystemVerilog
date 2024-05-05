//----------------------------------------------------------------------
// CLASS fpu_agent_config
//----------------------------------------------------------------------
class fpu_agent_config extends uvm_object;
  `uvm_object_utils(fpu_agent_config)
  
  // to contain configuration information for the agent
  // virtual interface for monitor and driver
  virtual fpu_pin_if v_pin_if;
  uvm_sequencer #(fpu_request, fpu_response) seqr;
  
  // is the agent active - ie generate data
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // only used by one sequence, allows interface to have data
  // from an external file.
	string patternset_filename;
  int patternset_maxcount;

  
endclass