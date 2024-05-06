//gets the packet from the monitor, generates the expected results 
//and compares with the actual results received from the monitor

class scoreboard;

  //create mailbox handle
  mailbox mon2scbin;
  mailbox mon2scbout;

  //count the number of transactions
  int num_transactions;

  //constructor
  function new(mailbox mon2scbin, mailbox mon2scbout);
    //get the mailbox handle from  environment 
    this.mon2scbin  = mon2scbin;
    this.mon2scbout = mon2scbout;
  endfunction

  //Compare the actual results with the expected results
  task main;
    transaction trans_in;
    transaction trans_out;
    int i;
    //reference model memory
    reg [trans_in.DATA_WIDTH-1:0] mem[2**trans_in.ADDR_WIDTH];
    //initialize the memory
    for (i = 0; i < 2 ** trans_in.ADDR_WIDTH; i++) mem[i] = 0;


    forever begin
      mon2scbin.get(trans_in);
      mon2scbout.get(trans_out);

      //reference model functionality
      if (trans_in.rst) begin
        for (i = 0; i < 2 ** trans_in.ADDR_WIDTH; i++) mem[i] = 0;
      end else if (trans_in.wr_en) mem[trans_in.addr] = trans_in.wr_data;
      else if (trans_in.rd_en) trans_in.rd_data = mem[trans_in.addr];


      //check the result
      if (trans_out.rd_data == trans_in.rd_data) $display("Result is as Expected");
      else $error("Wrong Result.\n\tExpeced: %0d Actual: %0d", trans_in.rd_data, trans_out.rd_data);
      num_transactions++;
      trans_in.display("[ --Scoreboard_in-- ]");
      trans_out.display("[ --Scoreboard_out-- ]");
    end
  endtask

endclass
