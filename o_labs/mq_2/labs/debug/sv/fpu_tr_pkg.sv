// $Id: fpu_tr_pkg.sv,v 1.1 2007/03/31 07:49:23 allanc Exp $
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

package fpu_tr_pkg;
  import uvm_pkg::*;
   
  import fpu_sv_pkg::*;

//----------------------------------------------------------------------
// STRUCT REQSTRUCT and STRUCT RSPSTRUCT
//
// class objects cannot be passed back and forth through the
// DPI, however, structs can.  We use class transactions for
// the "real" work on the SystemVerilog side of the
// testbench and we convert to and from structs to pass back
// and forth to SystemC via DPI.
//----------------------------------------------------------------------

  typedef struct	{
		  shortreal  a;
		  shortreal  b;
		  op_t       op;
		  round_t    round;
		  } REQSTRUCT;

  typedef struct {
		  shortreal    a;
		  shortreal    b;
		  op_t         op;
		  round_t      round;
		  shortreal    result;
		  status_vector_t  status;
		  } RSPSTRUCT;

  `include "uvm_macros.svh"

  `include "fpu_request.svh" 
  `include "fpu_response.svh" 
  
endpackage // fpu_tr_pkg
