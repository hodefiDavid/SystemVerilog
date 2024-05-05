// $Id: fpu_sv_pkg.sv,v 1.1 2007/03/31 07:48:51 allanc Exp $
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

package fpu_sv_pkg;
  timeunit 1ns;
  timeprecision 1ns;
  
  import uvm_pkg::*;
  
  parameter int FP_WIDTH = 32;
  parameter int FRAC_WIDTH = 23;

  typedef   enum {OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_SQR} op_t;
  string op_string[op_t] = '{OP_ADD:"add", 
                             OP_SUB:"sub", 
                             OP_MUL:"mul", 
                             OP_DIV:"div", 
                             OP_SQR:"sqr"};

  typedef   enum  {ROUND_EVEN, 
                   ROUND_ZERO, 
                   ROUND_UP, 
                   ROUND_DOWN
                   } round_t;
  
  string round_string[round_t] = '{ROUND_EVEN:"even", 
                                   ROUND_ZERO:"zero", 
                                   ROUND_UP:"up", 
                                   ROUND_DOWN:"down"};
  
// Enumeration of status bits.
  typedef   enum {STATUS_INEXACT,
                  STATUS_OVERFLOW,
                  STATUS_UNDERFLOW,
                  STATUS_DIV_ZERO,
                  STATUS_INFINITY,
                  STATUS_ZERO,
                  STATUS_QNAN,
                  STATUS_SNAN,
		              STATUS_SIZE
                } status_t;

  typedef bit [STATUS_SIZE-1:0] status_vector_t;


  string status_string[status_t] = '{
                                     STATUS_INEXACT:"inexact",
                                     STATUS_OVERFLOW:"overflow",
                                     STATUS_UNDERFLOW:"underflow",
                                     STATUS_DIV_ZERO:"divide by zero",
                                     STATUS_INFINITY:"infinity",
                                     STATUS_ZERO:"zero",
                                     STATUS_QNAN:"quiet NAN",
                                     STATUS_SNAN:"signaling NAN"
                                     };

  typedef struct packed  {
			  bit    sign;
			  bit [7:0] exponent;
			  bit [22:0] mantissa;
			  } single_float_t;

endpackage // fpu_sv_pkg
