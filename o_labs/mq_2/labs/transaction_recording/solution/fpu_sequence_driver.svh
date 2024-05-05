class fpu_sequence_driver extends uvm_driver #(fpu_request, fpu_response);
  `uvm_component_utils(fpu_sequence_driver)

  uvm_analysis_port       #(fpu_request) analysis_port;

  virtual fpu_pin_if m_fpu_pins;
  fpu_agent_config m_config;

  // ****Create variables here to hold the handles of the transactions ****. 
  //Create one for each: driver_stream, response_handle, and request_handle. 
  //Remember they are designated as type integer. Example: int driver_stream
  int driver_stream;
  int response_handle;
  int request_handle;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction // new

  function void build_phase(uvm_phase phase);
    //int verbosity_level = UVM_HIGH;
    super.build_phase(phase);

    analysis_port = new("analysis_port",  this);
      
    if (!uvm_config_db #(fpu_agent_config)::get(this,"","AGENT_CONFIG", m_config))
      uvm_report_error("CONFIG_OB", "could not find agent config object in config_db", UVM_HIGH ,`__FILE__,`__LINE__);

    m_fpu_pins = m_config.v_pin_if;
  endfunction // build


  task run_phase(uvm_phase phase);
    fpu_request m_request; 
    fpu_response m_response; 
      
    //****Create variable RSPSTRUCT m_rsp here****
    RSPSTRUCT m_rsp; 

    //****Define the transaction driver stream here****
    driver_stream = $create_transaction_stream("/top/Driver_Stream");
      
    // let it run a clock cycle to initialize itself
    @(posedge m_fpu_pins.clk);
    @(negedge m_fpu_pins.clk);

    forever 
    begin
      seq_item_port.get(m_request);

      uvm_report_info("request", m_request.convert2string(), UVM_HIGH ,`__FILE__,`__LINE__);
      analysis_port.write(m_request);
	    issue_request(m_request);
 
      //****Start the transaction here****//This is done for you.	
      response_handle = $begin_transaction(driver_stream, "Response"); 
           
      wait(m_fpu_pins.ready == 1);

    	 m_response = collect_response(m_request);
      //****Convert class to struct here****
      m_rsp = m_response.to_struct;

      //****Add the 5 attributes here****//The 1st one is done for you.
      $add_attribute(response_handle, m_rsp.a, "A");
      $add_attribute(response_handle, m_rsp.b, "B");
      $add_attribute(response_handle, m_rsp.op, "Operation_Mode");
      $add_attribute(response_handle, m_rsp.round, "Rounding_Mode");
      $add_attribute(response_handle, m_rsp.result, "Result");
       	       	 
      rsp_port.write(m_response);

      //***End transacction response handle****//This is done for you.
      $end_transaction(response_handle);

      //****Add relation (request_handle, response_handle, "Compute")
	    $add_relation(request_handle, response_handle, "Compute" );

      $free_transaction(request_handle);  //Done for you.
      $free_transaction(response_handle); //Done for you.

    end // forever begin
  endtask // run


  task issue_request(input fpu_request request);

    //****Create variable REQSTRUCT m_req here****
    REQSTRUCT m_req; 

    //****Begin transaction with (driver_stream, "Request"); (Do not forget to assign your handle like you did in a previous step!
    request_handle = $begin_transaction(driver_stream, "Request");

    //****Convert m_req class to request.to_struct
    m_req = request.to_struct;

    //****Add 4 attributes here: m_req.a, m_req.b, m_req.op. m_req.round
    $add_attribute(request_handle, m_req.a, "A");
    $add_attribute(request_handle, m_req.b, "B");
    $add_attribute(request_handle, m_req.op, "Operation_Mode");
    $add_attribute(request_handle, m_req.round, "Rounding_Mode");
      
    repeat ($urandom_range(0,17)) @(posedge m_fpu_pins.clk); // random idle time

    m_fpu_pins.opa <= request.a.operand;
    m_fpu_pins.opb <= request.b.operand;
    m_fpu_pins.fpu_op <= request.op;
    m_fpu_pins.rmode <= request.round;
    m_fpu_pins.start <= 1'b1;
    @(posedge m_fpu_pins.clk) m_fpu_pins.start <= 1'b0;
    @(negedge m_fpu_pins.clk);
      
    //****End transaction request_handle here****
    $end_transaction(request_handle);
            
  endtask // issue_request

  
  function fpu_response collect_response(input fpu_request request);
    fpu_response response;
      
    response = new();
    
    response.set_id_info(request);

    response.a.operand = request.a.operand;
    response.b.operand = request.b.operand;
    response.op = op_t'(m_fpu_pins.fpu_op);
    response.round = round_t'(m_fpu_pins.rmode);
    response.result.operand = m_fpu_pins.outp;
    
    // collect up status information
    response.status[STATUS_INEXACT] = m_fpu_pins.ine;
    response.status[STATUS_OVERFLOW] = m_fpu_pins.overflow;
    response.status[STATUS_UNDERFLOW] = m_fpu_pins.underflow;
    response.status[STATUS_DIV_ZERO] = m_fpu_pins.div_zero;
    response.status[STATUS_INFINITY] = m_fpu_pins.inf;
    response.status[STATUS_ZERO] = m_fpu_pins.zero;
    response.status[STATUS_QNAN] = m_fpu_pins.qnan;
    response.status[STATUS_SNAN] = m_fpu_pins.snan;
    
    return response;
  endfunction // collect_response
  
endclass

