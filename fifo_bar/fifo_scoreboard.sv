class fifo_scoreboard;
  mailbox mlbx;
  int num_of_check;
  int num_of_pass;
  int pointer = -1;
  bit [7:0] scbd_rdata;
  bit scbd_full;
  bit scbd_empty = 1;
  bit [3:0] scbd_memory[4:0];
  int rdata_miss;
  int full_miss;
  int empty_miss;
  function new(mailbox mlbx);
    this.mlbx = mlbx;
  endfunction

  task main();
    transaction trans;


    forever begin
      mlbx.get(trans);
      $display("### debug pointer is at %d", pointer);
      //////////////////////////////////////////
      ///////////////the fifo op///////////////
      ////////////////////////////////////////
      if (trans.rst) begin
        for (int i = 0; i < 5; i = i + 1) begin
          scbd_memory[i] = 0;
        end  //for
        pointer = -1;
      end //if
else if ((pointer==-1 & !trans.wr) ||(pointer==0 & trans.rd)) begin //going to be empty
        scbd_full  <= 0;
        scbd_empty <= 1;
      end
else if ((pointer==4 & !trans.rd) ||(pointer==3 & trans.wr)) begin //going to be full
        scbd_full  <= 1;
        scbd_empty <= 0;
      end else begin
        scbd_full  <= 0;
        scbd_empty <= 0;
      end
      case ({
        trans.rd, trans.wr
      })
        2'b01:
        if (pointer < 4) begin  //write

          scbd_memory[pointer+1] = trans.wdata;
          $display("####debug: the pointer before ++ is %d###", pointer);
          pointer++;
          $display("####debug: the pointer is %d###", pointer);
        end
        2'b10:
        if (pointer > -1) begin  //read
          scbd_rdata = scbd_memory[0];
          for (int i = 1; i < pointer + 1; i++) scbd_memory[i-1] <= scbd_memory[i];
          $display("####debug: the pointer before ++ is %d###", pointer);
          pointer--;
          $display("####debug: the pointer is %d###", pointer);
        end
      endcase
      //end
      ////////////////////////////////////////
      ////////////////////////////////////////
      ////////////////////////////////////////

      #1;
      $display("check:: time %d trans rdata %d scbd_Rdata %d", $time, trans.rdata, scbd_rdata);
      num_of_check++;
      if((trans.rdata==scbd_rdata) & (trans.full==scbd_full) &  (trans.empty==scbd_empty)) begin
        num_of_pass++;
      end else begin
        $error("mismatch in scoreboard at time %t", $time);
        trans.display("scoreboard");
      end

      if (trans.rdata !== scbd_rdata) begin
        rdata_miss++;
      end

      if (trans.full !== scbd_full) begin
        full_miss++;
      end
      if (trans.empty !== scbd_empty) begin
        empty_miss++;
      end
    end  //forever
  endtask

endclass
