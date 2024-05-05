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


class fpu_request extends uvm_sequence_item;
  `uvm_object_utils( fpu_request );

  rand single_float_t a;
  rand single_float_t b;
  rand op_t    op;
  rand round_t round;

  static int s_transaction_count = 0;
  int m_id;

  constraint fair   { solve op before a, b, round;}
			    
  constraint ANaNs  { 
    a.sign inside {'b0, 'b1} ;
		a.exponent == 'hff;
		a.mantissa[$size(a.mantissa)-1] inside {'b0, 'b1}; // msb
		}

  constraint BNaNs  { 
    b.sign inside {'b0, 'b1} ;
		b.exponent == 'hff;
		b.mantissa[$size(b.mantissa)-1] inside {'b0, 'b1}; // msb
		}

  constraint AInfinities  { 
    a.sign inside {'b0, 'b1} ;
		a.exponent == 'hff;
    a.mantissa == 'h7fffff;
		      }

  constraint BInfinities  { 
    b.sign inside {'b0, 'b1} ;
		b.exponent == 'hff;
    b.mantissa == 'h7fffff;
		}

  constraint AZero        { 
    a.sign inside {'b0, 'b1} ;
		a.exponent == 0;
    a.mantissa == 0;
		}
      
  constraint BZero        { 
    b.sign inside {'b0, 'b1} ;
		b.exponent == 0;
    b.mantissa == 0;
		}

  constraint AValid       { 
    a.sign inside {'b0, 'b1} ;
		a.exponent != 'h00;
		a.exponent != 'hff;
    a.mantissa != 'h0;
    a.mantissa != 'h7fffff;
		}
					    
  constraint BValid       { 
    b.sign inside {'b0, 'b1} ;
		b.exponent != 'h00;
		b.exponent != 'hff;
    b.mantissa != 'h0000;
    b.mantissa != 'h7fffff;
		}

  function void non_constraints;
    ANaNs.constraint_mode(0);
    AInfinities.constraint_mode(0);
    AZero.constraint_mode(0);
    AValid.constraint_mode(0);

    BNaNs.constraint_mode(0);
    BInfinities.constraint_mode(0);
    BZero.constraint_mode(0);
    BValid.constraint_mode(0);
  endfunction
				    
  function void post_randomize;
    non_constraints;
  endfunction

  // constructor function
  function new( string name = "" );
    super.new( name );
  endfunction

  function void init_req(single_float_t a = '{default:0},
	      single_float_t b = '{default:0},
	      op_t op = OP_ADD,
	      round_t round = ROUND_ZERO);
    this.a = a;
    this.b = b;
    this.op = op;
    this.round = round;
    non_constraints;
    this.m_id = s_transaction_count++;
  endfunction // void  init_req

  // clone always exists - overwrite do-copy however
/*function ovm_object clone(); // always return the baseclass
      fpu_request tmp = new;
      tmp.copy (this);
      return tmp;
endfunction // clone*/

  function void do_copy (input uvm_object rhs);
    fpu_request temp;
    if (!$cast(temp, rhs))
      begin
        `uvm_error("TYPE MISMATCH", "Type mismatch in do_copy()")
      end
    super.do_copy(temp);
    this.a = temp.a;
    this.b = temp.b;
    this.op = temp.op;
    this.round = temp.round;
  endfunction  


  function string convert2string;
    string s;
    shortreal ra, rb, rr;
      
    ra = $bitstoshortreal(a);
    rb = $bitstoshortreal(b);

    s = $sformatf("FPU Request: a=%e, b=%e, op=%s, round = %s",
             ra,rb,op,round);
    return s;
  endfunction // convert2string
    
  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    fpu_request temp;
    do_compare =  ($cast(temp, rhs) &&
                  super.do_compare(temp, comparer) &&
                  this.a      == temp.a &&
                  this.b    == temp.b &&
                  this.op    == temp.op &&
                  this.round == temp.round );
  endfunction // bit

     // convert from a class to a struct
  virtual function REQSTRUCT to_struct();
    REQSTRUCT ts;
      
    ts.a = $bitstoshortreal(this.a);
    ts.b = $bitstoshortreal(this.b);
    ts.op = this.op;
    ts.round =this.round;
      
    return ts;
  endfunction


  // convert from a struct to a class
  function fpu_request  to_class(REQSTRUCT ts);
    fpu_request req = new;

    req.a = $shortrealtobits(ts.a);
    req.b = $shortrealtobits(ts.b);
    req.op = ts.op;
    req.round = ts.round;
      
    return req;
  endfunction


  function void add2tr (int request_handle = 0);
    REQSTRUCT m_req; 

    m_req = this.to_struct;
    $add_attribute(request_handle, m_req.a, "A");
    $add_attribute(request_handle, m_req.b, "B");
    $add_attribute(request_handle, m_req.op, "Operation");
    $add_attribute(request_handle, m_req.round, "Rounding Mode");
    // id = this.m_id; $add_attribute(request_handle, id, "TR ID");
  endfunction

    
  endclass // fpu_request

