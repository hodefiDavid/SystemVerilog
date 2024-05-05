
--


-- VHDL entity and architecture file.

library ieee;
USE ieee.std_logic_1164.all;

ENTITY delta IS
   PORT (
      reset	: IN    std_logic;
      clock	: IN    std_logic;
      address	: IN    std_logic_vector(3 DOWNTO 0);
      pdata	: INOUT std_logic_vector(7 DOWNTO 0);
      rdb	: IN    std_logic;
      csb	: IN    std_logic;
      wrb	: IN    std_logic;
      crc_write	: OUT   std_logic;
      crc_read	: OUT   std_logic;
      crc_address	: OUT std_logic_vector(4 DOWNTO 0);
      crc	: INOUT std_logic_vector(3 DOWNTO 0);
      fifo_ram_data	: IN    std_logic_vector(7 DOWNTO 0);
      fifo_out_clock	: OUT   std_logic;
      fifo_full_indicate	: IN    std_logic;
      fifo_empty_indicate	: IN    std_logic;
      reset_fifo	: OUT   std_logic;
      micro_interrupt	: OUT   std_logic;
      txc	: OUT   std_logic;
      iom_sds1	: IN    std_logic;
      iom_sds2	: IN    std_logic;
      iom_dck	: IN    std_logic;
      iom_du	: OUT std_logic;
      iom_dd	: IN    std_logic;
      prescale_1m	: OUT   std_logic;
      prescale_8m	: OUT   std_logic;
      variable_address	: OUT   std_logic_vector(7 DOWNTO 0);
      variable_rdb	: OUT   std_logic;
      variable_wrb	: OUT   std_logic;
      variable_data	: INOUT std_logic_vector(7 DOWNTO 0);
      fs_data	: INOUT std_logic_vector(7 DOWNTO 0);
      fs_address	: OUT   std_logic_vector(18 DOWNTO 0);
      memcs	: IN    std_logic;
      amuxsel	: OUT   std_logic;
      fsoe	: OUT   std_logic;
      fswe	: OUT   std_logic;
      fsstr	: OUT   std_logic;
      fscs	: OUT   std_logic;
      srdy	: OUT   std_logic;
      cpfswe	: OUT   std_logic;
      cpfsrd	: OUT   std_logic;
      rxd	: OUT std_logic;
      txd	: IN std_logic
   );
END delta;

ARCHITECTURE RTL OF delta IS

component ARBITRATOR
  port (CLOCK: in STD_LOGIC;
        RESET: in STD_LOGIC;
        PRE_PROC_WR_REQUEST: in STD_LOGIC;
        POST_PROC_RD_REQUEST: in STD_LOGIC;
        CPU_WR: in STD_LOGIC;
        CPU_RD: in STD_LOGIC;
        MEMORY_CS: in STD_LOGIC;
        ADD_MUX_SEL: out STD_LOGIC;
        FRAME_STORE_OE: out STD_LOGIC;
        FRAME_STORE_WE: out STD_LOGIC;
        FRAME_STORE_STROBE: out STD_LOGIC;
        FRAME_STORE_CS: out STD_LOGIC;
        CPU_READY: out STD_LOGIC;
        CPU_FS_WE: out STD_LOGIC;
        CPU_FS_RD: out STD_LOGIC);
end component;
component FIFOCELL
  port (CLOCK: in STD_LOGIC;
        RESET: in STD_LOGIC;
        STATUS_IN: in STD_LOGIC;
        SHIFT_IN: out STD_LOGIC;
        SHIFT_OUT: in STD_LOGIC;
        STATUS_OUT: out STD_LOGIC;
        DIN: in STD_LOGIC;
        DOUT: out STD_LOGIC);
end component;
component FS_ADD_MUX
  port (A: in STD_LOGIC_VECTOR(18 downto 0);
        B: in STD_LOGIC_VECTOR(18 downto 0);
        SEL: in STD_LOGIC;
        SWITCH: out STD_LOGIC_VECTOR(18 downto 0));
end component;
component micro
   PORT (
      address	: IN    std_logic_vector(
   3 DOWNTO 0);
      data_in	: IN    std_logic_vector(7 DOWNTO 0);
      data_out	: OUT   std_logic_vector(7 DOWNTO 0);
      rd	: IN    std_logic;
      wr	: IN    std_logic;
      cs	: IN    
   std_logic;
      reset	: IN    std_logic;
      tri_state	: OUT   std_logic;
      crc_enable	: OUT   std_logic;
      test_mode	: OUT   std_logic;
      state_control	: OUT   std_logic_vector(1 DOWNTO 0);
      mode_control	: OUT   std_logic_vector(
   1 DOWNTO 0);
      fifo_reset	: OUT   std_logic;
      int_ack	: OUT   std_logic;
      chanenb	: OUT   std_logic_vector(4 DOWNTO 0);
      group_id	: OUT   std_logic_vector(
   5 DOWNTO 0);
      variable_rst	: OUT   std_logic;
      data_mode	: OUT   std_logic;
      clam_data	: OUT   std_logic;
      search	: OUT   std_logic;
      swap_channel	: OUT   std_logic;
      swap_byte	: OUT   std_logic;
      tx_pattern	: OUT   std_logic;
      gid_error	: IN    std_logic;
      in_sync	: IN    
   std_logic;
      emp_flag	: IN    std_logic;
      full_flag	: IN    std_logic;
      pointer	: IN    std_logic_vector(13 DOWNTO 0);
      master_cid_sync	: IN    std_logic;
      master_frame_sync	: IN    std_logic;
      nand_tree	: OUT   std_logic;
      crc_tri_state	: IN    
   std_logic;
      var_tri_state	: IN    std_logic;
      fs_tri_state	: IN    std_logic;
      open_collector	: IN    std_logic;
      fifo_test	: OUT   std_logic
   );
END component;
component PRE_PROCESSOR
  port (RESET: in STD_LOGIC;
        CLOCK: in STD_LOGIC;
        VARIABLE_ADDRESS: out STD_LOGIC_VECTOR(7 downto 0);
        VARIABLE_WRITE: out STD_LOGIC;
        VARIABLE_READ: out STD_LOGIC;
        VARIABLE_SAVE: out STD_LOGIC_VECTOR(7 downto 0);
        VARIABLE_RESTORE: in STD_LOGIC_VECTOR(7 downto 0);
        VARIABLE_RESET: in STD_LOGIC;
        DATA_MODE: in STD_LOGIC;
        FS_WRITE: out STD_LOGIC;
        FSDATENB_STROBE: out STD_LOGIC;
        FRAME_STORE_DATA: out STD_LOGIC_VECTOR(7 downto 0);
        IOM_DCK: in STD_LOGIC;
        IOM_SDS1: in STD_LOGIC;
        IOM_SDS2: in STD_LOGIC;
        ADDRESS_POINTER: out STD_LOGIC_VECTOR(13 downto 0);
        FS_ADDRESS: out STD_LOGIC_VECTOR(18 downto 0);
        IOM_DD: in STD_LOGIC;
        PRE8M: in STD_LOGIC;
        MASTER_CID_SYNC: out STD_LOGIC;
        MASTER_FRAME_SYNC: out STD_LOGIC;
        COMMON_RESET: out STD_LOGIC;
        TEST_MODE: in STD_LOGIC;
        GROUP_ID: in STD_LOGIC_VECTOR(5 downto 0);
        GROUP_ID_ERROR: out STD_LOGIC);
end component;
component mode_two_control
   PORT (
      clock	: IN    std_logic;
      reset	: IN    
   std_logic;
      txc_128k	: IN    std_logic;
      mode	: IN    std_logic_vector(1 DOWNTO 0);
      bit_strobe	: IN    std_logic;
      slot_strobe	: IN    std_logic;
      overhead	: IN    std_logic;
      data_strobe	: OUT   std_logic;
      txc	: OUT   
   std_logic;
      strobe_126k	: OUT   std_logic;
      mode1_rxd	: IN    std_logic;
      mode2_rxd	: IN    std_logic;
      rxd	: OUT   std_logic;
      strobe_128k	: IN    std_logic;
      strobe_126kf	: OUT   std_logic
   );
END component;
component TX_PROCESS
  port (RESET: in STD_LOGIC;
        CLOCK: in STD_LOGIC;
        CRC_WRITE: out STD_LOGIC;
        CRC_READ: out STD_LOGIC;
        VARIABLE_ADDRESS: out STD_LOGIC_VECTOR(4 downto 0);
        STATE_CONTROL: in STD_LOGIC_VECTOR(1 downto 0);
        MODE_CONTROL: in STD_LOGIC_VECTOR(1 downto 0);
        CHAN_ADD_BIT: in STD_LOGIC;
        CHANENB: in STD_LOGIC_VECTOR(4 downto 0);
        FIFO_RAM_DATA: in STD_LOGIC_VECTOR(7 downto 0);
        FIFO_FULL_INDICATE: in STD_LOGIC;
        FIFO_OUT_CLOCK: out STD_LOGIC;
        MICRO_INTERRUPT: out STD_LOGIC;
        CRC_IN: in STD_LOGIC_VECTOR(3 downto 0);
        CRC_OUT: out STD_LOGIC_VECTOR(3 downto 0);
        CRC_ENABLE: in STD_LOGIC;
        TXD: in STD_LOGIC;
        TXC: out STD_LOGIC;
        IOM_SDS1: in STD_LOGIC;
        IOM_SDS2: in STD_LOGIC;
        PRES1M: out STD_LOGIC;
        PRES8M: out STD_LOGIC;
        SWAP_CHAN: in STD_LOGIC;
        SWAP_BYTE: in STD_LOGIC;
        TX_PATTERN: in STD_LOGIC;
        IOM_DCK: in STD_LOGIC;
        IOM_DU: out STD_LOGIC;
        OPEN_COLLECTOR: out STD_LOGIC;
        NOT_CRC_READ: out STD_LOGIC;
        RESET_FIFO: in STD_LOGIC;
        FIFO_RESET: out STD_LOGIC;
        INT_ACK: in STD_LOGIC;
        DATA_STROBE: out STD_LOGIC;
        SLOT_WINDOW: out STD_LOGIC;
        OVERHEAD_OCTET: out STD_LOGIC;
        BUFFER_IN: in STD_LOGIC);

end component;
component POST_PROCESSOR
  port (CLOCK: in STD_LOGIC;
        RESET: in STD_LOGIC;
        POINTER: in STD_LOGIC_VECTOR(13 downto 0);
        FS_DATA: in STD_LOGIC_VECTOR(7 downto 0);
        FS_ADDR: out STD_LOGIC_VECTOR(18 downto 0);
        FS_READ: out STD_LOGIC;
        FS_MUX: out STD_LOGIC;
        COMMON_RST: in STD_LOGIC;
        RXD: out STD_LOGIC;
        DISABLE_SCRAM: in STD_LOGIC;
        IN_SYNC: out STD_LOGIC;
        TEST_MODE: in STD_LOGIC;
        BUFFER_SHIFT_IN: out STD_LOGIC;
        BUFFER_DATA_OUT: out STD_LOGIC; 
        TXC: in STD_LOGIC;
        STROBE_128K: out STD_LOGIC);
end component;
component bd4st
   PORT (
      a	: IN    std_logic;
      en	: IN    std_logic;
      tn	: IN    std_logic;
      pi	: IN    std_logic;
      io	: INOUT std_logic;
      zi	: OUT   std_logic;
      po	: OUT   std_logic
   );
END component;
--   for all: bt4r use entity WORK.bt4r(bt4r_ARCH);
--   for all: bd4st use entity WORK.bd4st(bd4st_ARCH);
--   for all: schmitt use entity WORK.schmitt(schmitt_ARCH);
--   for all: pre_processor use entity WORK.pre_processor(RTL);
--   for all: TX_PROCESS use entity WORK.TX_PROCESS(RTL);
--   for all: mode_two_control use entity WORK.mode_two_control(RTL);
for all: POST_PROCESSOR use entity WORK.POST_PROCESSOR(RTL);
--   for all: micro use entity WORK.micro(RTL);
--   for all: FS_ADD_MUX use entity WORK.FS_ADD_MUX(RTL);
--   for all: FIFOCELL use entity WORK.FIFOCELL(RTL);
for all: ARBITRATOR use entity WORK.ARBITRATOR(RTL);
         
SIGNAL micro_tri_state	: std_logic;
SIGNAL crc_enable	: std_logic;
SIGNAL test_mode	: std_logic;
SIGNAL state_control	: std_logic_vector(1 DOWNTO 0);
SIGNAL mode_control	: std_logic_vector(1 DOWNTO 0);
SIGNAL fifo_reset	: std_logic;
SIGNAL int_ack	: std_logic;
SIGNAL chanenb	: std_logic_vector(4 DOWNTO 0);
SIGNAL variable_rst	: std_logic;
SIGNAL data_mode	: std_logic;
SIGNAL clam_data	: std_logic;
SIGNAL search	: std_logic;
SIGNAL swap_channel	: std_logic;
SIGNAL swap_byte	: std_logic;
SIGNAL tx_pattern	: std_logic;
SIGNAL crc_tri_state	: std_logic;
SIGNAL in_sync	: std_logic;
SIGNAL pre_proc_wr_request	: std_logic;
SIGNAL fsdatenb_strobe	: std_logic;
SIGNAL master_cid_sync	: std_logic;
SIGNAL master_frame_sync	: std_logic;
SIGNAL address_pointer	: std_logic_vector(13 DOWNTO 0);
SIGNAL post_proc_rd_request	: std_logic;
SIGNAL fs_mux	: std_logic;
SIGNAL preproc_fs_addr	: std_logic_vector(18 DOWNTO 0);
SIGNAL postproc_fs_addr	: std_logic_vector(18 DOWNTO 0);
SIGNAL common_reset	: std_logic;
SIGNAL open_collector	: std_logic;
SIGNAL open_collector_nt	: std_logic;
SIGNAL group_id	: std_logic_vector(5 DOWNTO 0);
SIGNAL gid_error	: std_logic;
SIGNAL txstatus_in	: std_logic_vector(31 DOWNTO 0);
SIGNAL txstatus_out	: std_logic_vector(31 DOWNTO 0);
SIGNAL txshifto	: std_logic_vector(31 DOWNTO 0);
SIGNAL txshifti	: std_logic_vector(31 DOWNTO 0);
SIGNAL txdout	: std_logic_vector(31 DOWNTO 0);
SIGNAL txdin	: std_logic_vector(31 DOWNTO 0);
SIGNAL txc_128k	: std_logic;
SIGNAL tx_shift_out	: std_logic;
SIGNAL strobe_126k	: std_logic;
SIGNAL data_strobe	: std_logic;
SIGNAL slot_window	: std_logic;
SIGNAL overhead_octet	: std_logic;
SIGNAL buffer_shift_in	: std_logic;
SIGNAL buffer_data_out	: std_logic;
SIGNAL strobe_126kf	: std_logic;
SIGNAL rxstatus_in	: std_logic_vector(31 DOWNTO 0);
SIGNAL rxstatus_out	: std_logic_vector(31 DOWNTO 0);
SIGNAL rxshifto	: std_logic_vector(31 DOWNTO 0);
SIGNAL rxshifti	: std_logic_vector(31 DOWNTO 0);
SIGNAL rxdout	: std_logic_vector(31 DOWNTO 0);
SIGNAL rxdin	: std_logic_vector(31 DOWNTO 0);
SIGNAL prerxd	: std_logic;
SIGNAL post_rxd	: std_logic;
SIGNAL strobe_128k	: std_logic;
SIGNAL reseti	: std_logic;
SIGNAL clocki	: std_logic;
SIGNAL addressi	: std_logic_vector(3 DOWNTO 0);
SIGNAL datai	: std_logic_vector(7 DOWNTO 0);
SIGNAL datao	: std_logic_vector(7 DOWNTO 0);
SIGNAL rdbi	: std_logic;
SIGNAL csbi	: std_logic;
SIGNAL wrbi	: std_logic;
SIGNAL crc_writeo	: std_logic;
SIGNAL crc_reado	: std_logic;
SIGNAL crc_addresso	: std_logic_vector(4 DOWNTO 0);
SIGNAL crci	: std_logic_vector(3 DOWNTO 0);
SIGNAL crci_clamp	: std_logic_vector(3 DOWNTO 0);
SIGNAL crco	: std_logic_vector(3 DOWNTO 0);
SIGNAL crco_clamp	: std_logic_vector(3 DOWNTO 0);
SIGNAL fifo_ram_datai	: std_logic_vector(7 DOWNTO 0);
SIGNAL fifo_out_clocko	: std_logic;
SIGNAL fifo_full_indicatei	: std_logic;
SIGNAL fifo_empty_indicatei	: std_logic;
SIGNAL reset_fifoo	: std_logic;
SIGNAL txco	: std_logic;
SIGNAL iom_sds1i	: std_logic;
SIGNAL iom_sds2i	: std_logic;
SIGNAL iom_dcki	: std_logic;
SIGNAL iom_duo	: std_logic;
SIGNAL iom_ddi	: std_logic;
SIGNAL prescale_1mo	: std_logic;
SIGNAL prescale_8mo	: std_logic;
SIGNAL variable_addresso	: std_logic_vector(7 DOWNTO 0);
SIGNAL variable_rdbo	: std_logic;
SIGNAL variable_wrbo	: std_logic;
SIGNAL variable_datao	: std_logic_vector(7 DOWNTO 0);
SIGNAL variable_datai	: std_logic_vector(7 DOWNTO 0);
SIGNAL variable_restore	: std_logic_vector(7 DOWNTO 0);
SIGNAL fs_datai	: std_logic_vector(7 DOWNTO 0);
SIGNAL fs_datao	: std_logic_vector(7 DOWNTO 0);
SIGNAL fs_addresso	: std_logic_vector(18 DOWNTO 0);
SIGNAL memcsi	: std_logic;
SIGNAL amuxselo	: std_logic;
SIGNAL fsoeo	: std_logic;
SIGNAL fsweo	: std_logic;
SIGNAL fsstro	: std_logic;
SIGNAL fscso	: std_logic;
SIGNAL srdyo	: std_logic;
SIGNAL cpfsweo	: std_logic;
SIGNAL cpfsrdo	: std_logic;
SIGNAL rxdo	: std_logic;
SIGNAL txdi	: std_logic;
SIGNAL micro_interrupto	: std_logic;
SIGNAL ntree_enb	: std_logic;
SIGNAL ntree_enbn	: std_logic;
SIGNAL csb_nand_tree	: std_logic;
SIGNAL rdb_nand_tree	: std_logic;
SIGNAL wrb_nand_tree	: std_logic;
SIGNAL tree00	: std_logic;
SIGNAL tree01	: std_logic;
SIGNAL tree02	: std_logic;
SIGNAL tree03	: std_logic;
SIGNAL tree04	: std_logic;
SIGNAL tree05	: std_logic;
SIGNAL tree06	: std_logic;
SIGNAL tree07	: std_logic;
SIGNAL tree08	: std_logic;
SIGNAL tree09	: std_logic;
SIGNAL tree10	: std_logic;
SIGNAL tree11	: std_logic;
SIGNAL tree12	: std_logic;
SIGNAL tree13	: std_logic;
SIGNAL tree14	: std_logic;
SIGNAL tree15	: std_logic;
SIGNAL tree16	: std_logic;
SIGNAL tree17	: std_logic;
SIGNAL tree18	: std_logic;
SIGNAL tree19	: std_logic;
SIGNAL tree20	: std_logic;
SIGNAL tree21	: std_logic;
SIGNAL tree22	: std_logic;
SIGNAL tree23	: std_logic;
SIGNAL tree24	: std_logic;
SIGNAL tree25	: std_logic;
SIGNAL tree26	: std_logic;
SIGNAL tree27	: std_logic;
SIGNAL tree28	: std_logic;
SIGNAL tree29	: std_logic;
SIGNAL tree30	: std_logic;
SIGNAL tree31	: std_logic;
SIGNAL tree32	: std_logic;
SIGNAL tree33	: std_logic;
SIGNAL tree34	: std_logic;
SIGNAL tree35	: std_logic;
SIGNAL tree36	: std_logic;
SIGNAL tree37	: std_logic;
SIGNAL tree38	: std_logic;
SIGNAL tree39	: std_logic;
SIGNAL tree40	: std_logic;
SIGNAL tree41	: std_logic;
SIGNAL tree42	: std_logic;
SIGNAL tree43	: std_logic;
SIGNAL tree44	: std_logic;
SIGNAL tree45	: std_logic;
SIGNAL tree46	: std_logic;
SIGNAL tree47	: std_logic;
SIGNAL tree48	: std_logic;
SIGNAL tree49	: std_logic;
SIGNAL tree50	: std_logic;
SIGNAL tree51	: std_logic;
SIGNAL end_ntree	: std_logic;
SIGNAL end_ntreen	: std_logic;
SIGNAL vcc	: std_logic;
SIGNAL crc_wrb_nt	: std_logic;
SIGNAL crc_rdb_nt	: std_logic;
SIGNAL crc_add0_nt	: std_logic;
SIGNAL crc_add1_nt	: std_logic;
SIGNAL crc_add2_nt	: std_logic;
SIGNAL crc_add3_nt	: std_logic;
SIGNAL crc_add4_nt	: std_logic;
SIGNAL fifo_out_clk_nt	: std_logic;
SIGNAL reset_fifo_nt	: std_logic;
SIGNAL micro_inter_nt	: std_logic;
SIGNAL txco_nt	: std_logic;
SIGNAL iom_duo_nt	: std_logic;
SIGNAL prescale_1mo_nt	: std_logic;
SIGNAL prescale_8mo_nt	: std_logic;
SIGNAL variable_add0_nt	: std_logic;
SIGNAL variable_add1_nt	: std_logic;
SIGNAL variable_add2_nt	: std_logic;
SIGNAL variable_add3_nt	: std_logic;
SIGNAL variable_add4_nt	: std_logic;
SIGNAL variable_add5_nt	: std_logic;
SIGNAL variable_add6_nt	: std_logic;
SIGNAL variable_add7_nt	: std_logic;
SIGNAL variable_rdbo_nt	: std_logic;
SIGNAL variable_wrbo_nt	: std_logic;
SIGNAL fs_add0_nt	: std_logic;
SIGNAL fs_add1_nt	: std_logic;
SIGNAL fs_add2_nt	: std_logic;
SIGNAL fs_add3_nt	: std_logic;
SIGNAL fs_add4_nt	: std_logic;
SIGNAL fs_add5_nt	: std_logic;
SIGNAL fs_add6_nt	: std_logic;
SIGNAL fs_add7_nt	: std_logic;
SIGNAL fs_add8_nt	: std_logic;
SIGNAL fs_add9_nt	: std_logic;
SIGNAL fs_add10_nt	: std_logic;
SIGNAL fs_add11_nt	: std_logic;
SIGNAL fs_add12_nt	: std_logic;
SIGNAL fs_add13_nt	: std_logic;
SIGNAL fs_add14_nt	: std_logic;
SIGNAL fs_add15_nt	: std_logic;
SIGNAL fs_add16_nt	: std_logic;
SIGNAL fs_add17_nt	: std_logic;
SIGNAL fs_add18_nt	: std_logic;
SIGNAL amuxselo_nt	: std_logic;
SIGNAL fsoeo_nt	: std_logic;
SIGNAL fsweo_nt	: std_logic;
SIGNAL fsstro_nt	: std_logic;
SIGNAL fscso_nt	: std_logic;
SIGNAL srdyo_nt	: std_logic;
SIGNAL cpfsweo_nt	: std_logic;
SIGNAL cpfsrdo_nt	: std_logic;
SIGNAL rxdo_nt	: std_logic;
SIGNAL chip_tri_state	: std_logic;
SIGNAL rshift_in	: std_logic;
SIGNAL rshift_out	: std_logic;
SIGNAL rdata_in	: std_logic;
SIGNAL tshift_in	: std_logic;
SIGNAL tshift_out	: std_logic;
SIGNAL fifo_test	: std_logic;
SIGNAL fifocell_clock   : std_logic;
BEGIN

control_INST: micro
	PORT MAP (
   address => addressi,
   data_in => datai,
   data_out => datao,
   rd => rdbi,
   wr => wrbi,
   cs => csbi,
   reset => reseti,
   tri_state => micro_tri_state,
   crc_enable => crc_enable,
   test_mode => test_mode,
   state_control => state_control,
   mode_control => mode_control,
   fifo_reset => fifo_reset,
   int_ack => int_ack,
   chanenb => chanenb,
   group_id => group_id,
   variable_rst => variable_rst,
   data_mode => data_mode,
   clam_data => clam_data,
   search => search,
   swap_channel => swap_channel,
   swap_byte => swap_byte,
   tx_pattern => tx_pattern,
   gid_error => gid_error,
   in_sync => in_sync,
   emp_flag => fifo_empty_indicatei,
   full_flag => fifo_full_indicatei,
   pointer => address_pointer,
   master_cid_sync => master_cid_sync,
   master_frame_sync => master_frame_sync,
   nand_tree => ntree_enb,
   crc_tri_state => crc_tri_state,
   var_tri_state => variable_rdbo,
   fs_tri_state => fsdatenb_strobe,
   open_collector => open_collector,
   fifo_test => fifo_test
);

txproc_INST: tx_process
	PORT MAP (
   reset => reseti,
   clock => clocki,
   crc_write => crc_writeo,
   crc_read => crc_reado,
   variable_address => crc_addresso,
   state_control => state_control,
   mode_control => mode_control,
   chan_add_bit => test_mode,
   chanenb => chanenb,
   fifo_ram_data => fifo_ram_datai,
   fifo_full_indicate => fifo_full_indicatei,
   fifo_out_clock => fifo_out_clocko,
   micro_interrupt => micro_interrupto,
   crc_in => crci_clamp,
   crc_out => crco_clamp,
   crc_enable => crc_enable,
   txd => txdi,
   txc => txc_128k,
   iom_sds1 => iom_sds1i,
   iom_sds2 => iom_sds2i,
   pres1m => prescale_1mo,
   pres8m => prescale_8mo,
   swap_chan => swap_channel,
   swap_byte => swap_byte,
   tx_pattern => tx_pattern,
   iom_dck => iom_dcki,
   iom_du => iom_duo,
   open_collector => open_collector,
   not_crc_read => crc_tri_state,
   reset_fifo => fifo_reset,
   fifo_reset => reset_fifoo,
   int_ack => int_ack,
   data_strobe => data_strobe,
   slot_window => slot_window,
   overhead_octet => overhead_octet,
   buffer_in => txdout(31)
);

preproc_INST: pre_processor
	PORT MAP (
   reset => reseti,
   clock => clocki,
   variable_address => variable_addresso,
   variable_write => variable_wrbo,
   variable_read => variable_rdbo,
   variable_save => variable_datao,
   variable_restore => variable_restore,
   variable_reset => variable_rst,
   data_mode => data_mode,
   fs_write => pre_proc_wr_request,
   fsdatenb_strobe => fsdatenb_strobe,
   frame_store_data => fs_datao,
   iom_dck => iom_dcki,
   iom_sds1 => iom_sds1i,
   iom_sds2 => iom_sds2i,
   address_pointer => address_pointer,
   fs_address => preproc_fs_addr,
   iom_dd => iom_ddi,
   pre8m => prescale_8mo,
   master_cid_sync => master_cid_sync,
   master_frame_sync => master_frame_sync,
   common_reset => common_reset,
   test_mode => test_mode,
   group_id => group_id,
   group_id_error => gid_error
);

postproc_INST: post_processor
	PORT MAP (
   clock => clocki,
   reset => reseti,
   pointer => address_pointer,
   fs_data => fs_datai,
   fs_addr => postproc_fs_addr,
   fs_read => post_proc_rd_request,
   fs_mux => fs_mux,
   common_rst => common_reset,
   rxd => post_rxd,
   disable_scram => search,
   in_sync => in_sync,
   test_mode => test_mode,
   buffer_shift_in => buffer_shift_in,
   buffer_data_out => buffer_data_out,
   txc => txco,
   strobe_128k => strobe_128k
);

fsarb_INST: arbitrator
	PORT MAP (
   clock => clocki,
   reset => reseti,
   pre_proc_wr_request => pre_proc_wr_request,
   post_proc_rd_request => post_proc_rd_request,
   cpu_wr => wrbi,
   cpu_rd => rdbi,
   memory_cs => memcsi,
   add_mux_sel => amuxselo,
   frame_store_oe => fsoeo,
   frame_store_we => fsweo,
   frame_store_strobe => fsstro,
   frame_store_cs => fscso,
   cpu_ready => srdyo,
   cpu_fs_we => cpfsweo,
   cpu_fs_rd => cpfsrdo
);

fsaddmux_INST: fs_add_mux
	PORT MAP (
   a => postproc_fs_addr,
   b => preproc_fs_addr,
   sel => fs_mux,
   switch => fs_addresso
);

control_126k_INST: mode_two_control
	PORT MAP (
   clock => clocki,
   reset => reseti,
   txc_128k => txc_128k,
   mode => mode_control,
   bit_strobe => data_strobe,
   slot_strobe => slot_window,
   overhead => overhead_octet,
   data_strobe => tx_shift_out,
   txc => txco,
   strobe_126k => strobe_126k,
   mode1_rxd => post_rxd,
   mode2_rxd => rxdout(31),
   rxd => prerxd,
   strobe_128k => strobe_128k,
   strobe_126kf => strobe_126kf
);

fifocell_clock <= '1' when mode_control(1) = '0' else CLOCKI;

CELLTX0: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(0),
  SHIFT_IN => TXSHIFTI(0),
  SHIFT_OUT => TXSHIFTO(0),
  STATUS_OUT => TXSTATUS_OUT(0),
  DIN => TXDIN(0),
  DOUT => TXDOUT(0) );

CELLTX1: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(1),
  SHIFT_IN => TXSHIFTI(1),
  SHIFT_OUT => TXSHIFTO(1),
  STATUS_OUT => TXSTATUS_OUT(1),
  DIN => TXDIN(1),
  DOUT => TXDOUT(1) );

CELLTX2: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(2),
  SHIFT_IN => TXSHIFTI(2),
  SHIFT_OUT => TXSHIFTO(2),
  STATUS_OUT => TXSTATUS_OUT(2),
  DIN => TXDIN(2),
  DOUT => TXDOUT(2) );

CELLTX3: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(3),
  SHIFT_IN => TXSHIFTI(3),
  SHIFT_OUT => TXSHIFTO(3),
  STATUS_OUT => TXSTATUS_OUT(3),
  DIN => TXDIN(3),
  DOUT => TXDOUT(3) );

CELLTX4: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(4),
  SHIFT_IN => TXSHIFTI(4),
  SHIFT_OUT => TXSHIFTO(4),
  STATUS_OUT => TXSTATUS_OUT(4),
  DIN => TXDIN(4),
  DOUT => TXDOUT(4) );

CELLTX5: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(5),
  SHIFT_IN => TXSHIFTI(5),
  SHIFT_OUT => TXSHIFTO(5),
  STATUS_OUT => TXSTATUS_OUT(5),
  DIN => TXDIN(5),
  DOUT => TXDOUT(5) );

CELLTX6: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(6),
  SHIFT_IN => TXSHIFTI(6),
  SHIFT_OUT => TXSHIFTO(6),
  STATUS_OUT => TXSTATUS_OUT(6),
  DIN => TXDIN(6),
  DOUT => TXDOUT(6) );

CELLTX7: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(7),
  SHIFT_IN => TXSHIFTI(7),
  SHIFT_OUT => TXSHIFTO(7),
  STATUS_OUT => TXSTATUS_OUT(7),
  DIN => TXDIN(7),
  DOUT => TXDOUT(7) );

CELLTX8: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(8),
  SHIFT_IN => TXSHIFTI(8),
  SHIFT_OUT => TXSHIFTO(8),
  STATUS_OUT => TXSTATUS_OUT(8),
  DIN => TXDIN(8),
  DOUT => TXDOUT(8) );

CELLTX9: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(9),
  SHIFT_IN => TXSHIFTI(9),
  SHIFT_OUT => TXSHIFTO(9),
  STATUS_OUT => TXSTATUS_OUT(9),
  DIN => TXDIN(9),
  DOUT => TXDOUT(9) );

CELLTX10: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(10),
  SHIFT_IN => TXSHIFTI(10),
  SHIFT_OUT => TXSHIFTO(10),
  STATUS_OUT => TXSTATUS_OUT(10),
  DIN => TXDIN(10),
  DOUT => TXDOUT(10) );

CELLTX11: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(11),
  SHIFT_IN => TXSHIFTI(11),
  SHIFT_OUT => TXSHIFTO(11),
  STATUS_OUT => TXSTATUS_OUT(11),
  DIN => TXDIN(11),
  DOUT => TXDOUT(11) );

CELLTX12: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(12),
  SHIFT_IN => TXSHIFTI(12),
  SHIFT_OUT => TXSHIFTO(12),
  STATUS_OUT => TXSTATUS_OUT(12),
  DIN => TXDIN(12),
  DOUT => TXDOUT(12) );

CELLTX13: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(13),
  SHIFT_IN => TXSHIFTI(13),
  SHIFT_OUT => TXSHIFTO(13),
  STATUS_OUT => TXSTATUS_OUT(13),
  DIN => TXDIN(13), 
  DOUT => TXDOUT(13) );

CELLTX14: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(14),
  SHIFT_IN => TXSHIFTI(14),
  SHIFT_OUT => TXSHIFTO(14),
  STATUS_OUT => TXSTATUS_OUT(14),
  DIN => TXDIN(14),
  DOUT => TXDOUT(14) );

CELLTX15: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(15),
  SHIFT_IN => TXSHIFTI(15),
  SHIFT_OUT => TXSHIFTO(15),
  STATUS_OUT => TXSTATUS_OUT(15),
  DIN => TXDIN(15),
  DOUT => TXDOUT(15) );

CELLTX16: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(16),
  SHIFT_IN => TXSHIFTI(16),
  SHIFT_OUT => TXSHIFTO(16),
  STATUS_OUT => TXSTATUS_OUT(16),
  DIN => TXDIN(16),
  DOUT => TXDOUT(16) );

CELLTX17: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(17),
  SHIFT_IN => TXSHIFTI(17),
  SHIFT_OUT => TXSHIFTO(17),
  STATUS_OUT => TXSTATUS_OUT(17),
  DIN => TXDIN(17),
  DOUT => TXDOUT(17) );

CELLTX18: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(18),
  SHIFT_IN => TXSHIFTI(18),
  SHIFT_OUT => TXSHIFTO(18),
  STATUS_OUT => TXSTATUS_OUT(18),
  DIN => TXDIN(18),
  DOUT => TXDOUT(18) );

CELLTX19: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(19),
  SHIFT_IN => TXSHIFTI(19),
  SHIFT_OUT => TXSHIFTO(19),
  STATUS_OUT => TXSTATUS_OUT(19),
  DIN => TXDIN(19),
  DOUT => TXDOUT(19) );

CELLTX20: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(20),
  SHIFT_IN => TXSHIFTI(20),
  SHIFT_OUT => TXSHIFTO(20),
  STATUS_OUT => TXSTATUS_OUT(20),
  DIN => TXDIN(20),
  DOUT => TXDOUT(20) );

CELLTX21: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(21),
  SHIFT_IN => TXSHIFTI(21),
  SHIFT_OUT => TXSHIFTO(21),
  STATUS_OUT => TXSTATUS_OUT(21),
  DIN => TXDIN(21),
  DOUT => TXDOUT(21) );

CELLTX22: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(22),
  SHIFT_IN => TXSHIFTI(22),
  SHIFT_OUT => TXSHIFTO(22),
  STATUS_OUT => TXSTATUS_OUT(22),
  DIN => TXDIN(22),
  DOUT => TXDOUT(22) );

CELLTX23: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(23),
  SHIFT_IN => TXSHIFTI(23),
  SHIFT_OUT => TXSHIFTO(23),
  STATUS_OUT => TXSTATUS_OUT(23),
  DIN => TXDIN(23),
  DOUT => TXDOUT(23) );

CELLTX24: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(24),
  SHIFT_IN => TXSHIFTI(24),
  SHIFT_OUT => TXSHIFTO(24),
  STATUS_OUT => TXSTATUS_OUT(24),
  DIN => TXDIN(24),
  DOUT => TXDOUT(24) );

CELLTX25: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(25),
  SHIFT_IN => TXSHIFTI(25),
  SHIFT_OUT => TXSHIFTO(25),
  STATUS_OUT => TXSTATUS_OUT(25),
  DIN => TXDIN(25),
  DOUT => TXDOUT(25) );

CELLTX26: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(26),
  SHIFT_IN => TXSHIFTI(26),
  SHIFT_OUT => TXSHIFTO(26),
  STATUS_OUT => TXSTATUS_OUT(26),
  DIN => TXDIN(26),
  DOUT => TXDOUT(26) );

CELLTX27: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(27),
  SHIFT_IN => TXSHIFTI(27),
  SHIFT_OUT => TXSHIFTO(27),
  STATUS_OUT => TXSTATUS_OUT(27),
  DIN => TXDIN(27),
  DOUT => TXDOUT(27) );

CELLTX28: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(28),
  SHIFT_IN => TXSHIFTI(28),
  SHIFT_OUT => TXSHIFTO(28),
  STATUS_OUT => TXSTATUS_OUT(28),
  DIN => TXDIN(28),
  DOUT => TXDOUT(28) );

CELLTX29: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(29),
  SHIFT_IN => TXSHIFTI(29),
  SHIFT_OUT => TXSHIFTO(29),
  STATUS_OUT => TXSTATUS_OUT(29),
  DIN => TXDIN(29),
  DOUT => TXDOUT(29) );

CELLTX30: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(30),
  SHIFT_IN => TXSHIFTI(30),
  SHIFT_OUT => TXSHIFTO(30),
  STATUS_OUT => TXSTATUS_OUT(30),
  DIN => TXDIN(30),
  DOUT => TXDOUT(30) );

CELLTX31: FIFOCELL
port map (CLOCK => fifocell_clock,
  RESET => RESETI,
  STATUS_IN => TXSTATUS_IN(31),
  SHIFT_IN => TXSHIFTI(31),
  SHIFT_OUT => TXSHIFTO(31),
  STATUS_OUT => TXSTATUS_OUT(31),
  DIN => TXDIN(31),
  DOUT => TXDOUT(31) );

GENER_RXFIFO: for I in 0 to 31 generate
  CELLRX: FIFOCELL
  port map (CLOCK => fifocell_clock,
            RESET => RESETI,
            STATUS_IN => RXSTATUS_IN(I),
            SHIFT_IN => RXSHIFTI(I),
            SHIFT_OUT => RXSHIFTO(I),
            STATUS_OUT => RXSTATUS_OUT(I),
            DIN => RXDIN(I),
            DOUT => RXDOUT(I) );
end generate GENER_RXFIFO;

-- coverage off
rshift_in	 <= (buffer_shift_in AND NOT fifo_test) OR (fifo_ram_datai(2) AND fifo_test)
   ;
rshift_out	 <= (strobe_126kf AND NOT fifo_test) OR (fifo_ram_datai(3) AND fifo_test)
   ;
rdata_in	 <= (buffer_data_out AND NOT fifo_test) OR (fifo_ram_datai(3) AND fifo_test)
   ;
rxdo	 <= prerxd OR NOT clam_data;
rxstatus_in	 <= rxstatus_out(30 DOWNTO 0) & rshift_in;
rxshifto	 <= rshift_out & rxshifti(31 DOWNTO 1);
rxdin	 <= rxdout(30 DOWNTO 0) & rdata_in;
tshift_in	 <= (strobe_126k AND NOT fifo_test) OR (fifo_ram_datai(0) AND fifo_test)
   ;
tshift_out	 <= (tx_shift_out AND NOT fifo_test) OR (fifo_ram_datai(1) AND fifo_test)
   ;
txstatus_in	 <= txstatus_out(30 DOWNTO 0) & tshift_in;
txshifto	 <= tx_shift_out & txshifti(31 DOWNTO 1);
txdin	 <= txdout(30 DOWNTO 0) & txdi;
end_ntreen	 <= NOT end_ntree;
rdbi	 <= rdb_nand_tree OR ntree_enb;
wrbi	 <= wrb_nand_tree OR ntree_enb;
csbi	 <= csb_nand_tree OR ntree_enb;
open_collector_nt	 <= open_collector OR ntree_enb;
crc_wrb_nt	 <= (crc_writeo AND NOT ntree_enb) OR (end_ntreen AND ntree_enb);
crc_rdb_nt	 <= (crc_reado AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
crc_add0_nt	 <= (crc_addresso(0) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb)
   ;
crc_add1_nt	 <= (crc_addresso(1) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb)
   ;
crc_add2_nt	 <= (crc_addresso(2) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb)
   ;
crc_add3_nt	 <= (crc_addresso(3) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb)
   ;
crc_add4_nt	 <= (crc_addresso(4) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb)
   ;
fifo_out_clk_nt	 <= (fifo_out_clocko AND NOT ntree_enb) OR (end_ntree AND ntree_enb)
   ;
reset_fifo_nt	 <= (reset_fifoo AND NOT ntree_enb) OR (end_ntreen AND ntree_enb);
micro_inter_nt	 <= (micro_interrupto AND NOT ntree_enb) OR (end_ntree AND ntree_enb)
   ;
txco_nt	 <= (txco AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
iom_duo_nt	 <= (iom_duo AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
prescale_1mo_nt	 <= (prescale_1mo AND NOT ntree_enb) OR (end_ntree AND ntree_enb)
   ;
prescale_8mo_nt	 <= (prescale_8mo AND NOT ntree_enb) OR (end_ntree AND ntree_enb)
   ;
variable_add0_nt	 <= (variable_addresso(0) AND NOT ntree_enb) OR (end_ntreen AND 
   ntree_enb);
variable_add1_nt	 <= (variable_addresso(1) AND NOT ntree_enb) OR (end_ntreen AND 
   ntree_enb);
variable_add2_nt	 <= (variable_addresso(2) AND NOT ntree_enb) OR (end_ntreen AND 
   ntree_enb);
variable_add3_nt	 <= (variable_addresso(3) AND NOT ntree_enb) OR (end_ntree AND 
   ntree_enb);
variable_add4_nt	 <= (variable_addresso(4) AND NOT ntree_enb) OR (end_ntreen AND 
   ntree_enb);
variable_add5_nt	 <= (variable_addresso(5) AND NOT ntree_enb) OR (end_ntree AND 
   ntree_enb);
variable_add6_nt	 <= (variable_addresso(6) AND NOT ntree_enb) OR (end_ntree AND 
   ntree_enb);
variable_add7_nt	 <= (variable_addresso(7) AND NOT ntree_enb) OR (end_ntree AND 
   ntree_enb);
variable_rdbo_nt	 <= (variable_rdbo AND NOT ntree_enb) OR (end_ntree AND ntree_enb)
   ;
variable_wrbo_nt	 <= (variable_wrbo AND NOT ntree_enb) OR (end_ntree AND ntree_enb)
   ;
fs_add0_nt	 <= (fs_addresso(0) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb);
fs_add1_nt	 <= (fs_addresso(1) AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
fs_add2_nt	 <= (fs_addresso(2) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb);
fs_add3_nt	 <= (fs_addresso(3) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb);
fs_add4_nt	 <= (fs_addresso(4) AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
fs_add5_nt	 <= (fs_addresso(5) AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
fs_add6_nt	 <= (fs_addresso(6) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb);
fs_add7_nt	 <= (fs_addresso(7) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb);
fs_add8_nt	 <= (fs_addresso(8) AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
fs_add9_nt	 <= (fs_addresso(9) AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
fs_add10_nt	 <= (fs_addresso(10) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb)
   ;
fs_add11_nt	 <= (fs_addresso(11) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb)
   ;
fs_add12_nt	 <= (fs_addresso(12) AND NOT ntree_enb) OR (end_ntree AND ntree_enb)
   ;
fs_add13_nt	 <= (fs_addresso(13) AND NOT ntree_enb) OR (end_ntree AND ntree_enb)
   ;
fs_add14_nt	 <= (fs_addresso(14) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb)
   ;
fs_add15_nt	 <= (fs_addresso(15) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb)
   ;
fs_add16_nt	 <= (fs_addresso(16) AND NOT ntree_enb) OR (end_ntreen AND ntree_enb)
   ;
fs_add17_nt	 <= (fs_addresso(17) AND NOT ntree_enb) OR (end_ntree AND ntree_enb)
   ;
fs_add18_nt	 <= (fs_addresso(18) AND NOT ntree_enb) OR (end_ntree AND ntree_enb)
   ;
amuxselo_nt	 <= (amuxselo AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
fsoeo_nt	 <= (fsoeo AND NOT ntree_enb) OR (end_ntreen AND ntree_enb);
fsweo_nt	 <= (fsweo AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
fsstro_nt	 <= (fsstro AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
fscso_nt	 <= (fscso AND NOT ntree_enb) OR (end_ntreen AND ntree_enb);
srdyo_nt	 <= (srdyo AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
cpfsweo_nt	 <= (cpfsweo AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
cpfsrdo_nt	 <= (cpfsrdo AND NOT ntree_enb) OR (end_ntreen AND ntree_enb);
rxdo_nt	 <= (rxdo AND NOT ntree_enb) OR (end_ntree AND ntree_enb);
crco(0)	 <= crco_clamp(0) AND NOT variable_rst;
crco(1)	 <= crco_clamp(1) AND NOT variable_rst;
crco(2)	 <= crco_clamp(2) AND NOT variable_rst;
crco(3)	 <= crco_clamp(3) AND NOT variable_rst;
crci_clamp(0)	 <= crci(0) AND NOT variable_rst;
crci_clamp(1)	 <= crci(1) AND NOT variable_rst;
crci_clamp(2)	 <= crci(2) AND NOT variable_rst;
crci_clamp(3)	 <= crci(3) AND NOT variable_rst;
variable_restore(0)	 <= variable_datai(0) AND NOT variable_rst;
variable_restore(1)	 <= variable_datai(1) AND NOT variable_rst;
variable_restore(2)	 <= variable_datai(2) AND NOT variable_rst;
variable_restore(3)	 <= variable_datai(3) AND NOT variable_rst;
variable_restore(4)	 <= variable_datai(4) AND NOT variable_rst;
variable_restore(5)	 <= variable_datai(5) AND NOT variable_rst;
variable_restore(6)	 <= variable_datai(6) AND NOT variable_rst;
variable_restore(7)	 <= variable_datai(7) AND NOT variable_rst;
ntree_enbn	 <= reset AND NOT ntree_enb;
chip_tri_state	 <= NOT reset;
vcc	 <= '1';
in01_INST: reseti <= reset; tree00 <= NOT (reset AND vcc);
in02_INST: clocki <= clock; tree01 <= NOT (clock AND reseti);
in03_INST: addressi(0) <= address(0); tree02 <= NOT (address(0) AND tree01);
in04_INST: addressi(1) <= address(1); tree03 <= NOT (address(1) AND tree02);
in05_INST: addressi(2) <= address(2); tree04 <= NOT (address(2) AND tree03);
in06_INST: addressi(3) <= address(3); tree05 <= NOT (address(3) AND tree04);
in07_INST: rdb_nand_tree <= rdb; tree06 <= NOT (rdb AND tree05);
in08_INST: csb_nand_tree <= csb; tree07 <= NOT (csb AND tree06);
in09_INST: wrb_nand_tree <= wrb; tree08 <= NOT (wrb AND tree07);
in10_INST: fifo_ram_datai(0) <= fifo_ram_data(0); tree09 <= NOT (fifo_ram_data(0) AND tree08);
in11_INST: fifo_ram_datai(1) <= fifo_ram_data(1); tree10 <= NOT (fifo_ram_data(1) AND tree09);
in12_INST: fifo_ram_datai(2) <= fifo_ram_data(2); tree11 <= NOT (fifo_ram_data(2) AND tree10);
in13_INST: fifo_ram_datai(3) <= fifo_ram_data(3); tree12 <= NOT (fifo_ram_data(3) AND tree11);
in14_INST: fifo_ram_datai(4) <= fifo_ram_data(4); tree13 <= NOT (fifo_ram_data(4) AND tree12);
in15_INST: fifo_ram_datai(5) <= fifo_ram_data(5); tree14 <= NOT (fifo_ram_data(5) AND tree13);
in16_INST: fifo_ram_datai(6) <= fifo_ram_data(6); tree15 <= NOT (fifo_ram_data(6) AND tree14);
in17_INST: fifo_ram_datai(7) <= fifo_ram_data(7); tree16 <= NOT (fifo_ram_data(7) AND tree15);
in18_INST: fifo_full_indicatei <= fifo_full_indicate; tree17 <= NOT (fifo_full_indicate AND tree16);
in19_INST: fifo_empty_indicatei <= fifo_empty_indicate; tree18 <= NOT (fifo_empty_indicate AND tree17);
in20_INST: iom_sds1i <= iom_sds1; tree19 <= NOT (iom_sds1 AND tree18);
in21_INST: iom_sds2i <= iom_sds2; tree20 <= NOT (iom_sds2 AND tree19);
in22_INST: iom_dcki <= iom_dck; tree21 <= NOT (iom_dck AND tree20);
in23_INST: iom_ddi <= iom_dd; tree22 <= NOT (iom_dd AND tree21);
in24_INST: memcsi <= memcs; tree23 <= NOT (memcs AND tree22);
in25_INST: txdi <= txd; tree24 <= NOT (txd AND tree23);
-- coverage on
bid01_INST: bd4st
	PORT MAP (
   a => datao(0),
   en => chip_tri_state,
   tn => micro_tri_state,
   pi => tree24,
   io => pdata(0),
   zi => datai(0),
   po => tree25
);

bid02_INST: bd4st
	PORT MAP (
   a => datao(1),
   en => chip_tri_state,
   tn => micro_tri_state,
   pi => tree25,
   io => pdata(1),
   zi => datai(1),
   po => tree26
);

bid03_INST: bd4st
	PORT MAP (
   a => datao(2),
   en => chip_tri_state,
   tn => micro_tri_state,
   pi => tree26,
   io => pdata(2),
   zi => datai(2),
   po => tree27
);

bid04_INST: bd4st
	PORT MAP (
   a => datao(3),
   en => chip_tri_state,
   tn => micro_tri_state,
   pi => tree27,
   io => pdata(3),
   zi => datai(3),
   po => tree28
);

bid05_INST: bd4st
	PORT MAP (
   a => datao(4),
   en => chip_tri_state,
   tn => micro_tri_state,
   pi => tree28,
   io => pdata(4),
   zi => datai(4),
   po => tree29
);

bid06_INST: bd4st
	PORT MAP (
   a => datao(5),
   en => chip_tri_state,
   tn => micro_tri_state,
   pi => tree29,
   io => pdata(5),
   zi => datai(5),
   po => tree30
);

bid07_INST: bd4st
	PORT MAP (
   a => datao(6),
   en => chip_tri_state,
   tn => micro_tri_state,
   pi => tree30,
   io => pdata(6),
   zi => datai(6),
   po => tree31
);

bid08_INST: bd4st
	PORT MAP (
   a => datao(7),
   en => chip_tri_state,
   tn => micro_tri_state,
   pi => tree31,
   io => pdata(7),
   zi => datai(7),
   po => tree32
);

bid09_INST: bd4st
	PORT MAP (
   a => crco(0),
   en => crc_tri_state,
   tn => ntree_enbn,
   pi => tree32,
   io => crc(0),
   zi => crci(0),
   po => tree33
);

bid10_INST: bd4st
	PORT MAP (
   a => crco(1),
   en => crc_tri_state,
   tn => ntree_enbn,
   pi => tree33,
   io => crc(1),
   zi => crci(1),
   po => tree34
);

bid11_INST: bd4st
	PORT MAP (
   a => crco(2),
   en => crc_tri_state,
   tn => ntree_enbn,
   pi => tree34,
   io => crc(2),
   zi => crci(2),
   po => tree35
);

bid12_INST: bd4st
	PORT MAP (
   a => crco(3),
   en => crc_tri_state,
   tn => ntree_enbn,
   pi => tree35,
   io => crc(3),
   zi => crci(3),
   po => tree36
);

bid13_INST: bd4st
	PORT MAP (
   a => variable_datao(0),
   en => chip_tri_state,
   tn => variable_rdbo,
   pi => tree36,
   io => variable_data(0),
   zi => variable_datai(0),
   po => tree37
);

bid14_INST: bd4st
	PORT MAP (
   a => variable_datao(1),
   en => chip_tri_state,
   tn => variable_rdbo,
   pi => tree37,
   io => variable_data(1),
   zi => variable_datai(1),
   po => tree38
);

bid15_INST: bd4st
	PORT MAP (
   a => variable_datao(2),
   en => chip_tri_state,
   tn => variable_rdbo,
   pi => tree38,
   io => variable_data(2),
   zi => variable_datai(2),
   po => tree39
);

bid16_INST: bd4st
	PORT MAP (
   a => variable_datao(3),
   en => chip_tri_state,
   tn => variable_rdbo,
   pi => tree39,
   io => variable_data(3),
   zi => variable_datai(3),
   po => tree40
);

bid17_INST: bd4st
	PORT MAP (
   a => variable_datao(4),
   en => chip_tri_state,
   tn => variable_rdbo,
   pi => tree40,
   io => variable_data(4),
   zi => variable_datai(4),
   po => tree41
);

bid18_INST: bd4st
	PORT MAP (
   a => variable_datao(5),
   en => chip_tri_state,
   tn => variable_rdbo,
   pi => tree41,
   io => variable_data(5),
   zi => variable_datai(5),
   po => tree42
);

bid19_INST: bd4st
	PORT MAP (
   a => variable_datao(6),
   en => chip_tri_state,
   tn => variable_rdbo,
   pi => tree42,
   io => variable_data(6),
   zi => variable_datai(6),
   po => tree43
);

bid20_INST: bd4st
	PORT MAP (
   a => variable_datao(7),
   en => chip_tri_state,
   tn => variable_rdbo,
   pi => tree43,
   io => variable_data(7),
   zi => variable_datai(7),
   po => tree44
);

bid21_INST: bd4st
	PORT MAP (
   a => fs_datao(0),
   en => chip_tri_state,
   tn => fsdatenb_strobe,
   pi => tree44,
   io => fs_data(0),
   zi => fs_datai(0),
   po => tree45
);

bid22_INST: bd4st
	PORT MAP (
   a => fs_datao(1),
   en => chip_tri_state,
   tn => fsdatenb_strobe,
   pi => tree45,
   io => fs_data(1),
   zi => fs_datai(1),
   po => tree46
);

bid23_INST: bd4st
	PORT MAP (
   a => fs_datao(2),
   en => chip_tri_state,
   tn => fsdatenb_strobe,
   pi => tree46,
   io => fs_data(2),
   zi => fs_datai(2),
   po => tree47
);

bid24_INST: bd4st
	PORT MAP (
   a => fs_datao(3),
   en => chip_tri_state,
   tn => fsdatenb_strobe,
   pi => tree47,
   io => fs_data(3),
   zi => fs_datai(3),
   po => tree48
);

bid25_INST: bd4st
	PORT MAP (
   a => fs_datao(4),
   en => chip_tri_state,
   tn => fsdatenb_strobe,
   pi => tree48,
   io => fs_data(4),
   zi => fs_datai(4),
   po => tree49
);

bid26_INST: bd4st
	PORT MAP (
   a => fs_datao(5),
   en => chip_tri_state,
   tn => fsdatenb_strobe,
   pi => tree49,
   io => fs_data(5),
   zi => fs_datai(5),
   po => tree50
);

bid27_INST: bd4st
	PORT MAP (
   a => fs_datao(6),
   en => chip_tri_state,
   tn => fsdatenb_strobe,
   pi => tree50,
   io => fs_data(6),
   zi => fs_datai(6),
   po => tree51
);

bid28_INST: bd4st
	PORT MAP (
   a => fs_datao(7),
   en => chip_tri_state,
   tn => fsdatenb_strobe,
   pi => tree51,
   io => fs_data(7),
   zi => fs_datai(7),
   po => end_ntree
);

out01_INST: crc_write <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE crc_wrb_nt;
out02_INST: crc_read <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE crc_rdb_nt;
out03_INST: crc_address(0) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE crc_add0_nt;
out04_INST: crc_address(1) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE crc_add1_nt;
out05_INST: crc_address(2) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE crc_add2_nt;
out06_INST: crc_address(3) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE crc_add3_nt;
out07_INST: crc_address(4) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE crc_add4_nt;
out08_INST: fifo_out_clock <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fifo_out_clk_nt;
out09_INST: reset_fifo <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE reset_fifo_nt;
out10_INST: micro_interrupt <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE micro_inter_nt;
out11_INST: txc <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE txco_nt;
out12_INST: iom_du <= 'Z' WHEN (chip_tri_state = '1' OR open_collector_nt = '0') ELSE iom_duo_nt;
out13_INST: prescale_1m <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE prescale_1mo_nt;
out14_INST: prescale_8m <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE prescale_8mo_nt;
out15_INST: variable_address(0) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE variable_add0_nt;
out16_INST: variable_address(1) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE variable_add1_nt;
out17_INST: variable_address(2) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE variable_add2_nt;
out18_INST: variable_address(3) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE variable_add3_nt;
out19_INST: variable_address(4) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE variable_add4_nt;
out20_INST: variable_address(5) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE variable_add5_nt;
out21_INST: variable_address(6) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE variable_add6_nt;
out22_INST: variable_address(7) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE variable_add7_nt;
out23_INST: variable_rdb <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE variable_rdbo_nt;
out24_INST: variable_wrb <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE variable_wrbo_nt;
out25_INST: fs_address(0) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add0_nt;
out26_INST: fs_address(1) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add1_nt;
out27_INST: fs_address(2) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add2_nt;
out28_INST: fs_address(3) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add3_nt;
out29_INST: fs_address(4) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add4_nt;
out30_INST: fs_address(5) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add5_nt;
out31_INST: fs_address(6) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add6_nt;
out32_INST: fs_address(7) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add7_nt;
out33_INST: fs_address(8) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add8_nt;
out34_INST: fs_address(9) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add9_nt;
out35_INST: fs_address(10) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add10_nt;
out36_INST: fs_address(11) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add11_nt;
out37_INST: fs_address(12) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add12_nt;
out38_INST: fs_address(13) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add13_nt;
out39_INST: fs_address(14) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add14_nt;
out40_INST: fs_address(15) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add15_nt;
out41_INST: fs_address(16) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add16_nt;
out42_INST: fs_address(17) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add17_nt;
out43_INST: fs_address(18) <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fs_add18_nt;
out44_INST: amuxsel <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE amuxselo_nt;
out45_INST: fsoe <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fsoeo_nt;
out46_INST: fswe <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fsweo_nt;
out47_INST: fsstr <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fsstro_nt;
out48_INST: fscs <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE fscso_nt;
out49_INST: srdy <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE srdyo_nt;
out50_INST: cpfswe <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE cpfsweo_nt;
out51_INST: cpfsrd <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE cpfsrdo_nt;
out52_INST: rxd <= 'Z' WHEN (chip_tri_state = '1' OR vcc = '0') ELSE rxdo_nt;

END RTL;

