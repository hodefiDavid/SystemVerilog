class transaction 
#(parameter ADDR_WIDTH = 8, parameter DATA_WIDTH = 3);
  
  //declare the transaction fields
  rand bit rst;
  rand logic [ADDR_WIDTH-1:0]  addr;

  //control signals
  rand logic      wr_en;
  rand logic      rd_en;
  //add constrain to enable only one of the control signals at a time
  //the DUT shuld not be able to read and write at the same time  
  constraint c1 { wr_en ^ rd_en == 1; }
  constraint c2 { rst == 0; }

 


  //data signals
  rand logic  [DATA_WIDTH-1:0]  wr_data;
  logic  [DATA_WIDTH-1:0] rd_data;

   // Add constraint to wr_data
  //  constraint c3 {
  //   wr_data < 8;
  //   wr_data > 0;
  // }

  function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    $display("- wr_en = %b, rd_en = %b, rst = %b",wr_en,rd_en,rst);
    $display("- addr = %d",addr);
    $display("-------------------------");
  endfunction

endclass
