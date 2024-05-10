class transaction;

  //declare the transaction fields
  rand bit i_a;
  rand bit i_b;
  rand bit i_cin;
  bit o_carry;
  bit o_sum;

  function void display(string name);
    $display("-------------------------");
    $display("- %s ", name);
    display_in("port in");
    display_out("port out");
    $display("-------------------------");

  endfunction

  function void display_in(string name);
    $display(name);
    $display("i_a = %b", i_a);
    $display("i_b = %b", i_b);
    $display("i_cin = %b", i_cin);

  endfunction

  function void display_out(string name);
    $display(name);
    $display("o_carry = %b", o_carry);
    $display("o_sum = %b", o_sum);
  endfunction

endclass
