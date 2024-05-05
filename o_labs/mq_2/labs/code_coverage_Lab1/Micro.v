
 
module micro (address, data_in, data_out, rd, wr, cs, reset, tri_state, crc_enable
              , test_mode, state_control, mode_control, fifo_reset, int_ack, chanenb
              , group_id, variable_rst, data_mode, clam_data, search, swap_channel
              , swap_byte, tx_pattern, gid_error, in_sync, emp_flag, full_flag, 
              pointer, master_cid_sync, master_frame_sync, nand_tree, crc_tri_state
              , var_tri_state, fs_tri_state, open_collector, fifo_test);
  
  input [3:0] address;
  input [7:0] data_in;
  output [7:0] data_out;
  input rd;
  input wr;
  input cs;
  input reset;
  output tri_state;
  output crc_enable;
  output test_mode;
  output [1:0] state_control;
  output [1:0] mode_control;
  output fifo_reset;
  output int_ack;
  output [4:0] chanenb;
  output [5:0] group_id;
  output variable_rst;
  output data_mode;
  output clam_data;
  output search;
  output swap_channel;
  output swap_byte;
  output tx_pattern;
  input gid_error;
  input in_sync;
  input emp_flag;
  input full_flag;
  input [13:0] pointer;
  input master_cid_sync;
  input master_frame_sync;
  output nand_tree;
  input crc_tri_state;
  input var_tri_state;
  input fs_tri_state;
  input open_collector;
  output fifo_test;
 
  reg [7:0] reg5;
  reg [5:0] reg4; 
  reg [6:0] reg2;
  reg [7:0] reg0;  
  reg [7:0] data_out;
  
  reg register_tri_state;
  
  always @( posedge wr or negedge reset )
  begin
    if (!reset)
    begin
      reg0 <= 8'b00000000;
      reg2 <= 7'b0000000;
      reg4 <= 6'b000000;
      reg5 <= 8'b00000000;
    end
    else 
      if (!cs)
        case (address)
          4'b0000 : 
            reg0 <= data_in[7:0];
          4'b0010 : 
            reg2 <= data_in[6:0];
          4'b0100 : 
            reg4 <= data_in[5:0];
          4'b0101 : 
            reg5 <= data_in[7:0];
          default  : ;
        endcase
      
      
    
  end
 
  always @(rd or cs or address or reg0 or reg2 or reg4 or reg5 or gid_error or in_sync or emp_flag or full_flag or pointer or master_cid_sync or 
  master_frame_sync or crc_tri_state or var_tri_state or fs_tri_state or register_tri_state or open_collector
  )
  begin
    if (!rd && !cs)
      register_tri_state <= 1'b1;
    else
      register_tri_state <= 1'b0;
    
    case (address[3:0])
      4'b0000 : 
        data_out <= reg0;
      4'b0010 : 
        data_out <= {1'b0 , reg2};
      4'b0100 : 
        data_out <= {2'b00 , reg4};
      4'b0101 : 
        data_out <= reg5;
      4'b0110 : 
        data_out <= {{{{4'b1111 , gid_error} , in_sync} , emp_flag} , full_flag
                       };
      4'b0111 : 
        data_out <= pointer[7:0];
      4'b1000 : 
        data_out <= {{master_cid_sync , master_frame_sync} , pointer[13:8]};
      4'b1001 : 
        data_out <= {{{{{3'b111 , crc_tri_state} , var_tri_state} , fs_tri_state
                       } , open_collector} , register_tri_state};
      default  : 
        data_out <= 8'b11001110;
    endcase
  
  end
 // coverage off
  assign crc_enable = reg0[0];
  assign test_mode = reg0[1];
  assign state_control = reg0[3:2];
  assign mode_control = reg0[5:4];
  assign fifo_reset = reg0[6];
  assign int_ack = reg0[7];
  assign chanenb = reg2[4:0];
  assign nand_tree = reg2[5];
  assign fifo_test = reg2[6];
  assign group_id = reg4;
  assign variable_rst = reg5[0];
  assign data_mode = reg5[1];
  assign clam_data = reg5[2];
  assign search = reg5[4];
  assign swap_channel = reg5[5];
  assign swap_byte = reg5[6];
  assign tx_pattern = reg5[7];
  assign tri_state = register_tri_state;
// coverage on  
endmodule 

