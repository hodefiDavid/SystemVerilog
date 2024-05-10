class transaction #(parameter WIDTH = 4);

  //declare the transaction fields for ALU DUT
  rand bit [WIDTH-1:0] a;
  rand bit [WIDTH-1:0] b;
  rand bit[1:0] select;
  bit [WIDTH-1:0] out;
  bit zero;
  bit carry;
  bit sign;
  bit parity;
  bit overflow;
  

  function void display(string name);
    $display("-------------------------");
    $display("- %s ", name);
    display_in("port in");
    display_out("port out");
    $display("-------------------------");

  endfunction

  function void display_in(string name);
    $display(name);
    $display("a = %b", a);
    $display("b = %b", b);
    $display("select = %b", select);

  endfunction

  function void display_out(string name);
    $display(name);
    $display("out = %b", out);
    $display("zero = %b", zero);
    $display("carry = %b", carry);
    $display("sign = %b", sign);
    $display("parity = %b", parity);
    $display("overflow = %b", overflow);
  endfunction

endclass
