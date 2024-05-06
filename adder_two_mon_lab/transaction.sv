class transaction;
  
  //declare the transaction fields
  rand bit [3:0] a;
  rand bit [3:0] b;
       bit [4:0] sum;
  function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    $display("- a = %d, b = %d",a,b);
    $display("- sum = %d",sum);
    $display("-------------------------");
  endfunction
endclass
