class transaction;
  
  //declare the transaction fields
  rand bit [7:0] data_in;
  rand bit       load;
       bit [7:0] count;
       bit   enable;
  function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    $display(" data_in = %d",data_in);
    $display("- count = %d",count);
    $display("-------------------------");
    $display("- load = %d",load);
    $display("- enable = %d",enable);
    

  endfunction
endclass
