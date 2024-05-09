class transaction #(ADDR_WIDTH = 3, DATA_WIDTH=8 );
  
  //declare the transaction fields
  rand bit [ADDR_WIDTH-1:0]  addr;
  rand bit [DATA_WIDTH-1:0]  wr_data;
  rand bit        wr_en;
  rand bit        rd_en;
       bit [DATA_WIDTH-1:0] rd_data;
  constraint wr_rd {(wr_en==1)-> rd_en==0 ;}
  function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    $display(" address = %d",addr);
    $display("- write data = %d",wr_data);
    $display("-------------------------");
    $display("- write enable = %d", wr_en);
    $display("- read enable = %d" , rd_en);
    $display("- read data = %d", rd_data);

  endfunction
endclass
