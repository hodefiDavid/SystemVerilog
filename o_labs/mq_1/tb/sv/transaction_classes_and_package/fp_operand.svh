//----------------------------------------------------------------------
// CLASS fp_operand
// 08.08.2011 Removed local qualifier for fpu_response class method
//            compare 
//----------------------------------------------------------------------
class fp_operand extends uvm_object;
  `uvm_object_utils(fp_operand)

  rand operand_kind_t mode;
  rand single_float_t operand;


  constraint fair { 
    solve mode before operand;
  }


  constraint NaN { 
    if (mode == C_NaN) {
      operand.sign inside {'b0, 'b1} ;
      operand.exponent == 'hff;
      operand.mantissa[$size(operand.mantissa)-1] inside {'b0, 'b1}; // msb
    }
  } // Nan

  constraint Infinity { 
    if (mode == C_Infinity) {
      operand.sign inside {'b0, 'b1} ;
      operand.exponent == 'hff;
      operand.mantissa == 'h0;
    }
  }// Infinity
 
  constraint Zero { 
    if (mode == C_Zero) {
      operand.sign inside {'b0, 'b1} ;
      operand.exponent == 0;
      operand.mantissa == 0;
    }
  } // Zero

  constraint Valid { 
    if (mode == C_Valid) {
       operand.sign inside {'b0, 'b1} ;
       operand.exponent != 'h00;
       operand.exponent != 'hff;
       operand.mantissa != 'h0;
       operand.mantissa != 'h7fffff;
       }
  } // Valid


  function new (string name = "fp_operand");
    super.new(name);
//    this.operand = operand;
  endfunction // new

  function void do_copy (uvm_object rhs);
    fp_operand temp;
    if (!$cast(temp, rhs))
    begin
      `uvm_error("TYPE MISMATCH", "Type mismatch in do_copy() for fp_operand")
    end
    super.do_copy (temp);
    this.mode = temp.mode;
    this.operand = temp.operand;
  endfunction  


  function string convert2string;
    string s;
    shortreal r_operand;
      
    r_operand = $bitstoshortreal(operand);
    //$sformat(s,"(%s)%e", mode, r_operand);
    s = $sformatf("%e", r_operand);
    return s;
  endfunction // convert2string

  local function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    fp_operand temp;
    do_compare = ($cast(temp, rhs) &&
                  super.do_compare(temp, comparer) &&
                  this.mode    == temp.mode &&
                  this.operand == temp.operand );
  endfunction // bit

endclass
