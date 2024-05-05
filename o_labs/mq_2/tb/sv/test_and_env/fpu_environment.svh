class fpu_environment extends uvm_env; // rename to base
  `uvm_component_utils(fpu_environment)

  fpu_agent                     agent;
  fpu_scoreboard                scoreboard;


  function new(string name = "", uvm_component parent=null);
    super.new(name, parent);
  endfunction // new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = fpu_agent::type_id::create("agent", this);
    scoreboard = fpu_scoreboard::type_id::create("scoreboard", this);
  endfunction // new


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.request_analysis_port.connect(scoreboard.request_analysis_export);
    agent.response_analysis_port.connect(scoreboard.response_analysis_export);
  endfunction // void

endclass
