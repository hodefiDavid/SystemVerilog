
 
module mode_two_control (clock, reset, txc_128k, mode, bit_strobe,
			 slot_strobe, 
			 overhead, data_strobe, txc, strobe_126k, mode1_rxd, mode2_rxd
			 , rxd, strobe_128k, strobe_126kf);
  
  input clock;
  input reset;
  input txc_128k;
  input [1:0] mode;
  input bit_strobe;
  input slot_strobe;
  input overhead;
  output data_strobe;
  output txc;
  output strobe_126k;
  input mode1_rxd;
  input mode2_rxd;
  output rxd;
  input strobe_128k;
  output strobe_126kf;
  `define bonding_mode_zero      2'd0
  `define bonding_mode_one       2'd1
  `define bonding_mode_two       2'd2
  `define bonding_mode_three     2'd3
  wire strobe_126_edge;
 
  reg mode2_rxdr;
  reg txc_126kr;
  reg mode1_rxdr;
  reg txc_128kr;
  reg txc_126k;
  reg txc126b;
  reg txc126a;
  reg [5:0] second_stage;
  reg [6:0] first_stage;

  always @( posedge (clock) )
  begin
    
    if (!reset)
    begin
      first_stage <= 7'b0000000;
      second_stage <= 6'b000000;
      txc126a <= 1'b0;
      txc126b <= 1'b0;
      txc_126k <= 1'b0;
    end
    else
    begin
      first_stage <=  (first_stage + 6'b111111) ;
      second_stage <=  (second_stage + 
		   ( (first_stage[6] ^ second_stage[0]) )) ;
      txc126a <= second_stage[5];
      txc126b <=  (~ (txc126a)) ;
      txc_126k <=  (~ (second_stage[5])) ;
    end
    
    if (!reset) txc_128kr <= 1'b0;
    else if (strobe_128k) txc_128kr <= txc_128k;
    
    if (!reset)                        mode1_rxdr <= 1'b0;
    else if (strobe_128k && !txc_128k) mode1_rxdr <= mode1_rxd;
    
    if (!reset)
      txc_126kr <= 1'b0;
    else if (strobe_126_edge)
      txc_126kr <= txc_126k;
    
    if (!reset)
      mode2_rxdr <= 1'b0;
    else if (strobe_126_edge && txc_126kr)
      mode2_rxdr <= mode2_rxd;
    
  end
 
  assign strobe_126k =  (~ ( (txc126a | txc126b) )) ;
  assign strobe_126kf =  (strobe_126_edge & txc_126kr) ;
  assign strobe_126_edge =  (~ ( (txc126a ^ txc126b) )) ;
  assign txc = ((mode == `bonding_mode_zero || mode == 
	      `bonding_mode_one) ? txc_128kr : txc_126kr);
  assign rxd = ((mode == `bonding_mode_zero || mode == 
	      `bonding_mode_one) ? mode1_rxdr : mode2_rxdr);
  assign data_strobe =  (bit_strobe &  (slot_strobe &  (~ (overhead)) ) ) ;
endmodule 


