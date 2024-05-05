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

//----------------------------------------------------------------------
// CLASS response
//----------------------------------------------------------------------
class fpu_response extends uvm_sequence_item;
  `uvm_object_utils( fpu_response );
  
  single_float_t    a; 
  single_float_t    b;
  op_t    op;
  round_t round;
  single_float_t    result;
  status_vector_t   status;

  static int s_transaction_count = 0;
  int m_id;

  // need constructor, initialiser, do_compare and do_copy methods defined
  // constructor function
  function new( string name = "" );
    super.new( name );
  endfunction

  function void init_res(single_float_t  a = '{default:0},
		                single_float_t  b = '{default:0}, 
                              op_t op = OP_ADD, 
		                    round_t round = ROUND_ZERO,
		           single_float_t result  = '{default:0}, 
	           	 status_vector_t status = '0
		           );

    this.a = a; //single_float_t'(a);
    this.b = b;
    this.op = op;
    this.round = round;
    this.result = result;
    this.status = status;
    this.m_id = s_transaction_count++;      
  endfunction // init_res

  // clone always exists - overwrite do-copy however
  /*    function ovm_object clone(); // always return the baseclass
         fpu_response tmp = new;
         tmp.copy (this);
         return tmp;
    endfunction // clone*/

  function void do_copy (input uvm_object rhs);
    fpu_response temp;
    if (!$cast(temp, rhs))
      begin
        `uvm_error("TYPE MISMATCH", "Type mismatch in do_copy()")
      end
    super.do_copy(temp);
    this.a = temp.a;
    this.b = temp.b;
    this.op = temp.op;
    this.round = temp.round;
    this.status = temp.status;      
  endfunction  

  function string convert2string;
    string s;
    shortreal ra, rb, rr;
    bit [31:0] ba, bb, br;
      
    ra = $bitstoshortreal(a);
    rb = $bitstoshortreal(b);
    rr = $bitstoshortreal(result);
    ba = a;
    bb = b;
    br = result;
    //      $sformat(s,"FPU Response: a=%h, %h(%e), b=%h, %h(%e), op=%s, round = %s, result = %h (%e) with status =%b", a,ba,ra, b,bb,rb, op,round, br, rr, status);
    s = $sformatf("FPU Response: a=%e, b=%e, op=%s, round = %s, result = %e with status =%b", ra, rb, op,round, rr, status);
    return s;
  endfunction

  function  bit IsInfinite(single_float_t f);
    // An infinity has an exponent of 255 (shift left 23 positions) and
    // a zero mantissa. There are two infinities - positive and negative.
    string s;

    if ((f.exponent == 'hff) && ( f.mantissa == {$size(f.mantissa){1'b0}} ) ) 
    begin
	    s = $sformatf("IsInfinite say yes %b, %b ", f.exponent, f.mantissa);
	    uvm_report_info("FPU_RES_CHK",s,UVM_HIGH);
      return 1;
    end 
    else 
    begin
	    s = $sformatf("IsInfinite say no %b, %b ", f.exponent, f.mantissa);
	    uvm_report_info("FPU_RES_CHK",s,UVM_HIGH);
	    return 0;
    end
      
  endfunction // IsInfinite


  function  bit IsNan(single_float_t f);
    // A NAN has an exponent of 255 (shifted left 23 positions) and
    // a non-zero mantissa.
    string s;
    if ((f.exponent == 'hff) && (f.mantissa[$size(f.mantissa)-1] = 1) ) 
    begin
	    s = $sformatf("IsNan say yes %b  - %b", f.mantissa[$size(f.mantissa)-1], f.mantissa);
	    uvm_report_info("FPU_RES_CHK",s,UVM_HIGH);
	    return 1;
    end 
    else 
    begin
	    s = $sformatf("IsNan say no %b  - %b", f.mantissa[$size(f.mantissa)-1], f.mantissa);
	    uvm_report_info("FPU_RES_CHK",s,UVM_HIGH);
    	 return 0;
    end
      
  endfunction

  function bit Sign(single_float_t f);
    // The sign bit of a number is the high bit.
    return (f.sign);
  endfunction



  function bit _Sign(shortreal A);
    // The sign bit of a number is the high bit.
    return ($shortrealtobits(A) & 'h80000000);
  endfunction

  function  bit TestCompare2sComplement ( single_float_t f_before, single_float_t f_after, int maxUlps = 10 );
    string s;
    bit [31:0] bv;
      
    int i_before, i_after, DiffInt;

    //$display("\ngot shortreal before=%h, after=%h", f_before, f_after );
      
    i_before = int'(f_before);
    i_after = int'(f_after);

    bv = i_before; //$display("got hex before=%h", bv);
    bv = i_after;  //$display("got hex after=%h",  bv);

    // Make xInt lexicographically ordered as a twos-complement int
    if (i_before < 0) i_before = 'h80000000 - i_before;
    if (i_after  < 0) i_after  = 'h80000000 - i_after;
	 
    DiffInt = (i_before - i_after);
    DiffInt = (DiffInt < 0) ? -DiffInt : DiffInt;      
    //$display("diff hex is %h",DiffInt);

    if (DiffInt <= maxUlps) 
      return 1;
    else
      return 0;
      
  endfunction // bit

  local function bit IsValid;
    string s;

    IsValid = 1;
    // ieee 754 - 7.1
    if ( IsNan(a) || IsNan(b) ) 
    begin
	    s = $sformatf("Ignoring compare due to NaN as %s" ,this.convert2string());
	    uvm_report_info("FPU_RES_CHK",s,UVM_HIGH);
    	 IsValid = 0;
    end
      
    if ( ( IsInfinite(a) || IsInfinite(b) ) && ( (op = OP_ADD) || (op = OP_SUB) )) 
    begin
	    s = $sformatf("Ignoring compare as IsInfinite as %s" ,this.convert2string());
	    uvm_report_info("FPU_RES_CHK",s,UVM_HIGH);
	    IsValid = 0;
    end
      
    if ( round != ROUND_EVEN ) 
    begin
	    s = $sformatf("Ignoring compare as not ROUND_EVEN %s" ,this.convert2string());
	    uvm_report_info("FPU_RES_CHK",s,UVM_HIGH);
	    IsValid = 0;
    end

    s = $sformatf("IsValid : Looks good %s" ,this.convert2string());
	  uvm_report_info("FPU_RES_CHK",s,UVM_HIGH);

    return IsValid;
  endfunction // bit

  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    fpu_response temp;
    bit status;
    string s;
    shortreal result_before, result_after;
    do_compare =  ($cast(temp, rhs) &&
                  super.do_compare(temp, comparer) &&
                  this.op    == temp.op &&
                  this.round == temp.round &&
                  IsValid  &&
                  TestCompare2sComplement( this.result, temp.result ));
 
  endfunction // bit

  // convert from a class to a struct
  virtual function RSPSTRUCT to_struct();
    RSPSTRUCT ts;

    ts.a = $bitstoshortreal(this.a);
    ts.b = $bitstoshortreal(this.b);
    ts.op = this.op;
    ts.round = this.round;
    ts.result = this.result;
    ts.status = this.status;

    return ts;
  endfunction // to_struct


  // convert from a struct to a class
  static function fpu_response to_class(RSPSTRUCT ts);
    fpu_response req = new;

//    req.a = $shortrealtobits(ts.a);
//    req.b = $shortrealtobits(ts.b);
    req.a = bit'(ts.a);
    req.b = bit'(ts.b);
    req.op = ts.op;
    req.round = ts.round;
//    req.result = $shortrealtobits(ts.result);
    req.result = bit'(ts.result);
    req.status = ts.status;
     
    return req;
  endfunction // to_class


  function void add2tr (int response_handle = 0);
    RSPSTRUCT m_rsp;
    m_rsp = this.to_struct;
    $add_attribute(response_handle, m_rsp.a, "A");
    $add_attribute(response_handle, m_rsp.b, "B");
    $add_attribute(response_handle, m_rsp.op, "Operation");
    $add_attribute(response_handle, m_rsp.round, "Rounding Mode");
    $add_attribute(response_handle, m_rsp.result, "Result");
    // id = this.m_id; $add_attribute(response_handle, id, "TR ID");      
  endfunction

endclass

