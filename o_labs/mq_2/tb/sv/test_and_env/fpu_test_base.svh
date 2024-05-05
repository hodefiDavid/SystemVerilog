import mti_fli::*;

class fpu_test_base extends uvm_test;
  `uvm_component_utils(fpu_test_base)

  int m_logfile_handle;
   
  fpu_agent_config m_config;    

  
  fpu_environment environment;

  // Handle to sequencer down in the test environment
  uvm_sequencer #(fpu_request, fpu_response) m_seqr;
 

  function new(string name = "fpu_test_base", uvm_component parent=null);
    super.new(name, parent);
  endfunction // new

  function void build_phase(uvm_phase phase);
    string result;
   
    // set up report defaults before calling super.build_phase
    // define default log file
    m_logfile_handle = $fopen( $sformatf("%s.log", get_type_name() ), "w");
    // do this level onlyl, as lower levels haven't yet been built
    set_report_default_file(m_logfile_handle);

    // log to display (std out) and file for this and all children
    set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_LOG);
    set_report_severity_action(UVM_WARNING, UVM_DISPLAY | UVM_LOG);
    set_report_severity_action(UVM_ERROR,   UVM_DISPLAY | UVM_LOG | UVM_COUNT );
    set_report_severity_action(UVM_FATAL,   UVM_DISPLAY | UVM_LOG | UVM_EXIT );

    super.build_phase(phase);
    
    // now create and populate agent config object before building environment
    m_config = fpu_agent_config::type_id::create("m_config", this);
    if (!uvm_config_db #(virtual fpu_pin_if)::get(this,"", "VIRTUAL_INTERFACE", m_config.v_pin_if))
       `uvm_error("CONFIG_DB", "No virtual interface in config database")
    m_config.is_active = UVM_ACTIVE;
    // put the agent config object into the config db
    uvm_config_db #(fpu_agent_config)::set(this,"*","AGENT_CONFIG", m_config);
    
    environment = fpu_environment::type_id::create("environment", this);

    uvm_report_info( get_type_name(), $sformatf("Master random number generator seeded with: %0d", get_seed()), UVM_LOW,`__FILE__,`__LINE__ );
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    // now all environment built, so set the report defaults for all levels
    set_report_default_file_hier(m_logfile_handle);

    // log to display (std out) and file for this and all children
    set_report_severity_action_hier(UVM_INFO, UVM_DISPLAY | UVM_LOG);
    set_report_severity_action_hier(UVM_WARNING, UVM_DISPLAY | UVM_LOG);
    set_report_severity_action_hier(UVM_ERROR,   UVM_DISPLAY | UVM_LOG | UVM_COUNT );
    set_report_severity_action_hier(UVM_FATAL,   UVM_DISPLAY | UVM_LOG | UVM_EXIT );

    uvm_top.print_topology();
    // pull the sequencer handle from the configeration agent
    m_seqr = m_config.seqr;
  endfunction // end_of_elaboration


  virtual task main_phase(uvm_phase phase);
    // do NOT call super.main_phase in derived classes
    uvm_report_info(get_type_name(), "run_phase not overridden in test, no sequene tun", UVM_LOW );     
  endtask

  function string send2vsim(string cmd = "" );
    string result;
    chandle interp;

    interp = mti_Interp();
    uvm_report_info( get_type_name(), $sformatf( "Sending \"%s\" to Questa", cmd), UVM_FULL ); 
    assert (! mti_Cmd(cmd));
    result = Tcl_GetStringResult(interp);
    Tcl_ResetResult(interp);
    uvm_report_info( get_type_name(), $sformatf( "Received \"%s\" from Questa", result), UVM_FULL );       
    return result;
  endfunction

  function int get_seed();
    string result;
    result = send2vsim("lindex $Sv_Seed 0");
    return result.atoi();
  endfunction

  function int get_teststatus();
    string cmd = "lindex [coverage attr -name TESTSTATUS -concise] 0";
    string result, msg;

    result = send2vsim(cmd);
    // OK = "0", Warning = "1", Error = "2", or Fatal ="3"
    msg = $sformatf("vsim reported %0d as the teststatus", result);
    uvm_report_info( get_type_name(), msg, UVM_FULL ); 
    return result.atoi();
  endfunction
      
  function void report_phase(uvm_phase phase);     // report
    string cmd,msg, result;
    uvm_report_server rs; 
      
    int fatal_count;
    int error_count;
    int warning_count;
    int message_count;

    int teststatus;
      
    rs = get_report_server();

    fatal_count = rs.get_severity_count(UVM_FATAL);
    error_count = rs.get_severity_count(UVM_ERROR);
    warning_count = rs.get_severity_count(UVM_WARNING);
    message_count = rs.get_severity_count(UVM_INFO);

    teststatus = get_teststatus();
      
    super.report_phase(phase);
      
    if ( (warning_count==0) && (error_count==0) && (fatal_count==0) && ( teststatus==0 || teststatus==1) )  
    begin
      if (teststatus == 0) 
        uvm_report_info( get_type_name(),$sformatf("Test Results: Passed with no errors"), UVM_LOW);
      else
        uvm_report_info( get_type_name(),$sformatf("Test Results: Passed with no errors but with DUT warning(s)"), UVM_LOW);
    end
    else 
    begin
      msg = $sformatf("Test Results: Failed with %0d error(s)", error_count);
      uvm_report_error( get_type_name(), msg, UVM_LOW,`__FILE__,`__LINE__);
      $error(""); // signal to vsim
    end
  endfunction // void

endclass
