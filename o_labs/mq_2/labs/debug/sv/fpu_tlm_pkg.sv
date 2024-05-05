// $Id: fpu_tlm_pkg.sv,v 1.1 2007/03/31 07:49:15 allanc Exp $
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

package fpu_tlm_pkg;
  import uvm_pkg::*;
  import fpu_sv_pkg::*;
  import fpu_tr_pkg::*;

  `include "uvm_macros.svh"

  `include "fpu_tlm_loopback.svh"
  `include "fpu_master.svh"
  
endpackage // fpu_tlm_pkg
