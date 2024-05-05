//----------------------------------------------------------------------
// CLASS response
//----------------------------------------------------------------------
class fpu_response extends fp_transaction;
  `uvm_object_utils(fpu_response)
  fp_operand        result;
  status_vector_t   status;


  function new ( string name = "fpu_response" );
    super.new(name);
    result = new();
  endfunction // new



  function void do_copy(uvm_object rhs);
    fpu_response temp;
    if (!$cast(temp, rhs))
    begin
      `uvm_error("TYPE MISMATCH", "Type mismatch in do_copy() for fpu_request")
    end
    super.do_copy(temp);
    this.result = temp.result;
    this.status = temp.status;      
  endfunction


  function string convert2string;
    string s;
    $sformat(s,"a=%s, b=%s, op=%s, round=%s, result = %e with status =%b", a.convert2string,b.convert2string,op,round,result.convert2string, status);
    return s;
  endfunction
    

  local function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    fpu_response temp;
    do_compare =  ($cast(temp, rhs) &&
                   this.op    == temp.op &&
                   this.round == temp.round &&
                    (
                     (super.IsValid &&
                      TestCompare2sComplement( this.result.operand, temp.result.operand )
                      ) ||
                    !super.IsValid
                    )
                   );
  endfunction // bit


  // convert from a class to a struct
  function RSPSTRUCT to_struct();
    RSPSTRUCT ts;
    
    ts.a = $bitstoshortreal(this.a.operand);
    ts.b = $bitstoshortreal(this.b.operand);
    ts.op = this.op;
    ts.round = this.round;
    ts.result = $bitstoshortreal(this.result.operand);
    ts.status = this.status;
      
    return ts;
  endfunction // to_struct


  // convert from a struct to a class
  static function fpu_response to_class(RSPSTRUCT ts);
    fpu_response req = new();
      
    req.a.operand = $shortrealtobits(ts.a);
    req.b.operand = $shortrealtobits(ts.b);
    req.op = ts.op;
    req.round = ts.round;
    req.result.operand = $shortrealtobits(ts.result);
    req.status = ts.status;
      
    return req;
  endfunction // to_class


  function void add2tr (int handle = 0);
    op_t       wop = op;
    round_t    wround = round;
    $add_attribute(handle, $bitstoshortreal(a.operand), "A");
    $add_attribute(handle, $bitstoshortreal(b.operand), "B");
    $add_attribute(handle, wop, "Operation");
    $add_attribute(handle, wround, "RoundingMode");
    $add_attribute(handle, $bitstoshortreal(result.operand), "Result");
  endfunction

endclass // fpu_response

