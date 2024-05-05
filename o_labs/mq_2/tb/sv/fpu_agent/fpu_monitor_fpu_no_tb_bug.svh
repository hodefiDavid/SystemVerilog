class fpu_monitor_fpu_no_tb_bug extends fpu_monitor_base;
  `uvm_component_utils(fpu_monitor_fpu_no_tb_bug)
  
  
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction // new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction


  task run_phase(uvm_phase phase);
    monitor_stream = $create_transaction_stream("Monitor_Stream");

    forever @(posedge m_fpu_pins.clk) 
    begin
//      m_req_in_process = new();
     	// With no fpu_tb_bug, response handling will take priority on requeset handling
     	// This is normal operation
     	
     	// note monitor_response and monitor_request are defined in fpu_monitor_base class
     	
      if(m_fpu_pins.ready == 1'b1) 
      begin
        monitor_response();
      end
      if(m_fpu_pins.start == 1'b1) 
      begin
	       request_time = $time+5;
         monitor_request();
      end
    end //  @(posedge m_fpu_pins.clk)
  endtask // run

endclass // fpu_tlm
