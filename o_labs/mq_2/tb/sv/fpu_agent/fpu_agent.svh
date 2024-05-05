class fpu_agent extends uvm_component;
  `uvm_component_utils( fpu_agent)

  uvm_sequencer #(fpu_request, fpu_response) seqr;
  fpu_sequence_driver           driver;
 
  fpu_monitor_base              monitor; 
  fpu_coverage                  coverage;

  uvm_analysis_port #(fpu_request)  request_analysis_port;
  uvm_analysis_port #(fpu_response) response_analysis_port;
  
  uvm_active_passive_enum is_active;
  
  fpu_agent_config m_config;

  function new(string name = "RTL_Env", uvm_component parent=null);
    super.new(name, parent);
  endfunction // new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(fpu_agent_config)::get(this, "", "AGENT_CONFIG", m_config))
    begin
       uvm_report_error("CONFIG_DB", "error in extracting m_config in fpu_agent", UVM_LOW );      
    end  
    is_active = m_config.is_active;
   
    uvm_report_info(get_type_name(), $sformatf("active set to %s", is_active), UVM_FULL );

    response_analysis_port = new("response_analysis_port",  this);

    monitor = fpu_monitor_base::type_id::create("monitor", this);
    coverage = fpu_coverage::type_id::create("coverage", this);

    if (is_active == UVM_ACTIVE) 
    // only create the driver, sequencer and request analysis port if it is active  
    begin
      seqr = new ("seqr", this);
      // put the sequencer handle into the config agent
      m_config.seqr = seqr;
      request_analysis_port  = new("request_analysis_port",  this);
      driver = fpu_sequence_driver::type_id::create("driver", this);
    end
  endfunction // new


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
      
    monitor.response_ap.connect( coverage.analysis_export );
    monitor.response_ap.connect( response_analysis_port );

    if (is_active == UVM_ACTIVE) 
    begin
      driver.seq_item_port.connect( seqr.seq_item_export );
      driver.analysis_port.connect( request_analysis_port );
    end
  endfunction // void

endclass
