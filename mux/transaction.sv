class transaction;


// declearing the input and output ports - of the - mux
rand bit [1:0] in0,in1,in2,in3;
rand bit [1:0] select;
     bit [1:0] out;

  

  function void display(string name);
    $display("-------------------------");
    $display("- %s ", name);
    display_in("port in");
    display_out("port out");
    $display("-------------------------");

  endfunction

  function void display_in(string name);
    $display(name);
    $display("input = %b", in0);
    $display("input = %b", in1);
    $display("input = %b", in2);
    $display("input = %b", in3);

    $display("select = %b", select);

  endfunction

  function void display_out(string name);
    $display(name);
    $display("output = %b", out);
  endfunction

endclass
