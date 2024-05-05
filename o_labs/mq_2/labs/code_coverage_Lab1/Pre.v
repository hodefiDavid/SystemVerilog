 
 
module pre_processor (reset, clock, variable_address, variable_write, variable_read
                      , variable_save, variable_restore, variable_reset, data_mode
                      , fs_write, fsdatenb_strobe, frame_store_data, iom_dck, iom_sds1
                      , iom_sds2, address_pointer, fs_address, iom_dd, pre8m, master_cid_sync
                      , master_frame_sync, common_reset, test_mode, group_id, group_id_error
                      );
  
  input reset;
  input clock;
  output [7:0] variable_address;
  output variable_write;
  output variable_read;
  output [7:0] variable_save;
  input [7:0] variable_restore;
  input variable_reset;
  input data_mode;
  output fs_write;
  output fsdatenb_strobe;
  output [7:0] frame_store_data;
  input iom_dck;
  input iom_sds1;
  input iom_sds2;
  output [13:0] address_pointer;
  output [18:0] fs_address;
  input iom_dd;
  input pre8m;
  output master_cid_sync;
  output master_frame_sync;
  output common_reset;
  input test_mode;
  input [5:0] group_id;
  output group_id_error;
  `define optimize_t_true	 2'd0
  `define optimize_t_false	 2'd1
  `define optimize_t_inherit	 2'd2
  `define frame_mac_states_search	 2'd0
  `define frame_mac_states_match	 2'd1
  `define frame_mac_states_found	 2'd2
  `define frame_mac_states_error	 2'd3
  `define mac_states_out_of_sync	 3'd0
  `define mac_states_seen_once	 3'd1
  `define mac_states_seen_twice	 3'd2
  `define mac_states_in_sync	 3'd3
  `define mac_states_missed_once	 3'd4
  `define mac_states_missed_twice	 3'd5
  `define persist_mac_states_search	 2'd0
  `define persist_mac_states_match	 2'd1
  `define persist_mac_states_found_twice	 2'd2
  `define persist_mac_states_frozen	 2'd3
  `define cyc_state_enabled	 2'd0
  `define cyc_state_seen_once	 2'd1
  `define cyc_state_seen_twice	 2'd2
  `define cyc_state_disabled	 2'd3
  wire vcc;
  `define gerror_noerror	 2'd0
  `define gerror_errora	 2'd1
  `define gerror_errorb	 2'd2
  wire [1:0] states_ichan;
  wire [1:0] states_chan_id;
  wire [2:0] states_faw;
  wire [1:0] states_frame;
  wire [1:0] states_crc;
  wire [2:0] in_faw_state;
  wire [1:0] states_group;
  wire [1:0] in_frame_state;
  reg frame_sync_found;
  wire [5:0] frames;
  wire [1:0] in_chan_id_state;
  wire [1:0] in_crc_state;
  wire iom_reset;
  wire [1:0] in_group_id_state;
  wire [9:0] vcount;
  wire [4:0] delayed_column;
  wire [7:0] octet_count;
  wire [3:0] ichan_count;
  wire [1:0] in_ic_state;

  wire [13:0] a;
  wire [13:0] b;
  wire add13;
  wire co00;
  wire co01;
  wire co03;
  wire co04;
  wire co05;
  wire co07;
  wire co08;
  wire co09;
  wire co11;
  wire co12;
  reg [4:0] vcountb;
  reg vcount_full;
  reg [4:0] vcounta;
  reg [4:0] variable_column;
  reg [2:0] variable_number;
  reg variable_write;
  reg crc_strobe;
  reg bit_strobe;
  reg variable_read;
  reg up_date_pointer;
  reg fsaddr_enb;
  reg fsdat_strobe;
  reg fswr_strobe;
  reg octet_strobe;
  reg [4:0] dcolumn;
  reg var_rd7;
  reg var_rd6;
  reg var_rd5;
  reg var_rd4;
  reg var_rd3;
  reg var_rd2;
  reg var_rd1;
  reg var_rd0;
  reg [10:0] register_contents;
  reg group_id_position;
  reg chan_id_position;
  reg ic_sync_position;
  reg crc_position;
  reg frame_position;
  reg ic_position;
  reg faw_position;
  reg compare_ichan;
  reg compare_faw;
  reg ic_sync_found;
  reg ichan_reset;
  reg [1:0] ichan_state;
  reg faw_sync_found;
  reg octet_count_reset;  
  reg [2:0] faw_state;
  reg [3:0] ocountb;
  reg ofull;
  reg [3:0] ocounta;
  reg [3:0] icount;
  reg [7:0] variable_save;
  reg [2:0] frcountb;
  reg frfull;
  reg [2:0] frcounta;
  reg [1:0] frame_state;
  reg [5:0] store_frames;
  reg frame_matched;
  reg chan_id_sync;
  reg [1:0] chan_id_state;
  reg [4:0] chanid_store;
  reg chan_id_matched;
  reg [1:0] crcstate;
  reg [3:0] crc_store;
  reg crc_result;
  reg [3:0] crc_compare;
  reg crc_reset;
  reg [3:0] crc;
  reg crc_enabled;
  reg crc_reset_strobe;
  reg crc_compare_strobe;
  reg fsdatenb_strobe;
  reg fs_write;
  reg [4:0] channel_id;
  reg store_first_value;
  reg retime_one_shot;
  reg [13:0] stored_value;
  reg one_shot;
  reg [13:0] calculated_value;
  reg co10;
  reg co06;
  reg co02;
  reg [1:0] frame_store_datar;
  reg master_frame_sync;
  reg master_cid_sync;
  reg master_channel;
  reg iom_enable;
  reg iom_retime_two;
  reg iom_retime_one;
  reg [15:0] iombits;
  reg common_rst;
  reg retime_fcsb;
  reg retime_fcsa;
  reg jitter_reset;
  reg jitter_pulse;
  reg retime_pre8m;
  reg data_in;
  reg data_clamp;
  reg [3:0] iom_pointer;
  reg group_id_sync;
  reg [1:0] group_id_state;
  reg group_id_error;
  reg group_error;
  reg [1:0] group_err;
  reg [5:0] group_store;
  reg group_id_matched;

  always @( posedge (clock) )
  begin    
    if (!common_rst || !reset)
      vcounta <= 5'b00000;
    else
      vcounta <=  (vcounta + 1'b1) ;
    
    if (!reset)
      vcount_full <= 1'b0;
    else if (vcounta == 5'b11110)
      vcount_full <= 1'b1;
    else
      vcount_full <= 1'b0;
    
    if (!common_rst || !reset)
      vcountb <= 5'b00000;
    else if (vcount_full)
      vcountb <=  (vcountb + 1'b1) ;
    
  end
 
  always @( posedge (clock) )
  begin    
    if (!reset)
      variable_number <= vcount[3:1];
    else if (vcount[4])
      variable_number <=  (~ (vcount[3:1])) ;
    else
      variable_number <= vcount[3:1];
    
    if (!reset)
      variable_column <= delayed_column;
    else if (vcount[4:1] == 4'b0000)
      variable_column <= vcount[9:5];
    else
      variable_column <= delayed_column;
    
  end
 
  always @( negedge (clock) )
  begin    
    if (!reset)
      variable_write <= 1'b0;
    else
      case ((vcounta))
        5'b11111 : 
          variable_write <= 1'b0;
        5'b00011 : 
          variable_write <= 1'b0;
        5'b00101 : 
          variable_write <= 1'b0;
        5'b00111 : 
          variable_write <= 1'b0;
        5'b01001 : 
          variable_write <= 1'b0;
        5'b01011 : 
          variable_write <= 1'b0;
        5'b01101 : 
          variable_write <= 1'b0;
        5'b01111 : 
          variable_write <= 1'b0;
        default  : 
          variable_write <= 1'b1;
      endcase
    
    
  end
 
  always @( posedge (clock) )
  begin    
    if (!reset)
      var_rd0 <= 1'b1;
    else if ((vcount[4:0]) == 5'b00000)
      var_rd0 <= 1'b0;
    else
      var_rd0 <= 1'b1;
    
    if (!reset)
      var_rd1 <= 1'b1;
    else if ((vcount[4:0]) == 5'b11100)
      var_rd1 <= 1'b0;
    else
      var_rd1 <= 1'b1;
    
    if (!reset)
      var_rd2 <= 1'b1;
    else if ((vcount[4:0]) == 5'b11010)
      var_rd2 <= 1'b0;
    else
      var_rd2 <= 1'b1;
    
    if (!reset)
      var_rd3 <= 1'b1;
    else if ((vcount[4:0]) == 5'b11000)
      var_rd3 <= 1'b0;
    else
      var_rd3 <= 1'b1;
    
    if (!reset)
      var_rd4 <= 1'b1;
    else if ((vcount[4:0]) == 5'b10110)
      var_rd4 <= 1'b0;
    else
      var_rd4 <= 1'b1;
    
    if (!reset)
      var_rd5 <= 1'b1;
    else if ((vcount[4:0]) == 5'b10100)
      var_rd5 <= 1'b0;
    else
      var_rd5 <= 1'b1;
    
    if (!reset)
      var_rd6 <= 1'b1;
    else if ((vcount[4:0]) == 5'b10010)
      var_rd6 <= 1'b0;
    else
      var_rd6 <= 1'b1;
    
    if (!reset)
      var_rd7 <= 1'b1;
    else if ((vcount[4:0]) == 5'b10000)
      var_rd7 <= 1'b0;
    else
      var_rd7 <= 1'b1;
    
    if ((vcount[4:0]) == 5'b01111 || !reset)
      dcolumn <= vcount[9:5];
    else
      dcolumn <= dcolumn;
    
    if (!reset)
      octet_strobe <= 1'b0;
    else if ((vcount[4:0]) == 5'b11111)
      octet_strobe <= 1'b1;
    else
      octet_strobe <= 1'b0;
    
    if (!reset)
      fswr_strobe <= 1'b0;
    else if ((vcount[4:0]) == 5'b11110)
      fswr_strobe <= 1'b1;
    else
      fswr_strobe <= 1'b0;
    
    if (!reset)
      fsdat_strobe <= 1'b0;
    else if ((vcount[4:1]) == 4'b0000)
      fsdat_strobe <= 1'b1;
    else
      fsdat_strobe <= 1'b0;
    
    if (!reset)
      fsaddr_enb <= 1'b0;
    else if ((vcount[4:1]) == 4'b0000 || (vcount[4:0]) == 5'b11111)
      fsaddr_enb <= 1'b1;
    else
      fsaddr_enb <= 1'b0;
    
    if (!reset)
      up_date_pointer <= 1'b0;
    else if (vcount[9:3] == 7'b0000001)
      up_date_pointer <= 1'b1;
    else
      up_date_pointer <= 1'b0;
    
    if (!reset)
    begin
      variable_read <= 1'b0;
      bit_strobe <= 1'b0;
      crc_strobe <= 1'b0;
    end
    else
      case ((vcounta))
        5'b00000 : 
        begin
          variable_read <= 1'b0;
          bit_strobe <= 1'b0;
          crc_strobe <= 1'b0;
        end
        5'b00001 : 
        begin
          variable_read <= 1'b1;
          bit_strobe <= 1'b1;
          crc_strobe <= 1'b0;
        end
        5'b00101 : 
        begin
          variable_read <= 1'b1;
          bit_strobe <= 1'b1;
          crc_strobe <= 1'b0;
        end
        5'b01001 : 
        begin
          variable_read <= 1'b1;
          bit_strobe <= 1'b1;
          crc_strobe <= 1'b0;
        end
        5'b01101 : 
        begin
          variable_read <= 1'b1;
          bit_strobe <= 1'b1;
          crc_strobe <= 1'b0;
        end
        5'b10000 : 
        begin
          variable_read <= 1'b0;
          bit_strobe <= 1'b0;
          crc_strobe <= 1'b0;
        end
        5'b01111 : 
        begin
          variable_read <= 1'b1;
          bit_strobe <= 1'b0;
          crc_strobe <= 1'b0;
        end
        5'b10001 : 
        begin
          variable_read <= 1'b1;
          bit_strobe <= 1'b1;
          crc_strobe <= 1'b0;
        end
        5'b10010 : 
        begin
          variable_read <= 1'b0;
          bit_strobe <= 1'b0;
          crc_strobe <= 1'b0;
        end
        5'b10100 : 
        begin
          variable_read <= 1'b0;
          bit_strobe <= 1'b0;
          crc_strobe <= 1'b0;
        end
        5'b10101 : 
        begin
          variable_read <= 1'b1;
          bit_strobe <= 1'b1;
          crc_strobe <= 1'b0;
        end
        5'b10110 : 
        begin
          variable_read <= 1'b0;
          bit_strobe <= 1'b0;
          crc_strobe <= 1'b0;
        end
        5'b11000 : 
        begin
          variable_read <= 1'b0;
          bit_strobe <= 1'b0;
          crc_strobe <= 1'b0;
        end
        5'b11001 : 
        begin
          variable_read <= 1'b1;
          bit_strobe <= 1'b1;
          crc_strobe <= 1'b0;
        end
        5'b11010 : 
        begin
          variable_read <= 1'b0;
          bit_strobe <= 1'b0;
          crc_strobe <= 1'b1;
        end
        5'b11011 : 
        begin
          variable_read <= 1'b1;
          bit_strobe <= 1'b0;
          crc_strobe <= 1'b1;
        end
        5'b11100 : 
        begin
          variable_read <= 1'b0;
          bit_strobe <= 1'b0;
          crc_strobe <= 1'b1;
        end
        5'b11101 : 
        begin
          variable_read <= 1'b1;
          bit_strobe <= 1'b1;
          crc_strobe <= 1'b1;
        end
        5'b11111 : 
        begin
          variable_read <= 1'b1;
          bit_strobe <= 1'b0;
          crc_strobe <= 1'b0;
        end
        default  : 
        begin
          variable_read <= 1'b1;
          bit_strobe <= 1'b0;
          crc_strobe <= 1'b0;
        end 
      endcase
    
    
  end
 
  always @( posedge (clock) )
  begin    
    if (!reset)
      register_contents <= 11'b00000000000;
    else if (bit_strobe)
      register_contents <= {register_contents[9:0] , data_in};
    
  end
 
  always @( posedge (clock) )
  begin    
    //  Test for FAW pattern in Register
    if (!reset)
      compare_faw <= 1'b0;
    else if (register_contents[7:0] == 8'b00011011)
      compare_faw <= 1'b1;
    else
      compare_faw <= 1'b0;
  
    //  Test for IC SYNC pattern in Register
    if (!reset)
      compare_ichan <= 1'b0;
    else if (register_contents[7:0] == 8'b01111111)
      compare_ichan <= 1'b1;
    else
      compare_ichan <= 1'b0;

    //  Test Octet Counter for the position o
    //  the FAW octet
    if (!reset)
      faw_position <= 1'b0;
    else if (octet_count == 8'b00000000)
      faw_position <= 1'b1;
    else
      faw_position <= 1'b0;

    //  Test Octet Counter for the position o
    //  the IC frame
    if (!reset)
      ic_position <= 1'b0;
    else if (test_mode && octet_count[3:0] == 4'b0100)
      ic_position <= 1'b1;
    else if (octet_count == 8'b01000000)
      ic_position <= 1'b1;
    else
      ic_position <= 1'b0;
    
    //  Test Octet Counter for the position o
    //  the FRAME COUNT octet
    if (!reset)
      frame_position <= 1'b0;
    else if (test_mode && octet_count[3:0] == 4'b1000)
      frame_position <= 1'b1;
    else if (octet_count == 8'b10000000)
      frame_position <= 1'b1;
    else
      frame_position <= 1'b0;
   
    //  Test Mode Value for CRC Octe
    if (!reset)
      crc_position <= 1'b0;
    else if (test_mode && octet_count[3:0] == 4'b1100)
      crc_position <= 1'b1;
    else if (octet_count == 8'b11000000)
      crc_position <= 1'b1;
    else
      crc_position <= 1'b0;
    
    //  Test IC Counter for the start on th
    //  IC frame
    if (!reset)
      ic_sync_position <= 1'b0;
    else if (test_mode && ichan_count[1:0] == 2'b00)
      ic_sync_position <= 1'b1;
    else if (ichan_count == 4'b0000)
      ic_sync_position <= 1'b1;
    else
      ic_sync_position <= 1'b0;
    
    //  Test IC counter for the position o
    //  the channel I
    if (!reset)
      chan_id_position <= 1'b0;
    else if (test_mode && ichan_count[1:0] == 2'b01)
      chan_id_position <= 1'b1;
    else if (ichan_count == 4'b0001)
      chan_id_position <= 1'b1;
    else
      chan_id_position <= 1'b0;
    
    //  Test IC counter for the position o
    //  the group I
    if (!reset)
      group_id_position <= 1'b0;
    else if (test_mode && ichan_count[1:0] == 2'b10)
      group_id_position <= 1'b1;
    else if (ichan_count == 4'b0010)
      group_id_position <= 1'b1;
    else
      group_id_position <= 1'b0;
    
  end
 
  always @( posedge (clock) )
  begin    
    if (!reset)
    begin
      ichan_state <= `frame_mac_states_search;
      ichan_reset <= 1'b0;
    end
    else if (!var_rd4)
      ichan_state <= in_ic_state;
    else if (octet_strobe)
      case (ichan_state)
        `frame_mac_states_search : 
          if (compare_ichan)
          begin
            if (!faw_sync_found)
            begin
              ichan_state <= `frame_mac_states_match;
              ichan_reset <= 1'b1;
            end
            else if (ic_position)
            begin
              ichan_state <= `frame_mac_states_match;
              ichan_reset <= 1'b1;
            end
            
          end
          else
          begin
            ichan_reset <= 1'b0;
            ichan_state <= `frame_mac_states_search;
          end
          
        `frame_mac_states_match : 
        begin
          if (!faw_sync_found)
            if (ic_sync_position)
              if (compare_ichan)
                ichan_state <= `frame_mac_states_found;
              else
                ichan_state <= `frame_mac_states_search;
              
            else
              ichan_state <= `frame_mac_states_match;
            
          else if (ic_position && ic_sync_position)
            if (compare_ichan)
              ichan_state <= `frame_mac_states_found;
            else
              ichan_state <= `frame_mac_states_search;
            
          else
            ichan_state <= `frame_mac_states_match;
          
          ichan_reset <= 1'b0;
        end
        `frame_mac_states_found : 
        begin
          if (!faw_sync_found)
            if (ic_sync_position)
              if (compare_ichan)
                ichan_state <= `frame_mac_states_found;
              else
                ichan_state <= `frame_mac_states_error;
              
            else
              ichan_state <= `frame_mac_states_found;

          else if (data_mode)
            ichan_state <= `frame_mac_states_found;
          else if (ic_position && ic_sync_position)
            if (compare_ichan)
              ichan_state <= `frame_mac_states_found;
            else
              ichan_state <= `frame_mac_states_error;
 
          else
            //  If multi-frames and data mode enable
            ichan_state <= `frame_mac_states_found;
          
          ichan_reset <= 1'b0;
        end
        `frame_mac_states_error : 
        begin
          if (!faw_sync_found)
            if (ic_sync_position)
              if (compare_ichan)
                ichan_state <= `frame_mac_states_found;
              else
                ichan_state <= `frame_mac_states_search;
              
            else
              ichan_state <= `frame_mac_states_error;
            
          else if (ic_position && ic_sync_position)
            if (compare_ichan)
              ichan_state <= `frame_mac_states_found;
            else
              ichan_state <= `frame_mac_states_search;
            
          else
            ichan_state <= `frame_mac_states_error;
          
          ichan_reset <= 1'b0;
        end
      endcase
    
    
    case (ichan_state)
      `frame_mac_states_search : 
        ic_sync_found <= 1'b0;
      `frame_mac_states_match,`frame_mac_states_found,`frame_mac_states_error : 
        ic_sync_found <= 1'b1;
    endcase
  
  end
// Add coverage off
  always @( posedge (clock) )
  begin    
    if (!reset)
    begin
      faw_state <= `mac_states_out_of_sync;
      octet_count_reset <= 1'b0;
    end
    else if (!var_rd6)
      faw_state <= in_faw_state;
    else if (octet_strobe)
      case (faw_state)
        `mac_states_out_of_sync : 
          if (compare_faw)
          begin
            octet_count_reset <= 1'b1;
            faw_state <= `mac_states_seen_once;
          end
          else
          begin
            octet_count_reset <= 1'b0;
            faw_state <= `mac_states_out_of_sync;
          end
          
        `mac_states_seen_once : 
        begin
          if (faw_position)
            if (compare_faw)
              faw_state <= `mac_states_seen_twice;
            else
              faw_state <= `mac_states_out_of_sync;
            
          
          octet_count_reset <= 1'b0;
        end
        `mac_states_seen_twice : 
        begin
          if (faw_position)
            if (compare_faw)
              faw_state <= `mac_states_in_sync;
            else
              faw_state <= `mac_states_out_of_sync;
            
          
          octet_count_reset <= 1'b0;
        end
        `mac_states_in_sync : 
        begin
          if (data_mode)
            faw_state <= `mac_states_in_sync;
          else if (faw_position)
            if (compare_faw)
              faw_state <= `mac_states_in_sync;
            else
              faw_state <= `mac_states_missed_once;
            
          
          octet_count_reset <= 1'b0;
        end
        `mac_states_missed_once : 
        begin
          if (faw_position)
            if (compare_faw)
              faw_state <= `mac_states_in_sync;
            else
              faw_state <= `mac_states_missed_twice;
            
          
          octet_count_reset <= 1'b0;
        end
        `mac_states_missed_twice : 
        begin
          if (faw_position)
            if (compare_faw)
              faw_state <= `mac_states_in_sync;
            else
              faw_state <= `mac_states_out_of_sync;
            
          
          octet_count_reset <= 1'b0;
        end
      endcase
// Add coverage on    
    case (faw_state)
      `mac_states_out_of_sync,`mac_states_seen_once,`mac_states_seen_twice : 
        faw_sync_found <= 1'b0;
      `mac_states_in_sync,`mac_states_missed_once,`mac_states_missed_twice : 
        faw_sync_found <= 1'b1;
    endcase
  
  end
 
  always @( posedge (clock) )
  begin    
    if ((octet_count_reset && !var_rd0) || !reset)
      ocounta <= 4'b0000;
    else if (!var_rd5)
      ocounta <= variable_restore[3:0];
    else if (!var_rd4)
      ocounta <=  (ocounta + 1'b1) ;
    
    if (!reset)
      ofull <= 1'b0;
    else if (ocounta == 4'b1111)
      ofull <= 1'b1;
    else
      ofull <= 1'b0;
    
    if ((octet_count_reset && !var_rd0) || !reset || test_mode)
      ocountb <= 4'b0000;
    else if (!var_rd5)
      ocountb <= variable_restore[7:4];
    else if (!var_rd4 && ofull)
      ocountb <=  (ocountb + 1'b1) ;
    
  end
 
  always @( posedge (clock) )
  begin
    if ((ichan_reset && !var_rd0) || !reset)
      icount <= 4'b0000;
    else if (!var_rd6)
      icount <= variable_restore[3:0];
    else if (!var_rd1)
      if (faw_sync_found)
      begin
        if (ic_position)
          icount <=  (icount + 1'b1) ;
        
      end
      else
        icount <=  (icount + 1'b1) ;
      
    
  end
 
  always @(variable_number or crc or group_store or states_crc or chanid_store or states_group or states_chan_id or 
  states_frame or states_ichan or octet_count or states_faw or ichan_count or store_frames or variable_reset
  )
  begin
    if (variable_reset)
      variable_save <= 8'b00000000;
    else
      case ((variable_number))
        3'b000 : 
          variable_save <= {4'b1111 , crc};
        3'b001 : 
          variable_save <= {2'b11 , group_store};
        3'b010 : 
          variable_save <= {{states_crc , 1'b1} , chanid_store};
        3'b011 : 
          variable_save <= {{states_group , 4'b1111} , states_chan_id};
        3'b100 : 
          variable_save <= {{{2'b11 , states_frame} , 2'b11} , states_ichan};
        3'b101 : 
          variable_save <= octet_count;
        3'b110 : 
          variable_save <= {{1'b1 , states_faw} , ichan_count};
        3'b111 : 
          variable_save <= {2'b11 , store_frames};
        default  : ;
      endcase
    
    
  end
 
  always @( posedge (clock) )
  begin
    if (!reset)
      frcounta <= 3'b000;
    else if (!var_rd7)
      frcounta <= variable_restore[2:0];
    else if (!var_rd3 && faw_position)
      frcounta <=  (frcounta + 1'b1) ;
    
    if (!reset)
      frfull <= 1'b0;
    else if (frcounta == 3'b111)
      frfull <= 1'b1;
    else
      frfull <= 1'b0;
    
    if (!reset)
      frcountb <= 3'b000;
    else if (!var_rd7)
      frcountb <= variable_restore[5:3];
    else if (!var_rd3 && frfull && faw_position)
      frcountb <=  (frcountb + 1'b1) ;
    
  end
 
  always @( posedge (clock) )
  begin
    if (!reset)
      frame_state <= `frame_mac_states_search;
    else if (!var_rd4)
      frame_state <= in_frame_state;
    else if (octet_strobe)
      case (frame_state)
        `frame_mac_states_search : 
          if (faw_sync_found && frame_position)
            if (frame_matched)
              frame_state <= `frame_mac_states_match;
            else
              frame_state <= `frame_mac_states_search;
            
          else
            frame_state <= `frame_mac_states_search;
          
        `frame_mac_states_match : 
          if (faw_sync_found && frame_position)
            if (frame_matched)
              frame_state <= `frame_mac_states_found;
            else
              frame_state <= `frame_mac_states_search;
            
          else
            frame_state <= `frame_mac_states_match;
          
        `frame_mac_states_found : 
          if (data_mode)
            frame_state <= `frame_mac_states_found;
          else if (faw_sync_found && frame_position)
            if (frame_matched)
              frame_state <= `frame_mac_states_found;
            else
              frame_state <= `frame_mac_states_error;
            
          else
            frame_state <= `frame_mac_states_found;
          
        `frame_mac_states_error : 
          if (faw_sync_found && frame_position)
            if (frame_matched)
              frame_state <= `frame_mac_states_found;
            else
              frame_state <= `frame_mac_states_search;
            
          else
            frame_state <= `frame_mac_states_error;
          
      endcase
    
    
    case (frame_state)
      `frame_mac_states_search,`frame_mac_states_match : 
        frame_sync_found <= 1'b0;
      `frame_mac_states_found,`frame_mac_states_error : 
        frame_sync_found <= 1'b1;
    endcase
  
  end
 
  always @( posedge (clock) )
  begin    
    //  Test for FRAME count in Register
    if (!reset)
      frame_matched <= 1'b0;
    else if (register_contents[6:1] == frames)
      frame_matched <= 1'b1;
    else
      frame_matched <= 1'b0;
    
    //  If the state machine has not foun
    //  sync save the on-line value of frame
    if (!reset)
      store_frames <= frames;
    else if (faw_sync_found && !frame_sync_found && frame_position)
      store_frames <= register_contents[10:5];
    else
      store_frames <= frames;
    
  end
 
  always @( posedge (clock) )
  begin
    if (!reset)
      chan_id_state <= `persist_mac_states_search;
    else if (!var_rd3)
      chan_id_state <= in_chan_id_state;
    else if (octet_strobe)
      if (data_mode && chan_id_state == `persist_mac_states_frozen)
        chan_id_state <= `persist_mac_states_frozen;
      else if (faw_sync_found)
        if (ic_sync_found)
        begin
          if (ic_position && chan_id_position)
            if (chan_id_matched)
              case (chan_id_state)
                `persist_mac_states_search : 
                  chan_id_state <= `persist_mac_states_match;
                `persist_mac_states_match : 
                  chan_id_state <= `persist_mac_states_found_twice;
                `persist_mac_states_found_twice : 
                  chan_id_state <= `persist_mac_states_frozen;
                `persist_mac_states_frozen : 
                  chan_id_state <= `persist_mac_states_frozen;
              endcase
            
            else
              case (chan_id_state)
                `persist_mac_states_frozen : 
                  chan_id_state <= `persist_mac_states_frozen;
                default  : 
                  chan_id_state <= `persist_mac_states_search;
              endcase
            
            
          
        end
        else
          chan_id_state <= `persist_mac_states_search;
        
      else
        if (ic_sync_found)
        begin
          if (chan_id_position)
            if (chan_id_matched)
              case (chan_id_state)
                `persist_mac_states_search : 
                  chan_id_state <= `persist_mac_states_match;
                `persist_mac_states_match : 
                  chan_id_state <= `persist_mac_states_found_twice;
                `persist_mac_states_found_twice : 
                  chan_id_state <= `persist_mac_states_frozen;
                `persist_mac_states_frozen : 
                  chan_id_state <= `persist_mac_states_frozen;
              endcase
            
            else
              case (chan_id_state)
                `persist_mac_states_frozen : 
                  chan_id_state <= `persist_mac_states_frozen;
                default  : 
                  chan_id_state <= `persist_mac_states_search;
              endcase
            
            
          
        end
        else
          chan_id_state <= `persist_mac_states_search;
        
      
    
    case (chan_id_state)
      `persist_mac_states_search,`persist_mac_states_match,`persist_mac_states_found_twice
       : 
        chan_id_sync <= 1'b0;
      `persist_mac_states_frozen : 
        chan_id_sync <= 1'b1;
    endcase
  
  end
 
  always @( posedge (clock) )
  begin    
    //  Test for Channel ID in Register
    if (!reset)
      chan_id_matched <= 1'b0;
    else if (register_contents[5:1] == chanid_store)
      chan_id_matched <= 1'b1;
    else
      chan_id_matched <= 1'b0;
    
    //  If the state machine has not foun
    //  sync save the on-line value of channel I
    if (!reset)
      chanid_store <= 5'b00000;
    else if (!var_rd2)
      chanid_store <= variable_restore[4:0];
    else if (!var_rd0 && !chan_id_sync)
      if (faw_sync_found)
        if (ic_sync_found)
          if (ic_position && chan_id_position)
            chanid_store[4:0] <= register_contents[5:1];
          else
            chanid_store <= chanid_store;
          
        else
          chanid_store <= 5'b11111;
        
      else
        if (ic_sync_found)
          if (chan_id_position)
            chanid_store[4:0] <= register_contents[5:1];
          else
            chanid_store <= chanid_store;
          
        else
          chanid_store <= 5'b11111;
        
      
    else
      chanid_store <= chanid_store;
    
  end
 
  //  CRC CHECKE
  //  Calculates the CRC4 over 255 octets an
  //  then compares it with the value sent from
  //  the transmitter
  always @( posedge (clock) )
  begin    
    if (!reset)
    begin
      crc <= 4'b0000;
      crc_reset <= 1'b0;
      crc_compare <= 4'b0000;
      crc_result <= 1'b0;
    end
    else if (!var_rd0)
    begin
      //  begin of timeslo
      crc <= variable_restore[3:0];
      crc_compare <= variable_restore[3:0];
    end
    else if (crc_reset_strobe)
    begin
      crc <= 4'b0000;
      crc_reset <= 1'b0;
    end
    else if (crc_compare_strobe)
      if (crc_store == crc_compare)  //  if CRC check passe
      begin
        crc_result <= 1'b1;
        crc_reset <= 1'b1;
      end
      else
      begin
        //  if CRC check fail
        crc_result <= 1'b0;
        crc_reset <= 1'b1;
      end
      
    else if (bit_strobe)
    begin
      crc[3] <=  (data_in ^ crc[0]) ;
      crc[2] <=  (crc[3] ^ ( (crc[0] ^ data_in) )) ;
      crc[1] <= crc[2];
      crc[0] <= crc[1];
    end
    
    if (!reset)
      crc_store <= 4'b0000;
    else if (bit_strobe)
      //     CRC_STORE <= CRC_STORE(2 downto 0) & DATA_IN
      crc_store <= {data_in , crc_store[3:1]};
    
    if (!reset)
      crcstate <= `cyc_state_enabled;
    else if (!var_rd2)
      crcstate <= in_crc_state;
    else if (crc_store == 4'b1111 && crc_compare_strobe && crcstate == `cyc_state_enabled
             )
      crcstate <= `cyc_state_seen_once;
    else if (crc_store == 4'b1111 && crc_compare_strobe && crcstate == `cyc_state_seen_once
             )
      crcstate <= `cyc_state_seen_twice;
    else if (crc_store == 4'b1111 && crc_compare_strobe && crcstate == `cyc_state_seen_twice
             )
      crcstate <= `cyc_state_disabled;
    else if (crc_store == 4'b1111 && crc_compare_strobe && crcstate == `cyc_state_disabled
             )
      crcstate <= `cyc_state_disabled;
    else if (crc_compare_strobe)
      crcstate <= `cyc_state_enabled;
    
  end
 
  always @(crcstate)
  begin
    if (crcstate == `cyc_state_enabled)
      crc_enabled <= 1'b1;
    else
      crc_enabled <= 1'b0;
    
  end
 
  always @(crc_strobe or crc_position or var_rd1 or crc_reset)
  begin
    if (crc_strobe && crc_position && !var_rd1)
      crc_compare_strobe <= 1'b1;
    else
      crc_compare_strobe <= 1'b0;
    
    if (crc_strobe && crc_position && crc_reset)
      crc_reset_strobe <= 1'b1;
    else
      crc_reset_strobe <= 1'b0;
    
  end
 
  always @(chan_id_sync or fswr_strobe or fsdat_strobe)
  begin
    if (chan_id_sync)
    begin
      fs_write <=  (~ (fswr_strobe)) ;
      fsdatenb_strobe <= fsdat_strobe;
    end
    else
    begin
      fs_write <= 1'b1;
      fsdatenb_strobe <= 1'b0;
    end
    
  end
 
  always @(chanid_store)
  begin
    case (chanid_store)
      5'b00000 : 
        channel_id <= 5'b00000;
      5'b00001 : 
        channel_id <= 5'b00000;
      5'b00010 : 
        channel_id <= 5'b00001;
      default  : 
        channel_id <= chanid_store;
    endcase
  
  end
 
  //  POINTER GENERTO
  //  Produces the row pointer to the most delaye
  //  channel
  //  Have deleted ADD00 to ADD12 because only the MS
  //  of the calculation is used
  //  Have deleted C013 as it is unused
  assign vcc = 1'b1;
  assign a = calculated_value;
  assign b = {frames , octet_count};
  assign add13 =  (a[13] ^  ( (~ (b[13]))  ^ co12) ) ;
  assign co00 =  ( (~ ( (a[0] &  (~ (b[0])) ) ))  ^  (~ ( (vcc & ( (a[0] ^  (~ (
            b[0])) ) )) )) ) ;
  assign co01 =  ( (~ ( (a[1] &  (~ (b[1])) ) ))  ^  (~ ( (co00 & ( (a[1] ^  (~ 
            (b[1])) ) )) )) ) ;
  assign co03 =  ( (~ ( (a[3] &  (~ (b[3])) ) ))  ^  (~ ( (co02 & ( (a[3] ^  (~ 
            (b[3])) ) )) )) ) ;
  assign co04 =  ( (~ ( (a[4] &  (~ (b[4])) ) ))  ^  (~ ( (co03 & ( (a[4] ^  (~ 
            (b[4])) ) )) )) ) ;
  assign co05 =  ( (~ ( (a[5] &  (~ (b[5])) ) ))  ^  (~ ( (co04 & ( (a[5] ^  (~ 
            (b[5])) ) )) )) ) ;
  assign co07 =  ( (~ ( (a[7] &  (~ (b[7])) ) ))  ^  (~ ( (co06 & ( (a[7] ^  (~ 
            (b[7])) ) )) )) ) ;
  assign co08 =  ( (~ ( (a[8] &  (~ (b[8])) ) ))  ^  (~ ( (co07 & ( (a[8] ^  (~ 
            (b[8])) ) )) )) ) ;
  assign co09 =  ( (~ ( (a[9] &  (~ (b[9])) ) ))  ^  (~ ( (co08 & ( (a[9] ^  (~ 
            (b[9])) ) )) )) ) ;
  assign co11 =  ( (~ ( (a[11] &  (~ (b[11])) ) ))  ^  (~ ( (co10 & ( (a[11] ^  (
            ~ (b[11])) ) )) )) ) ;
  assign co12 =  ( (~ ( (a[12] &  (~ (b[12])) ) ))  ^  (~ ( (co11 & ( (a[12] ^  (
            ~ (b[12])) ) )) )) ) ;
  always @( posedge (clock) )
  begin
    if (!reset)
    begin
      co02 <= 1'b0;
      co06 <= 1'b0;
      co10 <= 1'b0;
    end
    else
    begin
      co02 <=  ( (~ ( (a[2] &  (~ (b[2])) ) ))  ^  (~ ( (co01 & ( (a[2] ^  (~
                 (b[2])) ) )) )) ) ;
      co06 <=  ( (~ ( (a[6] &  (~ (b[6])) ) ))  ^  (~ ( (co05 & ( (a[6] ^  (~
                 (b[6])) ) )) )) ) ;
      co10 <=  ( (~ ( (a[10] &  (~ (b[10])) ) ))  ^  (~ ( (co09 & ( (a[10] ^ 
                 (~ (b[10])) ) )) )) ) ;
    end
    
    if (!reset)
      calculated_value <= 14'b00000000000000;
    else if (store_first_value)
      calculated_value <= {frames , octet_count};
    else if (octet_strobe)
      if ((!add13 && frame_sync_found) || (!add13 && ic_sync_found && !faw_sync_found
          ))
        calculated_value <= {frames , octet_count};
      else
        calculated_value <= calculated_value;
      
    
    if (!reset)
    begin
      one_shot <= 1'b0;
      stored_value <= 14'b00000000000000;
    end
    else if (up_date_pointer)
    begin
      one_shot <= 1'b0;
      stored_value <= calculated_value;
    end
    else if ((!var_rd3 && frame_sync_found) || (!var_rd3 && ic_sync_found && !faw_sync_found
             ))
    begin
      one_shot <= 1'b1;
      stored_value <= stored_value;
    end
    else
    begin
      one_shot <= one_shot;
      stored_value <= stored_value;
    end
    
    retime_one_shot <= one_shot;
    store_first_value <=  (one_shot &  (~ (retime_one_shot)) ) ;
  end
 
  reg [3:0] switch_36;
  always @(faw_position or crc_position or data_mode or chan_id_sync or frame_sync_found or crc_enabled or 
  crc_result or register_contents[1:0])
  begin
    switch_36 = {{{faw_position , crc_position} , data_mode} , frame_sync_found}
    ;
    case (switch_36)
      4'b1001 : 
      begin
        frame_store_datar[0] <= 1'b0;//frame_sync_found;
        frame_store_datar[1] <= chan_id_sync;
      end
      4'b0101 : 
      begin
        frame_store_datar[0] <= crc_result;
        frame_store_datar[1] <= crc_enabled;
      end
      4'b0010 : 
      begin
        frame_store_datar[0] <= register_contents[0];
        frame_store_datar[1] <= 1'b0; //register_contents[1];
      end
      4'b0011 : 
      begin
        frame_store_datar[0] <= register_contents[0];
        frame_store_datar[1] <= register_contents[1];
      end
      default  : 
      begin
        frame_store_datar[0] <= register_contents[0];
        frame_store_datar[1] <= register_contents[1];
      end
    endcase
  
  end
 
  always @( posedge (clock) )
  begin    
    if (!reset)
      master_channel <= 1'b0;
    else if (channel_id == 5'b00000)
      master_channel <= 1'b1;
    else
      master_channel <= 1'b0;
    
    if (!reset)
    begin
      master_cid_sync <= 1'b0;
      master_frame_sync <= 1'b0;
    end
    else if (octet_strobe && master_channel)
    begin
      master_cid_sync <= chan_id_sync;
      master_frame_sync <= frame_sync_found;
    end
    
  end
 
  always @( posedge (iom_dck) )
  begin    
    if (!reset)
      iombits <= 16'b0000000000000000;
    else if ((iom_sds1 || iom_sds2) && iom_enable)
      iombits <= {iombits[14:0] , iom_dd};
    
    if (!reset)
    begin
      iom_retime_one <= 1'b0;
      iom_retime_two <= 1'b0;
    end
    else
    begin
      iom_retime_one <= iom_sds2;
      iom_retime_two <=  (~ (iom_retime_one)) ;
    end
    
    if (iom_reset || !reset)
      iom_enable <= 1'b1;
    else
      iom_enable <=  (~ (iom_enable)) ;
    
  end
 
  always @( posedge (clock) )
  begin    
    if (!reset)
    begin
      retime_pre8m <= 1'b0;
      jitter_pulse <= 1'b0;
    end
    else
    begin
      retime_pre8m <=  (~ (pre8m)) ;
      jitter_pulse <=  (~ ( (retime_pre8m & pre8m) )) ;
    end
    
    if (!reset)
      jitter_reset <= 1'b0;
    else if (!jitter_pulse)
      jitter_reset <= iom_sds2;
    
    if (!reset)
    begin
      retime_fcsa <= 1'b0;
      retime_fcsb <= 1'b0;
      common_rst <= 1'b1;
    end
    else
    begin
      retime_fcsa <= jitter_reset;
      retime_fcsb <= retime_fcsa;
      common_rst <=  (~ ( ( (~ (retime_fcsa))  & retime_fcsb) )) ;
    end
    
  end
 
  always @(vcount or iom_pointer or data_clamp or iombits)
  begin
    case (vcount)
      10'b0000000000,10'b0000000001,10'b0000000010,10'b0000000011 : 
      begin
        iom_pointer <= 4'b0000;
        data_clamp <= 1'b0;
      end
      10'b0000000100,10'b0000000101,10'b0000000110,10'b0000000111 : 
      begin
        iom_pointer <= 4'b0001;
        data_clamp <= 1'b0;
      end
      10'b0000001000,10'b0000001001,10'b0000001010,10'b0000001011 : 
      begin
        iom_pointer <= 4'b0010;
        data_clamp <= 1'b0;
      end
      10'b0000001100,10'b0000001101,10'b0000001110,10'b0000001111 : 
      begin
        iom_pointer <= 4'b0011;
        data_clamp <= 1'b0;
      end
      10'b0000010000,10'b0000010001,10'b0000010010,10'b0000010011 : 
      begin
        iom_pointer <= 4'b0100;
        data_clamp <= 1'b0;
      end
      10'b0000010100,10'b0000010101,10'b0000010110,10'b0000010111 : 
      begin
        iom_pointer <= 4'b0101;
        data_clamp <= 1'b0;
      end
      10'b0000011000,10'b0000011001,10'b0000011010,10'b0000011011 : 
      begin
        iom_pointer <= 4'b0110;
        data_clamp <= 1'b0;
      end
      10'b0000011100,10'b0000011101,10'b0000011110,10'b0000011111 : 
      begin
        iom_pointer <= 4'b0111;
        data_clamp <= 1'b0;
      end
      10'b0000100000,10'b0000100001,10'b0000100010,10'b0000100011 : 
      begin
        iom_pointer <= 4'b1000;
        data_clamp <= 1'b0;
      end
      10'b0000100100,10'b0000100101,10'b0000100110,10'b0000100111 : 
      begin
        iom_pointer <= 4'b1001;
        data_clamp <= 1'b0;
      end
      10'b0000101000,10'b0000101001,10'b0000101010,10'b0000101011 : 
      begin
        iom_pointer <= 4'b1010;
        data_clamp <= 1'b0;
      end
      10'b0000101100,10'b0000101101,10'b0000101110,10'b0000101111 : 
      begin
        iom_pointer <= 4'b1011;
        data_clamp <= 1'b0;
      end
      10'b0000110000,10'b0000110001,10'b0000110010,10'b0000110011 : 
      begin
        iom_pointer <= 4'b1100;
        data_clamp <= 1'b0;
      end
      10'b0000110100,10'b0000110101,10'b0000110110,10'b0000110111 : 
      begin
        iom_pointer <= 4'b1101;
        data_clamp <= 1'b0;
      end
      10'b0000111000,10'b0000111001,10'b0000111010,10'b0000111011 : 
      begin
        iom_pointer <= 4'b1110;
        data_clamp <= 1'b0;
      end
      10'b0000111100,10'b0000111101,10'b0000111110,10'b0000111111 : 
      begin
        iom_pointer <= 4'b1111;
        data_clamp <= 1'b0;
      end
      default  : 
      begin
        iom_pointer <= 4'b0000;
        data_clamp <= 1'b1;
      end
    endcase
  
    if (!data_clamp)
      case (iom_pointer)
        4'b0000 : 
          data_in <= iombits[15];
        4'b0001 : 
          data_in <= iombits[14];
        4'b0010 : 
          data_in <= iombits[13];
        4'b0011 : 
          data_in <= iombits[12];
        4'b0100 : 
          data_in <= iombits[11];
        4'b0101 : 
          data_in <= iombits[10];
        4'b0110 : 
          data_in <= iombits[9];
        4'b0111 : 
          data_in <= iombits[8];
        4'b1000 : 
          data_in <= iombits[7];
        4'b1001 : 
          data_in <= iombits[6];
        4'b1010 : 
          data_in <= iombits[5];
        4'b1011 : 
          data_in <= iombits[4];
        4'b1100 : 
          data_in <= iombits[3];
        4'b1101 : 
          data_in <= iombits[2];
        4'b1110 : 
          data_in <= iombits[1];
        4'b1111 : 
          data_in <= iombits[0];
        default  : ;
      endcase
    
    else
      data_in <= 1'b1;
    
  end
 
  always @( posedge (clock) )
  begin
    if (!reset)
      group_id_state <= `persist_mac_states_search;
    else if (!var_rd3)
      group_id_state <= in_group_id_state;
    else if (octet_strobe)
      if (data_mode && group_id_state == `persist_mac_states_frozen)
        group_id_state <= `persist_mac_states_frozen;
      else if (faw_sync_found)
        if (ic_sync_found)
        begin
          if (ic_position && group_id_position)
            if (group_id_matched)
              case (group_id_state)
                `persist_mac_states_search : 
                  group_id_state <= `persist_mac_states_match;
                `persist_mac_states_match : 
                  group_id_state <= `persist_mac_states_found_twice;
                `persist_mac_states_found_twice : 
                  group_id_state <= `persist_mac_states_frozen;
                `persist_mac_states_frozen : 
                  group_id_state <= `persist_mac_states_frozen;
              endcase
            
            else
              case (group_id_state)
                `persist_mac_states_frozen : 
                  group_id_state <= `persist_mac_states_frozen;
                default  : 
                  group_id_state <= `persist_mac_states_search;
              endcase
            
            
          
        end
        else
          group_id_state <= `persist_mac_states_search;
        
      else
        if (ic_sync_found)
        begin
          if (group_id_position)
            if (group_id_matched)
              case (group_id_state)
                `persist_mac_states_search : 
                  group_id_state <= `persist_mac_states_match;
                `persist_mac_states_match : 
                  group_id_state <= `persist_mac_states_found_twice;
                `persist_mac_states_found_twice : 
                  group_id_state <= `persist_mac_states_frozen;
                `persist_mac_states_frozen : 
                  group_id_state <= `persist_mac_states_frozen;
              endcase
            
            else
              case (group_id_state)
                `persist_mac_states_frozen : 
                  group_id_state <= `persist_mac_states_frozen;
                default  : 
                  group_id_state <= `persist_mac_states_search;
              endcase
            
            
          
        end
        else
          group_id_state <= `persist_mac_states_search;
        
      
    
    case (group_id_state)
      `persist_mac_states_search,`persist_mac_states_match,`persist_mac_states_found_twice
       : 
        group_id_sync <= 1'b0;
      `persist_mac_states_frozen : 
        group_id_sync <= 1'b1;
    endcase
  
  end
 
  always @( posedge (clock) )
  begin
    if (!reset)
      group_err <= `gerror_noerror;
    else
      case (group_err)
        `gerror_noerror : 
          if (!common_rst)
            group_err <= `gerror_noerror;
          else if (octet_strobe && group_error)
            group_err <= `gerror_errora;
          else
            group_err <= `gerror_noerror;
          
        `gerror_errora : 
          if (!common_rst)
            group_err <= `gerror_errorb;
          else
            group_err <= `gerror_errora;
          
        `gerror_errorb : 
          if (!common_rst)
            group_err <= `gerror_noerror;
          else if (octet_strobe && group_error)
            group_err <= `gerror_errora;
          
      endcase
    
    
    if (group_id_sync)
      if ((group_id == group_store))
        group_error <= 1'b0;
      else
        group_error <= 1'b1;
      
    else
      group_error <= 1'b0;
    
    case (group_err)
      `gerror_noerror : 
        group_id_error <= 1'b0;
      `gerror_errora,`gerror_errorb : 
        group_id_error <= 1'b1;
    endcase
  
  end
 
  always @( posedge (clock) )
  begin
    //  Test for Group ID in Register
    if (!reset)
      group_id_matched <= 1'b0;
    else if (register_contents[6:1] == group_store)
      group_id_matched <= 1'b1;
    else
      group_id_matched <= 1'b0;
    
    //  If the state machine has not foun
    //  sync save the on-line value of group I
    if (!reset)
      group_store <= 6'b000000;
    else if (!var_rd1)
      group_store <= variable_restore[5:0];
    else if (!var_rd0 && !group_id_sync)
      if (faw_sync_found)
        if (ic_sync_found)
          if (ic_position && group_id_position)
            group_store <= register_contents[6:1];
          else
            group_store <= group_store;
          
        else
          group_store <= 6'b111111;
        
      else
        if (ic_sync_found)
          if (group_id_position)
            group_store <= register_contents[6:1];
          else
            group_store <= group_store;
          
        else
          group_store <= 6'b111111;
        
      
    else
      group_store <= group_store;
    
  end
 
  //  Signal Assignments (internal
  assign vcount = {vcountb , vcounta};
  assign delayed_column = dcolumn;
  assign in_ic_state = variable_restore[1:0];
  assign in_faw_state = variable_restore[6:4];
  assign octet_count = {ocountb , ocounta};
  assign ichan_count = icount;
  assign states_ichan = ichan_state;
  assign states_faw = faw_state;
  assign states_frame = frame_state;
  assign states_chan_id = chan_id_state;
  assign states_crc = crcstate;
  assign states_group = group_id_state;
  assign frames = {frcountb , frcounta};
  assign in_frame_state = variable_restore[5:4];
  assign in_chan_id_state = variable_restore[1:0];
  assign in_group_id_state = variable_restore[7:6];
  assign in_crc_state = variable_restore[7:6];
  assign iom_reset =  (iom_retime_one & iom_retime_two) ;
  //  Signal Assignments (external
  assign variable_address = {variable_column , variable_number};
  assign frame_store_data[0] = register_contents[7];
  assign frame_store_data[1] = register_contents[6];
  assign frame_store_data[2] = register_contents[5];
  assign frame_store_data[3] = register_contents[4];
  assign frame_store_data[4] = register_contents[3];
  assign frame_store_data[5] = register_contents[2];
  assign frame_store_data[6] = frame_store_datar[0];
  assign frame_store_data[7] = frame_store_datar[1];
  assign address_pointer = stored_value;
  assign fs_address = {{frames , octet_count} , channel_id};
  assign common_reset = common_rst;
  
endmodule 


