class fpu_monitor_base extends uvm_component;
  `uvm_component_utils(fpu_monitor_base)
   
  fpu_request m_req_in_process; 
                                
  virtual fpu_pin_if m_fpu_pins;
  fpu_agent_config m_config;
  
  uvm_analysis_port #(fpu_request)  request_ap;
  uvm_analysis_port #(fpu_response) response_ap;
  
  protected int monitor_stream, request_handle, response_handle;
  protected time request_time;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction // new


  function void build_phase(uvm_phase phase);
    request_ap = new("request_ap",this);
    response_ap = new("response_ap",this);
    
    if (!uvm_config_db #(fpu_agent_config)::get(this,"","AGENT_CONFIG", m_config))
      uvm_report_error("CONFIG_OB", "could not find agent config object in config_db", UVM_HIGH ,`__FILE__,`__LINE__);
    m_fpu_pins = m_config.v_pin_if;
  endfunction

  task monitor_request();
    fpu_request req;
    string s;
    int i;
    
    req = new();

    if(m_fpu_pins.start != 1'b1) 
    begin
	    s = $sformatf("monitor_request called incorrectly: start=%b", m_fpu_pins.start);
	    uvm_report_error("monitor", s, UVM_LOW ,`__FILE__,`__LINE__);
	    return;
    end

    request_handle = $begin_transaction(monitor_stream, "Request");
    req.a.operand = m_fpu_pins.opa;
    req.b.operand = m_fpu_pins.opb;
    req.op = op_t'(m_fpu_pins.fpu_op);
    req.round = round_t'(m_fpu_pins.rmode);
      
    void'($cast(m_req_in_process, req.clone)); // cast the base class returned and copied to our type.
    // don't use for write, but will be needed for the response monitoring
    uvm_report_info("request", req.convert2string(), UVM_MEDIUM ,`__FILE__,`__LINE__);
    request_ap.write(req);
    #5;
      
    req.add2tr(request_handle);
      
    // note this transaction happent in zero time.
    $end_transaction(request_handle);

  endtask // monitor_request



  
  task monitor_response();
    fpu_response rsp;

    string s;
    
    if(m_fpu_pins.ready != 1'b1) begin
	    s = $sformatf("monitor_response called incorrectly: ready=%b", m_fpu_pins.ready);
	    uvm_report_error("monitor",s,UVM_LOW ,`__FILE__,`__LINE__);
      return;
    end
    
    rsp = new();
    response_handle = $begin_transaction(monitor_stream, "Response", request_time+5);

    rsp.a.operand = m_req_in_process.a.operand;
    rsp.b.operand = m_req_in_process.b.operand;
    rsp.op = m_req_in_process.op;
    rsp.round = m_req_in_process.round;
    rsp.result.operand = m_fpu_pins.outp;
    
    // collect up status information
    rsp.status[STATUS_INEXACT] = m_fpu_pins.ine;
    rsp.status[STATUS_OVERFLOW] = m_fpu_pins.overflow;
    rsp.status[STATUS_UNDERFLOW] = m_fpu_pins.underflow;
    rsp.status[STATUS_DIV_ZERO] = m_fpu_pins.div_zero;
    rsp.status[STATUS_INFINITY] = m_fpu_pins.inf;
    rsp.status[STATUS_ZERO] = m_fpu_pins.zero;
    rsp.status[STATUS_QNAN] = m_fpu_pins.qnan;
    rsp.status[STATUS_SNAN] = m_fpu_pins.snan;

    rsp.add2tr(response_handle);
    $end_transaction(response_handle);
    $add_relation(request_handle, response_handle, "Compute" );

    response_ap.write(rsp);

    uvm_report_info("response", rsp.convert2string(), UVM_MEDIUM ,`__FILE__,`__LINE__);
  endtask // monitor_response

endclass // fpu_tlm
