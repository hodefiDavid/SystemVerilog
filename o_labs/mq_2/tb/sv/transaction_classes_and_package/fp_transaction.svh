//----------------------------------------------------------------------
// CLASS fp_transaction
//----------------------------------------------------------------------
class fp_transaction extends uvm_sequence_item;
  `uvm_object_utils(fp_transaction)

  rand fp_operand a;
  rand fp_operand b;
  rand op_t    op;
  rand round_t round;

  static int s_transaction_count = 0;
  int m_id;

  string scenario;

  constraint fair { solve op before round, a.operand, b.operand;}

  function new (string name = "fp_transaction");
    super.new(name);
    a = new();
    b = new();
    m_id = s_transaction_count++;
  endfunction // new

  function void do_copy (uvm_object rhs);
    fp_transaction temp;
    if (!$cast(temp, rhs))
    begin
      `uvm_error("TYPE MISMATCH", "Type mismatch in do_copy() for fp_transaction")
    end
    super.do_copy(temp);
    this.a.copy(temp.a);
    this.b.copy(temp.b);
    this.op    = temp.op ;
    this.round = temp.round ;
    this.scenario = temp.scenario ;
  endfunction  


  virtual function string convert2string;
    string s;
    s = $sformatf("a=%s, b=%s, op=%s, round=%s", a.convert2string,b.convert2string,op,round);
    return s;
  endfunction // convert2string


  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    fp_transaction temp;
    do_compare =  ($cast(temp, rhs) &&
                   super.do_compare(temp, comparer) &&
                   this.a.compare(temp.a) &&
                   this.b.compare(temp.b) &&
                   this.op    == temp.op &&
                   this.round == temp.round );
  endfunction // bit  


  function  bit IsInfinite(single_float_t f);
      // An infinity has an exponent of 255 (shift left 23 positions) and
      // a zero mantissa. There are two infinities - positive and negative.
    string s;

    if ((f.exponent == 'hff) && ( f.mantissa == {$size(f.mantissa){1'b0}} ) ) 
    begin
      s = $sformatf("IsInfinite say yes %b, %b ", f.exponent, f.mantissa);
      uvm_report_info("IsInfinite",s, UVM_FULL ,`__FILE__,`__LINE__);
      return 1;
    end 
    else 
    begin
      s = $sformatf("IsInfinite say no %b, %b ", f.exponent, f.mantissa);
      uvm_report_info("IsInfinite",s, UVM_FULL ,`__FILE__,`__LINE__);
      return 0;
    end
      
  endfunction // bit


  function  bit IsNan(single_float_t f);
    // A NAN has an exponent of 255 (shifted left 23 positions) and a non-zero mantissa.
    string s;
    if ((f.exponent == 'hff) && (f.mantissa[$size(f.mantissa)-1] = 1) ) 
    begin
      s = $sformatf("IsNan say yes %b  - %b", f.exponent, f.mantissa);
      uvm_report_info("IsNan",s, UVM_FULL ,`__FILE__,`__LINE__);
      return 1;
    end 
    else 
    begin
      s = $sformatf("IsNan say no %b  - %b", f.exponent, f.mantissa);
      uvm_report_info("IsNan",s, UVM_FULL ,`__FILE__,`__LINE__);
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
    
    // In theory comparing two NAN can never work, you cannot even compare a NAN to itself as it will fail
    // If the FPU_TB_BUG compiler directives is defined, comparison of DUT result vs REF-MODEL result will fail if they are NAN
    // This can be considered as a conditionally introduced bug in the testbench
    `ifndef FPU_TB_BUG
       // Don't compare NaNs
      if ( IsNan(f_before) && IsNan(f_after) )
        return 1;
    `endif 
      
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

 protected function bit IsValid;
    string s;

    IsValid = 1;
    // ieee 754 - 7.1

    if ( ( IsInfinite(a.operand) || IsInfinite(b.operand) ) && ( (op = OP_ADD) || (op = OP_SUB) )) 
    begin
      s = $sformatf("Ignoring compare as IsInfinite as %s" ,this.convert2string());
      uvm_report_info("IsValid",s, UVM_FULL ,`__FILE__,`__LINE__); 
      IsValid = 0;
    end
      
    if ( round != ROUND_EVEN ) 
    begin
      s = $sformatf("Ignoring compare as not ROUND_EVEN %s" ,this.convert2string());
      uvm_report_info("IsValid",s, UVM_FULL ,`__FILE__,`__LINE__); 
      IsValid = 0;
    end
    
    s = $sformatf("IsValid : Looks good %s" ,this.convert2string());
    uvm_report_info("IsValid",s, UVM_FULL ,`__FILE__,`__LINE__);       

    return IsValid;
  endfunction // bit

endclass // fpu_transaction

