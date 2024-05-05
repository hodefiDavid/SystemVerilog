
//----------------------------------------------------------------------
// CLASS fpu_request
//----------------------------------------------------------------------
class fpu_request extends fp_transaction;
  `uvm_object_utils(fpu_request)
  
  function new ( string name = "fpu_request" );
      super.new(name);
  endfunction // new


  function void do_copy(uvm_object rhs);
    fpu_request temp;
    if (!$cast(temp, rhs))
    begin
      `uvm_error("TYPE MISMATCH", "Type mismatch in do_copy() for fpu_request")
    end
    super.do_copy(temp);
  endfunction


  virtual function REQSTRUCT to_struct();
    REQSTRUCT ts;
      
    ts.a = $bitstoshortreal(this.a.operand);
    ts.b = $bitstoshortreal(this.b.operand);
    ts.op = this.op;
    ts.round =this.round;
      
    return ts;
  endfunction

  virtual function fp_transaction to_class(REQSTRUCT ts);
    fp_transaction req = new();

    req.a.operand = $shortrealtobits(ts.a);
    req.b.operand = $shortrealtobits(ts.b);
    req.op = ts.op;
    req.round = ts.round;
      
    return req;
  endfunction


  function void add2tr (int handle = 0);

    op_t       wop = op;
    round_t    wround = round;
    $add_attribute(handle, $bitstoshortreal(a.operand), "A");
    $add_attribute(handle, $bitstoshortreal(b.operand), "B");
    $add_attribute(handle, wop, "Operation");
    $add_attribute(handle, wround, "RoundingMode");
  endfunction
  
endclass // fpu_request
