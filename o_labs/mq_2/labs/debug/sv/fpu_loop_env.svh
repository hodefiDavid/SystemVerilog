// $Id: fpu_tlm_env.sv,v 1.1 2007/03/31 07:49:07 allanc Exp $
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

 class fpu_env extends uvm_env;
  `uvm_component_utils(fpu_env)
   
    // compoments
    fpu_master #(fpu_request, fpu_response) f_master;
    uvm_tlm_req_rsp_channel #(.REQ(fpu_request), .RSP(fpu_response)) channel;
    fpu_tlm_loopback fpu_tlm_loop; 
    
    
    int nCount = 20;

    function new(string name = "TLM_loop_Env", uvm_component parent=null);
      super.new(name, parent);
    endfunction // new
  
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);      
      // components and channels
      f_master = new("f_master",this);
      channel = new("channel",this);
      fpu_tlm_loop = new("fpu_tlm_loop",this);
   
    endfunction

    
    function void connect_phase(uvm_phase phase);
      uvm_report_info("PHASING","fpu_env.connect()", UVM_HIGH);
      
      f_master.master_port.connect(channel.master_export);
      fpu_tlm_loop.slave_port.connect(channel.slave_export);
    endfunction // void

    
    task run_phase(uvm_phase phase);
      phase.raise_objection(this, "Start of Stimulus");
      f_master.generate_stimulus(,nCount);
      phase.drop_objection(this, "Stimulus Complete");
    endtask

  endclass // fpu_env

