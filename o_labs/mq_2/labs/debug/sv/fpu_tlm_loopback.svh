// $Id: fpu_tlm_dpi_c.sv,v 1.1 2007/03/31 07:49:03 allanc Exp $
//----------------------------------------------------------------------
//   Copyright 2005-2006 Mentor Graphics Corporation
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

class fpu_tlm_loopback extends uvm_component;
  `uvm_component_utils( fpu_tlm_loopback );

  fpu_request m_request; 
  fpu_response m_response; 

  uvm_slave_port #(.REQ(fpu_request),.RSP(fpu_response)) slave_port;
  

  function new(string name = "", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    slave_port = new("slave_port", this);
  endfunction // 
  
  function void export_connections;
  endfunction // void
  
  task run_phase(uvm_phase phase);
    string s;
    
    forever begin
    //ovm_report_message("tlm","Getting Request",1000);
      slave_port.get(m_request);
      s = $sformatf("TLM request: %s",m_request.convert2string()); 
      uvm_report_info("tlm",s, UVM_HIGH); 
      uvm_report_warning("tlm","Sending request -> request"); 
      m_response = new("m_response");
      m_response.init_res(m_request.a, m_request.b, m_request.op, m_request.round);

      s = $sformatf("TLM response: %s",m_response.convert2string()); 
      uvm_report_info("tlm",s, UVM_HIGH); 
      slave_port.put(m_response);
    end
  endtask // run

endclass // fpu_tlm_loopback
