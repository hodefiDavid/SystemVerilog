// $Id: fpu_master.sv,v 1.1 2007/03/31 07:48:23 allanc Exp $
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

class fpu_master #(type fpu_request_type=uvm_sequence_item, 
                   type fpu_response_type=uvm_sequence_item)
                   extends uvm_component;
  `uvm_component_param_utils(fpu_master #( fpu_request_type, fpu_response_type))


  fpu_response_type m_response;

  uvm_master_port #( .REQ(fpu_request_type), .RSP(fpu_response_type) ) master_port;

  function new( string name = "", uvm_component parent);
    super.new( name , parent );
  endfunction // new

  function void build_phase(uvm_phase phase);
    string s;
    super.build_phase(phase);
    master_port = new("master_port", this);
    
    s = $sformatf("rand state is %d" , get_randstate() );
    uvm_report_info("uvm_stimulus" , s );  
  endfunction

  virtual task generate_stimulus( fpu_request_type  t = null,input int max_count = 1 );
    random_stimulus(t, max_count);
  endtask // generate_stimulus


  virtual task random_stimulus( fpu_request_type m_request = null,input int max_count = 1 );
    string s;
    
    fpu_response_type m_response;
    
    //if( m_request == null ) // m_request = new();
    for( int i = 0;  ( i < max_count) ;  i++ ) 
    begin
	    m_request = new();
	    m_request.init_req();   // using default arguments
	    // generate the A operand value as IEEE floating-point bit vector
	    m_request.AValid.constraint_mode(1);
      
	    // generate the B operand value as IEEE floating-point bit vector
 	    m_request.BValid.constraint_mode(1);
      
	    // randomize request operands..
	    if ( !m_request.randomize() )
        uvm_report_error("uvm_stimulus_error" , "request randomize failed" );  
      else
       do_req_rsp(m_request, m_response);
    end
endtask

virtual task do_req_rsp (input fpu_request_type request, output fpu_response_type response);
      string s;

      s = $sformatf("master request: %s",request.convert2string());
      uvm_report_info("Master", s,UVM_HIGH);

      master_port.put(request);
      
      master_port.get(response);

      s = $sformatf("master response: %s",response.convert2string());
      uvm_report_info("Master", s,UVM_HIGH);
      //return rsp;
endtask

endclass // fpu_master
