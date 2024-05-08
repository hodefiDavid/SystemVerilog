class transaction;
  
  //declare the transaction fields
  bit rst;
  rand  bit write_en;
  rand  bit read_en;
  rand  bit [3:0] data_in;

  bit [3:0] data_out;
  bit full;
  bit empty;
  //constraint to ensure write_en and read_en are not high at the same time
  constraint read_or_write {!(write_en && read_en);}


  function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    display_in("port in");
    display_out("port out");
    $display("-------------------------");
  endfunction


    function void display_in(string name);
    $display("- %s ",name);
    $display("- write_en = %d",write_en);
    $display("- read_en = %d",read_en);
    $display("- data_in = %h",data_in);
    $display("- rst = %d",rst);
  endfunction

      function void display_out(string name);
    $display("-%s ",name);
    $display("- data_out = %h",data_out);
    $display("- full = %d",full);
    $display("- empty = %d",empty);
  endfunction

endclass



// !(write_en && read_en);

 // constraint read_or_write {
  //                           if(write_en) read_en==0;
  //                             else if(read_en) write_en==0;
  //                                 else write_en==0; read_en==0;
  //                           }  