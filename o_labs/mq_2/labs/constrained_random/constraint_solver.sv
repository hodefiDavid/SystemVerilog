package test_pkg;
  class TFoo;
    rand bit [5:0] a, b, c;
    constraint c1 { a < b; }
    constraint c2 { b < c; }
    constraint c3 { a < 23; }
    constraint c4 { b > 12; }
    constraint c5 { c == 20; }
  endclass
endpackage : test_pkg  

module constraint_solver;

  import test_pkg::*;

  class TBar extends TFoo;
    constraint c0 { a == c; }
  endclass

  TBar f = new;
  int status;

  initial
    $display("status = %0b",f.randomize());

endmodule