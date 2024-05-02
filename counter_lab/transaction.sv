class transaction;
  
  //declare the transaction fields
  rand bit [7:0] data_in;
  rand bit load;
  rand bit enable;
       bit [7:0] count;

  function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    $display("- load = %b, enable = %b",load,enable);
    $display("- count = %d",count);
    $display("-------------------------");
  endfunction
endclass
