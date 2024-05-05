--
--    Project  : P6405 (Timeslot Aggregator)
--
--    Filename : delta_rtl.test.vhdl
--
--    Author   : D. K. May
--
--    Date     : 09th May 1994
--
--    SCCS     : %W% %G%
--
-- Description :
--
-- Test Bench for the DELTA ASIC.
--
-- Modifications
--
-- 09/05/94 DKM     1.1  Original

entity TEST_DELTA is
end;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_TEXTIO.all;
use IEEE.NUMERIC_STD.std_match;

library STD;
use STD.TEXTIO.all;
--use STD.FOREIGN.all;

architecture RTL1 of TEST_DELTA is

-- ******************************************************************
-- ******************** Components within Test Bench  ***************
-- ******************************************************************
component DELTA
  port (RESET: in STD_LOGIC;
        CLOCK: in STD_LOGIC;
        ADDRESS: in STD_LOGIC_VECTOR(3 downto 0);
        PDATA: inout STD_LOGIC_VECTOR(7 downto 0);
        RDB: in STD_LOGIC;
        CSB: in STD_LOGIC;
        WRB: in STD_LOGIC;
        CRC_WRITE: out STD_LOGIC;
        CRC_READ: out STD_LOGIC;
        CRC_ADDRESS: out STD_LOGIC_VECTOR(4 downto 0);
        CRC: inout STD_LOGIC_VECTOR(3 downto 0);
        FIFO_RAM_DATA: in STD_LOGIC_VECTOR(7 downto 0);
        FIFO_OUT_CLOCK: out STD_LOGIC;
        FIFO_FULL_INDICATE: in STD_LOGIC;
        FIFO_EMPTY_INDICATE: in STD_LOGIC;
        RESET_FIFO: out STD_LOGIC;
        MICRO_INTERRUPT: out STD_LOGIC;
        TXC: out STD_LOGIC;
        IOM_SDS1: in STD_LOGIC;
        IOM_SDS2: in STD_LOGIC;
        IOM_DCK: in STD_LOGIC;
        IOM_DU: out STD_LOGIC;
        IOM_DD: in STD_LOGIC;
        PRESCALE_1M: out STD_LOGIC;
        PRESCALE_8M: out STD_LOGIC;
        VARIABLE_ADDRESS: out STD_LOGIC_VECTOR(7 downto 0);
        VARIABLE_RDB: out STD_LOGIC;
        VARIABLE_WRB: out STD_LOGIC;
        VARIABLE_DATA: inout STD_LOGIC_VECTOR(7 downto 0);
        FS_DATA: inout STD_LOGIC_VECTOR(7 downto 0);
        FS_ADDRESS: out STD_LOGIC_VECTOR(18 downto 0);
        MEMCS: in STD_LOGIC;
        AMUXSEL: out STD_LOGIC;
        FSOE: out STD_LOGIC;
        FSWE: out STD_LOGIC;
        FSSTR: out STD_LOGIC;
        FSCS: out STD_LOGIC;
        SRDY: out STD_LOGIC;
        CPFSWE: out STD_LOGIC;
        CPFSRD: out STD_LOGIC;
        RXD: out STD_LOGIC;
        TXD: in STD_LOGIC);
end component;
-- ******************************************************************
-- *********************** Type Declarations ************************
-- ******************************************************************
type REGISTERS is
  array (0 to 6) of STD_LOGIC_VECTOR(7 downto 0);
type INFO_MESS is
  array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
-- ******************************************************************
-- ********************** Signal Declarations ***********************
-- ******************************************************************
signal RESET: STD_LOGIC;
signal ADDRESS: STD_LOGIC_VECTOR(3 downto 0);
signal RDB: STD_LOGIC;
signal CSB: STD_LOGIC;
signal WRB: STD_LOGIC;
signal FIFO_RAM_DATAD: STD_LOGIC_VECTOR(7 downto 0);
signal FIFO_FULL_INDICATE: STD_LOGIC;
signal FIFO_EMPTY_INDICATE: STD_LOGIC;
signal IOM_DD: STD_LOGIC;
signal MEMCS: STD_LOGIC;
signal TXD: STD_LOGIC := '0';
signal PDATAD: STD_LOGIC_VECTOR(7 downto 0);
signal VARIABLE_DATAD: STD_LOGIC_VECTOR(7 downto 0);
signal CRCD: STD_LOGIC_VECTOR(3 downto 0);
signal FS_DATAD: STD_LOGIC_VECTOR(7 downto 0);
signal CLOCK: STD_LOGIC := '0';
signal CLOCKS: INTEGER;
signal FRAMES: INTEGER;
signal IOM_DCK: STD_LOGIC;
signal IOM_SDS1: STD_LOGIC;
signal IOM_SDS2: STD_LOGIC;
signal REG_STORE: REGISTERS;
signal PDATA: STD_LOGIC_VECTOR(7 downto 0);
signal IOM_DU: STD_LOGIC;
signal IOM_DU_CHIP: STD_LOGIC;
signal IOM_DATA_TRANSMITTED: STD_LOGIC;
signal PRESCALE_1M: STD_LOGIC;
signal PRESCALE_8M: STD_LOGIC;
signal IC_FIFO_DATA: INFO_MESS;
signal MICRO_INTERRUPT: STD_LOGIC;
signal FIRST_INTERRUPT: BOOLEAN := FALSE;
signal POSITION: INTEGER range 0 to 255 := 0;
signal FIFO_OUT_CLOCK: STD_LOGIC;
signal FIFO_RAM_DATA: STD_LOGIC_VECTOR(7 downto 0);
signal RESET_FIFO: STD_LOGIC;
signal CRC_READ: STD_LOGIC;
signal CRC_WRITE: STD_LOGIC;
signal CRC: STD_LOGIC_VECTOR(3 downto 0);
signal CRC_ADDRESS: STD_LOGIC_VECTOR(4 downto 0);
signal VARIABLE_RDB: STD_LOGIC;
signal VARIABLE_WRB: STD_LOGIC;
signal VARIABLE_DATA: STD_LOGIC_VECTOR(7 downto 0);
signal VARIABLE_ADDRESS: STD_LOGIC_VECTOR(7 downto 0);
signal FS_DATA: STD_LOGIC_VECTOR(7 downto 0);
signal FS_ADDRESS: STD_LOGIC_VECTOR(14 downto 0);
signal ASIC_FS_ADDRESS: STD_LOGIC_VECTOR(18 downto 0);
signal MICRO_FS_ADDRESS: STD_LOGIC_VECTOR(14 downto 0);
signal FSOE: STD_LOGIC;
signal FSWE: STD_LOGIC;
signal FSCS: STD_LOGIC;
signal AMUXSEL: STD_LOGIC;
signal SRDY: STD_LOGIC;
signal TXC: STD_LOGIC;
signal DATA_STORE: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
signal IOM_ENABLE: STD_LOGIC := '0';
signal GROUND: STD_LOGIC := '0';
signal FILL_FIFO: STD_LOGIC;
signal TXDATA_S: BOOLEAN := FALSE;
signal VECTORS_S: BOOLEAN := FALSE;
signal STORE_IOM_S: BOOLEAN := FALSE;
signal TEST_STROBE: STD_LOGIC;
signal FSSTR: STD_LOGIC;
signal CPFSWE: STD_LOGIC;
signal CPFSRD: STD_LOGIC;
signal RXD: STD_LOGIC;
signal STORE: STD_LOGIC_VECTOR(15 downto 0);
signal CRC_RAM_S: BOOLEAN := FALSE;
signal VAR_RAM_S: BOOLEAN := FALSE;
signal FRM_RAM_S: BOOLEAN := FALSE;
signal IC_RAM_S: BOOLEAN := FALSE;
signal IOM_IN_S: BOOLEAN := FALSE;
signal MICRO_IN_S: BOOLEAN := FALSE;
signal INIT_REC_IN_S: BOOLEAN := FALSE;
signal DATA_MODE_IN_S: BOOLEAN := FALSE;
signal LIMIT_FIFO_S: BOOLEAN := FALSE;
signal AMUX_MODE_S: BOOLEAN := FALSE;
signal MICRO_OPERATION: STD_LOGIC;
signal TXCOUNTER: INTEGER range 0 to 7 := 1;
signal INIT_REC: STD_LOGIC;
signal PSEUDO_RAM_S: BOOLEAN := FALSE;
signal PSEUDO: STD_LOGIC_VECTOR(19 downto 0) := "10010010101110111010";
signal TESTREG: STD_LOGIC_VECTOR(19 downto 0) := "00000000000000000000";
signal DESCRAMBLE: STD_LOGIC;
signal COMPARE_ERROR: STD_LOGIC;
signal TXD_FILE: STD_LOGIC := '0';
signal FSCSDEL: STD_LOGIC;
signal DATA_ERROR: STD_LOGIC := '0';
signal IOM_DD_MOD: STD_LOGIC;
signal CHIP_RDB: STD_LOGIC := '1';
signal CHIP_WRB: STD_LOGIC := '1';
signal CHIP_MEMCS: STD_LOGIC := '1';
constant time_out_period : time := 1000 us;
begin
-- ******************************************************************
-- ********************** Text IO for Vectors ***********************
-- ******************************************************************

SETUP: process
file F:TEXT open READ_MODE is "delta_setup";                                                                
variable L: LINE;
variable VFRAMES: INTEGER;
variable TXDATA: BOOLEAN;
variable VECTORS: BOOLEAN;
variable STORE_IOM: BOOLEAN;
variable CRC_RAM: BOOLEAN;
variable VAR_RAM: BOOLEAN;
variable FRM_RAM: BOOLEAN;
variable IC_RAM: BOOLEAN;
variable IOM_IN: BOOLEAN;
variable MICRO_IN: BOOLEAN;
variable INIT_REC_IN: BOOLEAN;
variable DATA_MODE_IN: BOOLEAN;
variable LIMIT_FIFO: BOOLEAN;
variable PSEUDO_RAM: BOOLEAN;
variable AMUX_MODE: BOOLEAN;
variable tempreg : REGISTERS;
variable FIFO_DATA_FROM_FILE: INFO_MESS;
begin
READLINE (F,L);
READ (L, VFRAMES);
FRAMES <= VFRAMES;
CLOCKS <= VFRAMES * 32;
READLINE (F,L);
READ (L, tempreg(0));
REG_STORE(0) <= tempreg(0);
READLINE (F,L);
READ (L, tempreg(1));
REG_STORE(1) <= tempreg(1);
READLINE (F,L);
READ (L, tempreg(2));
REG_STORE(2) <= tempreg(2);
READLINE (F,L);
READ (L, tempreg(3));
REG_STORE(3) <= tempreg(3);
READLINE (F,L);
READ (L, tempreg(4));
REG_STORE(4) <= tempreg(4);
READLINE (F,L);
READ (L, tempreg(5));
REG_STORE(5) <= tempreg(5);
READLINE (F,L);
READ (L, tempreg(6));
REG_STORE(6) <= tempreg(6);
READLINE (F,L);
READ (L, TXDATA);
TXDATA_S <= TXDATA;
READLINE (F,L);
READ (L, VECTORS);
VECTORS_S <= VECTORS;
READLINE (F,L);
READ (L, STORE_IOM);
STORE_IOM_S <= STORE_IOM;
READLINE (F,L);
READ (L, CRC_RAM);
CRC_RAM_S <= CRC_RAM;
READLINE (F,L);
READ (L, VAR_RAM);
VAR_RAM_S <= VAR_RAM;
READLINE (F,L);
READ (L, FRM_RAM);
FRM_RAM_S <= FRM_RAM;
READLINE (F,L);
READ (L, IC_RAM);
IC_RAM_S <= IC_RAM;
READLINE (F,L);
READ (L, IOM_IN);
IOM_IN_S <= IOM_IN;
READLINE (F,L);
READ (L, MICRO_IN);
MICRO_IN_S <= MICRO_IN;
READLINE (F,L);
READ (L, INIT_REC_IN);
INIT_REC_IN_S <= INIT_REC_IN;
READLINE (F,L);
READ (L, DATA_MODE_IN);
DATA_MODE_IN_S <= DATA_MODE_IN;
READLINE (F,L);
READ (L, LIMIT_FIFO);
LIMIT_FIFO_S <= LIMIT_FIFO;
READLINE (F,L);
READ (L, PSEUDO_RAM);
PSEUDO_RAM_S <= PSEUDO_RAM;
READLINE (F,L);
READ (L, AMUX_MODE);
AMUX_MODE_S <= AMUX_MODE;
if IC_RAM_S = TRUE then
  for A in 255 downto 0 loop
    READLINE (F,L);
    READ (L, FIFO_DATA_FROM_FILE(A));
    IC_FIFO_DATA(A) <= FIFO_DATA_FROM_FILE(A);
  end loop;
end if;
wait for 1 ns;
wait;
end process;

-- Transmit data input
LOAD_DATA: process
file F:TEXT open READ_MODE is "transmit_data";
variable L: LINE ;
variable tempstore : STD_LOGIC_VECTOR(7 downto 0);
begin
  wait until FALLING_EDGE (TXC);
    if TXDATA_S = TRUE then
      if TXCOUNTER = 7 then
        TXCOUNTER <= 0 ;
        if not ENDFILE (F) then
          READLINE (F,L);
          READ (L, tempstore);
        end if;
        DATA_STORE <= tempstore;
      else
        TXCOUNTER <= TXCOUNTER + 1 ;
      end if;
      TXD_FILE <= DATA_STORE(TXCOUNTER);
    else
      TXD_FILE <= '1';
    end if;
end process;

-- Transmit data output store
STORE_IN_FILE: process(IOM_DCK,IOM_SDS2)
file F:TEXT open WRITE_MODE is "iom_data_out";
variable L: LINE ;
variable STORE_CHANA: STD_LOGIC_VECTOR(7 downto 0);
variable STORE_CHANB: STD_LOGIC_VECTOR(7 downto 0);
variable LINENUM: INTEGER range 0 to 4096 := 0 ;
begin
  if IOM_DCK'EVENT and IOM_DCK = '1' then
    IOM_ENABLE <= not(IOM_ENABLE);
    if STORE_IOM_S = TRUE then
      if IOM_SDS1 = '1' and IOM_ENABLE = '1' then
        STORE_CHANA := STORE_CHANA(6 downto 0) & IOM_DATA_TRANSMITTED;
      end if;
      if IOM_SDS2 = '1' and IOM_ENABLE = '1' then
        STORE_CHANB := STORE_CHANB(6 downto 0) & IOM_DATA_TRANSMITTED;
      end if;
    end if;
  elsif STORE_IOM_S = TRUE and IOM_SDS2'EVENT and IOM_SDS2 = '0' then
        WRITE(L,LINENUM,LEFT,4);
        WRITE(L,string'(" "),LEFT,1);
        HWRITE(L,(STORE_CHANA),LEFT,2);
        WRITE(L,string'(" "),LEFT,1);
        WRITE(L,STORE_CHANA,LEFT,2);
        WRITE(L,string'(" "),LEFT,1);
        HWRITE(L,(STORE_CHANB),LEFT,2);
        WRITE(L,string'(" "),LEFT,1);
        WRITE(L,STORE_CHANB,LEFT,2);
        WRITE(L,string'(" "),LEFT,1);
        WRITELINE(F,L);
        LINENUM := LINENUM + 1;
  end if;
end process;

-- Transmit data input
ISDN_INPUT_DATA: process(IOM_DCK,IOM_SDS2)
file F:TEXT open READ_MODE is "iom_data_in";
variable L: LINE ;
variable CHAR: STD_LOGIC_VECTOR(15 downto 0);
variable CHA: STD_LOGIC_VECTOR(7 downto 0);
variable CHB: STD_LOGIC_VECTOR(7 downto 0);
begin 
  if IOM_IN_S = TRUE then
    if IOM_DCK'EVENT and IOM_DCK = '1' then
      if (IOM_SDS1 = '1' or IOM_SDS2 = '1') and IOM_ENABLE = '0' then
        STORE <= STORE(14 downto 0) & '0';
      end if;
    elsif IOM_SDS2'EVENT and IOM_SDS2 = '0' then
      if not ENDFILE (F) then
        READLINE (F,L);
        HREAD (L, CHAR);
        CHA := CHAR(7 downto 0);
        CHB := CHAR(15 downto 8);
        STORE <= CHA & CHB;
      end if;
    end if;
  end if;
end process;

-- ******************************************************************
-- ******************* Behavioural Code used for system *************
-- ******************************************************************
-- Generates the two system clocks
-- phase locked to each other.

CLOCK <= not (CLOCK) after 61 ns;

CLOCK_GENERATOR: process
begin
wait for 1 NS;
for A in 1 to CLOCKS loop
  for E in 1 to 4 loop
    IOM_DCK <= '1';
    wait for 244 NS;
    IOM_DCK <= '0';
    wait for 366 NS;
  end loop;
  for D in 1 to 2 loop
    IOM_DCK <= '1';
    wait for 366 NS;
    IOM_DCK <= '0';
    wait for 366 NS;
  end loop;
end loop;
wait;
end process;

-- Generates the strobes from the 
-- ISDN module.
GENERATE_IOM_STROBES: process
begin
wait for 1 ns;
for A in 1 to FRAMES loop
  IOM_SDS1 <= '1' after 2 NS;
  IOM_SDS2 <= '0' after 2 NS;
  if (PSEUDO_RAM_S = TRUE and A = 603) then
    IOM_DU <= '0';
  else
    IOM_DU <= 'H';
  end if;
  wait for 10.248 US;
  IOM_SDS1 <= '0' after 2 NS;
  IOM_SDS2 <= '1' after 2 NS;
  IOM_DU <= 'H';
  wait for 10.492 US;
  IOM_SDS1 <= '0' after 2 NS;
  IOM_SDS2 <= '0' after 2 NS;
  wait for 104.188 US;
end loop;
wait;
end process;

-- Simulates the host interface with read/writes
-- during operation of ASIC.
MICRO_WRITES:process
begin
  wait for 20 ns;
  if MICRO_IN_S = FALSE then
    MICRO_OPERATION <= '0';
  else
    MICRO_OPERATION <= '0';
    wait for 244 us;
    MICRO_OPERATION <= '1';
    wait for 122 ns;
    MICRO_OPERATION <= '0';
    wait for 31.598 us;
    MICRO_OPERATION <= '1';
    wait for 122 ns;
    MICRO_OPERATION <= '0';
    wait for 12.444 us;
    MICRO_OPERATION <= '1';
    wait for 122 ns;
    MICRO_OPERATION <= '0';
    wait for 111.264 us;
    MICRO_OPERATION <= '1';
    wait for 122 ns;
    MICRO_OPERATION <= '0';
    wait for 12.200 us;
    MICRO_OPERATION <= '1';
    wait for 122 ns;
    MICRO_OPERATION <= '0';
    wait for 113.704 us;
    MICRO_OPERATION <= '1';
    wait for 122 ns;
    MICRO_OPERATION <= '0';
    wait for 12.322 us;
    MICRO_OPERATION <= '1';
    wait for 122 ns;
    MICRO_OPERATION <= '0';
  end if;
wait;
end process;

PRODUCE_RDB: process
begin
wait until RDB'LAST_VALUE = '1' and RDB = '0';
  CHIP_RDB <= '0';
wait until RDB'LAST_VALUE = '0' and RDB = '1';
  if SRDY = '0' then
    CHIP_RDB <= '0';
    wait until SRDY'LAST_VALUE = '0' and SRDY = '1';
    CHIP_RDB <= '1'after 183 ns;
  else
    CHIP_RDB <= '1';
  end if;
end process;

PRODUCE_WRB: process
begin
wait until WRB'LAST_VALUE = '1' and WRB = '0';
  CHIP_WRB <= '0';
wait until WRB'LAST_VALUE = '0' and WRB = '1';
  if SRDY = '0' then
    CHIP_WRB <= '0';
    wait until SRDY'LAST_VALUE = '0' and SRDY = '1';
    CHIP_WRB <= '1'after 183 ns;
  else
    CHIP_WRB <= '1';
  end if;
end process;

PRODUCE_MEMCS: process
begin
wait until MEMCS'LAST_VALUE = '1' and MEMCS = '0';
  CHIP_MEMCS <= '0';
wait until MEMCS'LAST_VALUE = '0' and MEMCS = '1';
  if SRDY = '0' then
    CHIP_MEMCS <= '0';
    wait until SRDY'LAST_VALUE = '0' and SRDY = '1';
    CHIP_MEMCS <= '1'after 183 ns;
  else
    CHIP_MEMCS <= '1';
  end if;
end process;

HOST_MICRO: process
begin
  FILL_FIFO <= '0';
  MEMCS <= '1';
  RDB <= '1';
  CSB <= '1';
  WRB <= '1';
  ADDRESS <= "0000";
  PDATA <= "ZZZZZZZZ";
  PDATAD <= "ZZZZZZZZ";
  MICRO_FS_ADDRESS <= "000000000000000";
  wait for 20 us ;
  for A in 0 to 5 loop
    PDATA <= STD_LOGIC_VECTOR(REG_STORE(A));
    PDATAD <= REG_STORE(A);
    ADDRESS <= CONV_STD_LOGIC_VECTOR(A,4) ;
    wait for 5 ns ;
    CSB <= '0' ;
    wait for 5 ns ;
    WRB <= '0' ;
    wait for 5 ns ; 
    WRB <= '1' ;
    wait for 5 ns ; 
    CSB <= '1' ;
    wait for 5 ns;
  end loop;
  wait for 130 us ;
  FILL_FIFO <= '1';
  PDATA <= STD_LOGIC_VECTOR(REG_STORE(6));
  PDATAD <= REG_STORE(6);
  ADDRESS <= "0101";
  wait for 5 ns ;
  CSB <= '0' ;
  wait for 5 ns ;
  WRB <= '0' ;
  wait for 5 ns ;
  WRB <= '1' ;
  wait for 5 ns ;
  CSB <= '1' ;
  FILL_FIFO <= '0';
  if MICRO_IN_S = TRUE then
    for A in 0 to 8 loop
      PDATA <= "ZZZZZZZZ";
      PDATAD <= "ZZZZZZZZ";
      ADDRESS <= CONV_STD_LOGIC_VECTOR(A,4) ;
      wait for 5 ns ;
      CSB <= '0' ;
      wait for 5 ns ;
      RDB <= '0' ;
      wait for 5 ns ; 
      RDB <= '1' ;
      wait for 5 ns ; 
      CSB <= '1' ;
      wait for 5 ns;
    end loop;
  end if;
  if DATA_MODE_IN_S = TRUE then

    wait for 50 US;
    PDATA <= "00000110";
    PDATAD <= "00000110";
    wait for 5 ns ;
    CSB <= '0' ;
    wait for 5 ns ;
    WRB <= '0' ;
    wait for 5 ns ;
    WRB <= '1' ;
    wait for 5 ns ;
    CSB <= '1' ;
    wait for 5 ns;

    wait for 50 US;
    PDATA <= "00001010";
    PDATAD <= "00001010";
    wait for 5 ns ;
    CSB <= '0' ;
    wait for 5 ns ;
    WRB <= '0' ;
    wait for 5 ns ;
    WRB <= '1' ;
    wait for 5 ns ;
    CSB <= '1' ;
    wait for 5 ns;

    wait for 50 US;
    PDATA <= "00001110";
    PDATAD <= "00001110";
    wait for 5 ns ;
    CSB <= '0' ;
    wait for 5 ns ;
    WRB <= '0' ;
    wait for 5 ns ;
    WRB <= '1' ;
    wait for 5 ns ;
    CSB <= '1' ;
    wait for 5 ns;

    wait for 50 US;
    PDATA <= "00000010";
    PDATAD <= "00000010";
    wait for 5 ns ;
    CSB <= '0' ;
    wait for 5 ns ;
    WRB <= '0' ;
    wait for 5 ns ;
    WRB <= '1' ;
    wait for 5 ns ;
    CSB <= '1' ;
    wait for 5 ns;

    wait for 50 US;
    PDATA <= "00010010";
    PDATAD <= "00010010";
    wait for 5 ns ;
    CSB <= '0' ;
    wait for 5 ns ;
    WRB <= '0' ;
    wait for 5 ns ;
    WRB <= '1' ;
    wait for 5 ns ;
    CSB <= '1' ;
    wait for 5 ns;

    wait for 50 US;
    PDATA <= "00100010";
    PDATAD <= "00100010";
    wait for 5 ns ;
    CSB <= '0' ;
    wait for 5 ns ;
    WRB <= '0' ;
    wait for 5 ns ;
    WRB <= '1' ;
    wait for 5 ns ;
    CSB <= '1' ;
    wait for 5 ns;

    wait for 50 US;
    PDATA <= "00110010";
    PDATAD <= "00110010";
    wait for 5 ns ;
    CSB <= '0' ;
    wait for 5 ns ;
    WRB <= '0' ;
    wait for 5 ns ;
    WRB <= '1' ;
    wait for 5 ns ;
    CSB <= '1' ;
    wait for 5 ns;

    wait for 50 US;
    PDATA <= "00110110";
    PDATAD <= "00110110";
    wait for 5 ns ;
    CSB <= '0' ;
    wait for 5 ns ;
    WRB <= '0' ;
    wait for 5 ns ;
    WRB <= '1' ;
    wait for 5 ns ;
    CSB <= '1' ;
    wait for 5 ns;

    wait for 50 US;
    PDATA <= "00111010";
    PDATAD <= "00111010";
    wait for 5 ns ;
    CSB <= '0' ;
    wait for 5 ns ;
    WRB <= '0' ;
    wait for 5 ns ;
    WRB <= '1' ;
    wait for 5 ns ;
    CSB <= '1' ;
    wait for 5 ns;

    wait for 50 US;
    PDATA <= "00111110";
    PDATAD <= "00111110";
    wait for 5 ns ;
    CSB <= '0' ;
    wait for 5 ns ;
    WRB <= '0' ;
    wait for 5 ns ;
    WRB <= '1' ;
    wait for 5 ns ;
    CSB <= '1' ;
    wait for 5 ns;

    -- Put chip into data mode
    -- after 35MS.
    wait for 35 MS;
    PDATA <= "00000110";
    PDATAD <= "00000110";
    wait for 5 ns ;
    CSB <= '0' ;
    wait for 5 ns ;
    WRB <= '0' ;
    wait for 5 ns ;
    WRB <= '1' ;
    wait for 5 ns ;
    CSB <= '1' ;
    wait for 5 ns;
    PDATA <= "00011111";
    PDATAD <= "00011111";
    ADDRESS <= "0000";
    wait for 5 ns ;
    CSB <= '0' ;
    wait for 5 ns ;
    WRB <= '0' ;
    wait for 5 ns ;
    WRB <= '1' ;
    wait for 5 ns ;
    CSB <= '1' ;
    wait for 5 ns;
  elsif AMUX_MODE_S = TRUE then
    ADDRESS <= "0101";
    PDATA <= "10010010";
    PDATAD <= "10010010";
    wait for 122 ns ;
    CSB <= '0' ;
    wait for 122 ns ;
    WRB <= '0' ;
    wait for 122 ns ;
    WRB <= '1' ;
    wait for 122 ns ;
    CSB <= '1' ;
    wait for 122 ns ;
    PDATA <= "ZZZZZZZZ";
    PDATAD <= "ZZZZZZZZ";
    ADDRESS <= "0110";
    wait for 122 ns ;
    CSB <= '0' ;
    wait for 122 ns ;
    RDB <= '0' ;
    wait for 122 ns ;
    RDB <= '1' ;
    wait for 122 ns ;
    CSB <= '1' ;
    wait for 560 us;
    DATA_ERROR <= '1';
    wait for 250 us;
    DATA_ERROR <= '0';
    CSB <= '0' ;
    wait for 122 ns ;
    RDB <= '0' ;
    wait for 122 ns ;
    RDB <= '1' ;
    wait for 122 ns ;
    CSB <= '1' ;
    wait for 1.5 ms ;
    CSB <= '0' ;
    wait for 122 ns ;
    RDB <= '0' ;
    wait for 122 ns ;
    RDB <= '1' ;
    wait for 122 ns ;
    CSB <= '1' ;
    wait for 122 ns ;
    ADDRESS <= "0101";
    PDATA <= "01010110";
    PDATAD <= "01010110";
    wait for 122 ns ;
    CSB <= '0' ;
    wait for 122 ns ;
    WRB <= '0' ;
    wait for 122 ns ;
    WRB <= '1' ;
    wait for 122 ns ;
    CSB <= '1' ;
    wait for 122 ns ;
    PDATA <= "ZZZZZZZZ";
    PDATAD <= "ZZZZZZZZ";
    wait for 4 ms ;
    PDATA <= "00010110";
    PDATAD <= "00010110";
    wait for 122 ns ;
    CSB <= '0' ;
    wait for 122 ns ;
    WRB <= '0' ;
    wait for 122 ns ;
    WRB <= '1' ;
    wait for 122 ns ;
    CSB <= '1' ;
    wait for 122 ns ;
  end if;
  loop
  wait until (MICRO_INTERRUPT'EVENT and MICRO_INTERRUPT = '1') or
             (MICRO_OPERATION'EVENT and MICRO_OPERATION = '1');
    if MICRO_INTERRUPT = '1' then
      PDATA <= "10000000" or STD_LOGIC_VECTOR(REG_STORE(0));
      PDATAD <= "10000000" or REG_STORE(0);
      ADDRESS <= "0000";
      wait for 122 ns ;
      CSB <= '0' ;
      wait for 122 ns ;
      WRB <= '0' ;
      wait for 122 ns ;
      WRB <= '1' ;
      wait for 122 ns ;
      CSB <= '1' ;
      wait for 366 ns;
      PDATA <= STD_LOGIC_VECTOR(REG_STORE(0));
      PDATAD <= REG_STORE(0);
      ADDRESS <= "0000";
      wait for 122 ns ;
      CSB <= '0' ;
      wait for 122 ns ;
      WRB <= '0' ;
      wait for 122 ns ;
      WRB <= '1' ;
      wait for 122 ns ;
      CSB <= '1' ;
      wait for 122 ns ;
    else
    for A in 0 to 127 loop
      PDATA <= "10101010";
      PDATAD <= "10101010";
      wait for 61 ns ;
      MEMCS <= '0';
      wait for 122 ns ;
      WRB <= '0';
      wait for 122 ns ;
      WRB <= '1';
      wait for 122 ns ;
      MEMCS <= '1';
      wait for 61 ns ;
      PDATA <= "ZZZZZZZZ";
      PDATAD <= "ZZZZZZZZ";
      MICRO_FS_ADDRESS <= MICRO_FS_ADDRESS + '1';
      wait for 122 ns ;
      MEMCS <= '0';
      wait for 122 ns ;
      RDB <= '0';
      wait for 122 ns ;
      RDB <= '1';
      wait for 122 ns ;
      MEMCS <= '1';
      wait for 61 ns ;
      PDATA <= "ZZZZZZZZ";
      PDATAD <= "ZZZZZZZZ";
      MICRO_FS_ADDRESS <= MICRO_FS_ADDRESS + '1';
      wait for 122 ns ;
      MEMCS <= '0';
      wait for 122 ns ;
      RDB <= '0';
      wait for 122 ns ;
      RDB <= '1';
      wait for 122 ns ;
      MEMCS <= '1';
      wait for 122 ns ;
      PDATA <= "10101010";
      PDATAD <= "10101010";
      wait for 61 ns ;
      MEMCS <= '0';
      wait for 122 ns ;
      WRB <= '0';
      wait for 122 ns ;
      WRB <= '1';
      wait for 122 ns ;
      MEMCS <= '1';
      wait for 122 ns ;
     end loop;
    end if;
  end loop;
  wait;
end process;

-- The information FIFO control.
process (FILL_FIFO,RESET,FIFO_OUT_CLOCK, MICRO_INTERRUPT,POSITION)
begin 
if IC_RAM_S = TRUE then
  if FILL_FIFO'EVENT and FILL_FIFO = '1' then
    POSITION <= 255;
  elsif LIMIT_FIFO_S = TRUE then
    if FIFO_OUT_CLOCK'EVENT and FIFO_OUT_CLOCK = '1' then
      if POSITION = 0 then
        POSITION <= 255;
      else
        POSITION <= POSITION - 1;
      end if;
    end if;
  else
    if RESET_FIFO = '0' then
      POSITION <= 0;
    elsif MICRO_INTERRUPT'EVENT and MICRO_INTERRUPT = '1' then
      if FIRST_INTERRUPT = FALSE then
        POSITION <= POSITION + 64;
        FIRST_INTERRUPT <= TRUE;
      else
        POSITION <= POSITION + 128;
      end if;
    elsif  FIFO_OUT_CLOCK'EVENT and FIFO_OUT_CLOCK = '1' then
      POSITION <= POSITION - 1;
    end if;
  end if;
  if POSITION = 255 then
    FIFO_FULL_INDICATE <= '0';
    FIFO_EMPTY_INDICATE <= '1';
  elsif POSITION = 0 then
    FIFO_EMPTY_INDICATE <= '0';
    FIFO_FULL_INDICATE <= '1';
  else
    FIFO_EMPTY_INDICATE <= '1';
    FIFO_FULL_INDICATE <= '1';
  end if;
else
  FIFO_EMPTY_INDICATE <= '0';
  FIFO_FULL_INDICATE <= '1';
end if;
end process;
FIFO_RAM_DATA <= IC_FIFO_DATA (POSITION);
FIFO_RAM_DATAD <= IC_FIFO_DATA (POSITION) after 30 ns;

-- Transmit process variable RAM.
TX_VARIABLE_RAM: process (CRC_WRITE,CRC_READ)
type CRCRAM is
  array (0 to 31) of STD_LOGIC_VECTOR(3 downto 0);
variable CRC_STORE: CRCRAM := (others => "XXXX");
begin
if CRC_RAM_S = TRUE then
  if CRC_WRITE'LAST_VALUE = '0' and CRC_WRITE'EVENT and CRC_WRITE = '1' then
    CRC_STORE(CONV_INTEGER(CRC_ADDRESS)) := CRC;
  end if ;
  if CRC_READ = '0' then
    CRC <= CRC_STORE(CONV_INTEGER(CRC_ADDRESS));
    CRCD <= STD_LOGIC_VECTOR(CRC_STORE(CONV_INTEGER(CRC_ADDRESS))) after 35 ns;
  else
    CRC <= "ZZZZ";
    CRCD <= "ZZZZ" after 35 ns;
  end if;
else
  CRC <= "0000";
  CRCD <= "0000" after 35 ns;
end if;
end process;

-- Receive process variable RAM.
INITIALISE_REC:process
begin
  wait for 100 ns;
  if INIT_REC_IN_S = FALSE then
    INIT_REC <= '0';
  else
    INIT_REC <= '0';
    wait for 200 US;
    INIT_REC <= '1';
    for A in 200 downto 0 loop
      wait for 10 US;
      INIT_REC <= '0';
      wait for 10 US;
      INIT_REC <= '1';
    end loop;
    wait for 10 ns;
  end if;
wait;
end process;

RX_VARIABLE_RAM: process (VARIABLE_RDB,VARIABLE_WRB,INIT_REC)
type VARRAM is
  array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
variable VAR_STORE: VARRAM := (others => "XXXXXXXX");
variable init_done : boolean := false;
variable numberwrites : integer := 0;
begin
if VAR_RAM_S = TRUE then
  if VARIABLE_WRB'LAST_VALUE = '0' and VARIABLE_WRB'EVENT and VARIABLE_WRB = '1' then
    if IS_X (VARIABLE_ADDRESS) then 
      assert false 
      report "Variable Address Write Unknown" 
      severity warning; 
    else
      VAR_STORE(CONV_INTEGER(VARIABLE_ADDRESS)) :=
                 STD_LOGIC_VECTOR(VARIABLE_DATA);
    end if;
  elsif VARIABLE_RDB = '0' then
    if IS_X (VARIABLE_ADDRESS) then 
      assert false  
      report "Variable Address Read Unknown"
      severity warning;  
    else
      VARIABLE_DATA <=
      STD_LOGIC_VECTOR(VAR_STORE(CONV_INTEGER(VARIABLE_ADDRESS)));
      VARIABLE_DATAD <= VAR_STORE(CONV_INTEGER(VARIABLE_ADDRESS)) after 5 ns;
    end if;
  else
    VARIABLE_DATA <= "ZZZZZZZZ";
    VARIABLE_DATAD <= "ZZZZZZZZ" after 5 ns;
  end if;
  if INIT_REC'EVENT and INIT_REC = '1' then
    if init_done = false then
      VAR_STORE(0) :=  "11111010"; -- "1111" & CRC
      VAR_STORE(1) :=  "11111111"; -- "11" & Group_STORE
      VAR_STORE(2) :=  "00100001"; -- STATES_CRC & '1' & CHANID_STORE
      VAR_STORE(3) :=  "11111111"; -- STATES_GROUP & "1111" & STATES_CHAN_ID
      VAR_STORE(4) :=  "11101110"; -- "11" & STATES_FRAME & "11" & STATES_ICHAN_ID
      VAR_STORE(5) :=  "00000000"; -- OCTET_COUNT
      VAR_STORE(6) :=  "10111111"; -- '1' & STATES_FAW & ICHAN_COUNT
      VAR_STORE(7) :=  "11000000"; -- "11" & STORE_FRAMES
      VAR_STORE(8) :=  "11111010"; -- "1111" & CRC
      VAR_STORE(9) :=  "11111111"; -- "11" & Group_STORE
      VAR_STORE(10) := "00100010"; -- STATES_CRC & '1' & CHANID_STORE
      VAR_STORE(11) := "11111111"; -- STATES_GROUP & "1111" & STATES_CHAN_ID
      VAR_STORE(12) := "11101110"; -- "11" & STATES_FRAME & "11" & STATES_ICHAN_ID
      VAR_STORE(13) := "11111111"; -- OCTET_COUNT
      VAR_STORE(14) := "10111111"; -- '1' & STATES_FAW & ICHAN_COUNT
      VAR_STORE(15) := "11111111"; -- "11" & STORE_FRAMES
    end if;
    if (REG_STORE(1)(7) = '1' and init_done = true ) then
      if numberwrites = 4 then
        numberwrites := 0;
      end if;
      case numberwrites is
      when 0 =>
      VAR_STORE(0) :=  "11111010"; -- "1111" & CRC
      VAR_STORE(1) :=  "11111111"; -- "11" & Group_STORE
      VAR_STORE(2) :=  "00100001"; -- STATES_CRC & '1' & CHANID_STORE
      VAR_STORE(3) :=  "11111111"; -- STATES_GROUP & "1111" & STATES_CHAN_ID
      VAR_STORE(4) :=  "11101110"; -- "11" & STATES_FRAME & "11" & STATES_ICHAN_ID
      VAR_STORE(5) :=  "11111111"; -- OCTET_COUNT
      VAR_STORE(6) :=  "10011111"; -- '1' & STATES_FAW & ICHAN_COUNT
      VAR_STORE(7) :=  "11000000"; -- "11" & STORE_FRAMES
      VAR_STORE(8) :=  "11111010"; -- "1111" & CRC
      VAR_STORE(9) :=  "11111111"; -- "11" & Group_STORE
      VAR_STORE(10) := "00100010"; -- STATES_CRC & '1' & CHANID_STORE
      VAR_STORE(11) := "11111111"; -- STATES_GROUP & "1111" & STATES_CHAN_ID
      VAR_STORE(12) := "11101110"; -- "11" & STATES_FRAME & "11" & STATES_ICHAN_ID
      VAR_STORE(13) := "11111111"; -- OCTET_COUNT
      VAR_STORE(14) := "11001111"; -- '1' & STATES_FAW & ICHAN_COUNT
      VAR_STORE(15) := "11111111"; -- "11" & STORE_FRAMES
      when 1 =>
      VAR_STORE(0) :=  "11111010"; -- "1111" & CRC
      VAR_STORE(1) :=  "11111111"; -- "11" & Group_STORE
      VAR_STORE(2) :=  "00100001"; -- STATES_CRC & '1' & CHANID_STORE
      VAR_STORE(3) :=  "11111111"; -- STATES_GROUP & "1111" & STATES_CHAN_ID
      VAR_STORE(4) :=  "11101110"; -- "11" & STATES_FRAME & "11" & STATES_ICHAN_ID
      VAR_STORE(5) :=  "11111111"; -- OCTET_COUNT
      VAR_STORE(6) :=  "10011111"; -- '1' & STATES_FAW & ICHAN_COUNT
      VAR_STORE(7) :=  "11000000"; -- "11" & STORE_FRAMES
      VAR_STORE(8) :=  "11111010"; -- "1111" & CRC
      VAR_STORE(9) :=  "11111111"; -- "11" & Group_STORE
      VAR_STORE(10) := "00100010"; -- STATES_CRC & '1' & CHANID_STORE
      VAR_STORE(11) := "11111111"; -- STATES_GROUP & "1111" & STATES_CHAN_ID
      VAR_STORE(12) := "11101110"; -- "11" & STATES_FRAME & "11" & STATES_ICHAN_ID
      VAR_STORE(13) := "11111111"; -- OCTET_COUNT
      VAR_STORE(14) := "11011111"; -- '1' & STATES_FAW & ICHAN_COUNT
      VAR_STORE(15) := "11111111"; -- "11" & STORE_FRAMES
      when 2 =>
      VAR_STORE(0) :=  "11111010"; -- "1111" & CRC
      VAR_STORE(1) :=  "11111111"; -- "11" & Group_STORE
      VAR_STORE(2) :=  "00100001"; -- STATES_CRC & '1' & CHANID_STORE
      VAR_STORE(3) :=  "11111111"; -- STATES_GROUP & "1111" & STATES_CHAN_ID
      VAR_STORE(4) :=  "11101110"; -- "11" & STATES_FRAME & "11" & STATES_ICHAN_ID
      VAR_STORE(5) :=  "11111111"; -- OCTET_COUNT
      VAR_STORE(6) :=  "10011111"; -- '1' & STATES_FAW & ICHAN_COUNT
      VAR_STORE(7) :=  "11000000"; -- "11" & STORE_FRAMES
      VAR_STORE(8) :=  "11111010"; -- "1111" & CRC
      VAR_STORE(9) :=  "11111111"; -- "11" & Group_STORE
      VAR_STORE(10) := "00100010"; -- STATES_CRC & '1' & CHANID_STORE
      VAR_STORE(11) := "11111111"; -- STATES_GROUP & "1111" & STATES_CHAN_ID
      VAR_STORE(12) := "11101110"; -- "11" & STATES_FRAME & "11" & STATES_ICHAN_ID
      VAR_STORE(13) := "11111111"; -- OCTET_COUNT
      VAR_STORE(14) := "10011111"; -- '1' & STATES_FAW & ICHAN_COUNT
      VAR_STORE(15) := "11111111"; -- "11" & STORE_FRAMES
      when 3 =>
      VAR_STORE(0) :=  "11111010"; -- "1111" & CRC
      VAR_STORE(1) :=  "11111111"; -- "11" & Group_STORE
      VAR_STORE(2) :=  "10100001"; -- STATES_CRC & '1' & CHANID_STORE
      VAR_STORE(3) :=  "11111111"; -- STATES_GROUP & "1111" & STATES_CHAN_ID
      VAR_STORE(4) :=  "11101101"; -- "11" & STATES_FRAME & "11" & STATES_ICHAN_ID
      VAR_STORE(5) :=  "10000000"; -- OCTET_COUNT
      VAR_STORE(6) :=  "10011111"; -- '1' & STATES_FAW & ICHAN_COUNT
      VAR_STORE(7) :=  "11000000"; -- "11" & STORE_FRAMES
      VAR_STORE(8) :=  "11111010"; -- "1111" & CRC
      VAR_STORE(9) :=  "11111111"; -- "11" & Group_STORE
      VAR_STORE(10) := "00100010"; -- STATES_CRC & '1' & CHANID_STORE
      VAR_STORE(11) := "01111111"; -- STATES_GROUP & "1111" & STATES_CHAN_ID
      VAR_STORE(12) := "11101111"; -- "11" & STATES_FRAME & "11" & STATES_ICHAN_ID
      VAR_STORE(13) := "01000000"; -- OCTET_COUNT
      VAR_STORE(14) := "10011111"; -- '1' & STATES_FAW & ICHAN_COUNT
      VAR_STORE(15) := "11111111"; -- "11" & STORE_FRAMES
      when others =>
      null;
      end case;
      numberwrites := numberwrites + 1;
    end if;
    init_done := true;
  end if;
else
  VARIABLE_DATA <= "00000000";
  VARIABLE_DATAD <= "00000000" after 5 ns;
end if;
end process;

FSCSDEL <= FSCS after 1 ns;
-- Frame Store RAM.
FRAME_STORE_RAM: process (FSWE,FSOE,FSCSDEL,FS_ADDRESS)
type FSRAM is
  array (0 to 65535) of STD_LOGIC_VECTOR(7 downto 0);
variable FS_STORE: FSRAM := (others => "10110111");
begin
if FRM_RAM_S = TRUE then
  if (FSWE'LAST_VALUE = '0' and FSWE'EVENT and FSWE = '1') and FSCSDEL = '0' then
    if IS_X (FS_ADDRESS) then
      assert false
      report "FS Address Write Unknown"
      severity warning;
    else
      FS_STORE(CONV_INTEGER(FS_ADDRESS)) :=
              STD_LOGIC_VECTOR(FS_DATA);
    end if;
  end if ;
  if FSOE = '0' and FSCSDEL = '0' then
    if IS_X (FS_ADDRESS) then 
      assert false 
      report "FS Address Read Unknown" 
      severity warning; 
      FS_DATA <= "XXXXXXXX";
      FS_DATAD <= "XXXXXXXX" after 5 ns;
    else
      FS_DATA <=
      STD_LOGIC_VECTOR(FS_STORE(CONV_INTEGER(FS_ADDRESS)));
      FS_DATAD <= FS_STORE(CONV_INTEGER(FS_ADDRESS)) after 5 ns;
    end if;
  else
    FS_DATA <= "ZZZZZZZZ";
    FS_DATAD <= "ZZZZZZZZ" after 5 ns;
  end if;
else
  FS_DATA <= "XXXXXXXX";
  FS_DATAD <= "XXXXXXXX" after 5 ns;
end if;
end process;

FS_ADDRESS <= MICRO_FS_ADDRESS after 2 ns when AMUXSEL = '0' else ASIC_FS_ADDRESS(18 downto 5) & ASIC_FS_ADDRESS(0) after 2 ns;

-- Transmit and Receive Serial Data
PSEUDO_PROCESS: process (TXC)
begin
  if PSEUDO_RAM_S = TRUE then
    if TXC'EVENT and TXC = '0' then
      PSEUDO <= PSEUDO(18 downto 0) & not(PSEUDO(2) xor PSEUDO(19));
    end if;
    if TXC'EVENT and TXC = '1' then 
      TESTREG <= TESTREG(18 downto 0) & RXD;
      COMPARE_ERROR <= DESCRAMBLE xor RXD; 
    end if;
  end if;
end process;

-- Bus Monitor
BUSM_PROCESS: process
begin
    wait until (fscs'EVENT or fswe'EVENT) for time_out_period;
    if std_match(FS_DATA,"ZZZZZZZZ") then
      assert false
      report "Bus monitor halted"
      severity warning;
    end if;
end process; 

DESCRAMBLE <= not(TESTREG(2) xor TESTREG(19));
TXD <= TXD_FILE when PSEUDO_RAM_S = FALSE else PSEUDO(19);
IOM_DATA_TRANSMITTED <= '0' when IOM_DU = '0' else '1';
IOM_DD_MOD <= IOM_DATA_TRANSMITTED when IOM_IN_S = FALSE else STORE(15);
IOM_DD <= IOM_DD_MOD xor DATA_ERROR;
RESET <= '0', '1' after 20 us;
IOM_DU <= IOM_DU_CHIP;
-- coverage off
-- ******************************************************************
-- ******************* Test Vector Storage Code  ********************
-- ******************************************************************
TEST_STROBE <= CLOCK after 59 ns;
VECTOR_STORE: process
file F:TEXT open WRITE_MODE is "simulation_run_rtl";
variable L: LINE ;
variable FIRST_TIME: BOOLEAN := TRUE ;
variable LAST_CHNGA: STD_LOGIC_VECTOR(7 downto 0);
variable LAST_CHNGB: STD_LOGIC_VECTOR(7 downto 0);
variable LAST_CHNGC: STD_LOGIC_VECTOR(7 downto 0);
variable LAST_CHNGD: STD_LOGIC_VECTOR(7 downto 0);
variable LAST_CHNGE: STD_LOGIC_VECTOR(7 downto 0);
variable LAST_CHNGF: STD_LOGIC_VECTOR(7 downto 0);
variable LAST_CHNGG: STD_LOGIC_VECTOR(7 downto 0);
variable LAST_CHNGH: STD_LOGIC_VECTOR(7 downto 0);
variable LAST_CHNGI: STD_LOGIC_VECTOR(7 downto 0);
variable LAST_CHNGJ: STD_LOGIC_VECTOR(7 downto 0);
begin
  wait until RISING_EDGE (TEST_STROBE) ;
    if VECTORS_S = TRUE then
      if FIRST_TIME = TRUE then
          WRITE(L,string'("CCFRMTIP CCCCCPRA FSCCCCCC DDDDDDDD FFFFFFFF VVVVVVVV FFFFFFFF FFFFFFFF VVFFFFFF VVVVVVVV"),LEFT);
          WRITELINE(F,L);
          WRITE(L,string'("RRIEIXOR RRRRRRXM SRPPRRRR AAAAAAAA SSSSSSSS AAAAAAAA SSSSSSSS SSSSSSSS AASSSSSS AAAAAAAA"),LEFT);
          WRITELINE(F,L);
          WRITE(L,string'("CCFSCCME CCCCCEDU CDFFCCCC TTTTTTTT DDDDDDDD RRRRRRRR AAAAAAAA AAAAAAAA RROWSAAA RRRRRRRR"),LEFT);
          WRITELINE(F,L);
          WRITE(L,string'("__OER._S AAAAAS.X SYSS3210 AAAAAAAA AAAAAAAA DDDDDDDD DDDDDDDD DDDDDDDD RWEETDDD AAAAAAAA"),LEFT);
          WRITELINE(F,L);
          WRITE(L,string'("WR_TO.D1 DDDDD8.S ..WR.... 76543210 TTTTTTTT AAAAAAAA DDDDDDDD DDDDDDDD DR..RDDD DDDDDDDD"),LEFT);
          WRITELINE(F,L);
          WRITE(L,string'("REC__.UM DDDDDM.E ..ED.... ........ AAAAAAAA TTTTTTTT 11111198 76543210 .....111 DDDDDDDD"),LEFT);
          WRITELINE(F,L);
          WRITE(L,string'("IALFI... 43210..L ........ ........ 76543210 AAAAAAAA 543210.. ........ .....876 76543210"),LEFT);
          WRITELINE(F,L);
          WRITE(L,string'("TDKIN... ........ ........ ........ ........ 76543210 ........ ........ ........ ........"),LEFT);
          WRITELINE(F,L);
          WRITE(L,string'("E..FT... ........ ........ ........ ........ ........ ........ ........ ........ ........"),LEFT);
          WRITELINE(F,L);
          WRITE(L,string'("...O.... ........ ........ ........ ........ ........ ........ ........ ........ ........"),LEFT);
          WRITELINE(F,L);
          WRITE(L,string'("........ ........ ........ ........ ........ ........ ........ ........ ........ ........"),LEFT);
          WRITELINE(F,L);
          WRITELINE(F,L);
          FIRST_TIME := FALSE;
      elsif CRC_WRITE & CRC_READ & FIFO_OUT_CLOCK & RESET_FIFO &
          MICRO_INTERRUPT & TXC & STD_LOGIC(IOM_DU_CHIP) & PRESCALE_1M
          /= LAST_CHNGA or
          CRC_ADDRESS & PRESCALE_8M & RXD & AMUXSEL
          /= LAST_CHNGB or
          FSCS & SRDY & CPFSWE & CPFSRD & STD_LOGIC_VECTOR(CRC)
          /= LAST_CHNGC or
          PDATA /= LAST_CHNGD or
          FS_DATA /= LAST_CHNGE or
          VARIABLE_DATA /= LAST_CHNGF or
          ASIC_FS_ADDRESS(15 downto 8) /= LAST_CHNGG or
          ASIC_FS_ADDRESS(7 downto 0) /= LAST_CHNGH or
          VARIABLE_RDB & VARIABLE_WRB & FSOE & FSWE & FSSTR &
          ASIC_FS_ADDRESS(18 downto 16) /= LAST_CHNGI or 
          VARIABLE_ADDRESS /= LAST_CHNGJ then
            LAST_CHNGA := CRC_WRITE & CRC_READ & FIFO_OUT_CLOCK & RESET_FIFO &
                          MICRO_INTERRUPT & TXC & STD_LOGIC(IOM_DU_CHIP) &
                          PRESCALE_1M;
            LAST_CHNGB := CRC_ADDRESS & PRESCALE_8M & RXD & AMUXSEL;
            LAST_CHNGC := FSCS & SRDY & CPFSWE & CPFSRD &
                          STD_LOGIC_VECTOR(CRC);
            LAST_CHNGD := PDATA;
            LAST_CHNGE := FS_DATA;
            LAST_CHNGF := VARIABLE_DATA;
            LAST_CHNGG := ASIC_FS_ADDRESS(15 downto 8);
            LAST_CHNGH := ASIC_FS_ADDRESS(7 downto 0);
            LAST_CHNGI := VARIABLE_RDB & VARIABLE_WRB & FSOE & FSWE & FSSTR &
                          ASIC_FS_ADDRESS(18 downto 16);
            LAST_CHNGJ := VARIABLE_ADDRESS;
            WRITE(L,LAST_CHNGA,LEFT,2);
            WRITE(L,string'(" "),LEFT,1);
            WRITE(L,LAST_CHNGB,LEFT,2);
            WRITE(L,string'(" "),LEFT,1);
            WRITE(L,LAST_CHNGC,LEFT,2);
            WRITE(L,string'(" "),LEFT,1);
            WRITE(L,LAST_CHNGD,LEFT,2);
            WRITE(L,string'(" "),LEFT,1);
            WRITE(L,LAST_CHNGE,LEFT,2);
            WRITE(L,string'(" "),LEFT,1);
            WRITE(L,LAST_CHNGF,LEFT,2);
            WRITE(L,string'(" "),LEFT,1);
            WRITE(L,LAST_CHNGG,LEFT,2);
            WRITE(L,string'(" "),LEFT,1);
            WRITE(L,LAST_CHNGH,LEFT,2);
            WRITE(L,string'(" "),LEFT,1);
            WRITE(L,LAST_CHNGI,LEFT,2);
            WRITE(L,string'(" "),LEFT,1);
            WRITE(L,LAST_CHNGJ,LEFT,2);
            WRITE(L,string'(" "),LEFT,1);
            WRITE(L,NOW,LEFT);
            WRITELINE(F,L);
      end if;
    end if;
end process;
-- coverage on
-- ******************************************************************
-- *********************** Component Instantiations *****************
-- ******************************************************************
CHIP: DELTA
   port map (RESET => RESET,
             CLOCK => CLOCK,
             ADDRESS => ADDRESS,
             PDATA => PDATA,
             RDB => CHIP_RDB,
             CSB => CSB,
             WRB => CHIP_WRB,
             CRC_WRITE => CRC_WRITE,
             CRC_READ => CRC_READ,
             CRC_ADDRESS => CRC_ADDRESS,
             CRC => CRC,
             FIFO_RAM_DATA => FIFO_RAM_DATA,
             FIFO_OUT_CLOCK => FIFO_OUT_CLOCK,
             FIFO_FULL_INDICATE => FIFO_FULL_INDICATE,
             FIFO_EMPTY_INDICATE => FIFO_EMPTY_INDICATE,
             RESET_FIFO => RESET_FIFO,
             MICRO_INTERRUPT => MICRO_INTERRUPT,
             TXC => TXC,
             IOM_SDS1 => IOM_SDS1,
             IOM_SDS2 => IOM_SDS2,
             IOM_DCK => IOM_DCK,
             IOM_DU => IOM_DU_CHIP,
             IOM_DD => IOM_DD,
             PRESCALE_1M => PRESCALE_1M,
             PRESCALE_8M => PRESCALE_8M,
             VARIABLE_ADDRESS => VARIABLE_ADDRESS,
             VARIABLE_RDB => VARIABLE_RDB,
             VARIABLE_WRB => VARIABLE_WRB,
             VARIABLE_DATA => VARIABLE_DATA,
             FS_DATA => FS_DATA,
             FS_ADDRESS => ASIC_FS_ADDRESS,
             MEMCS => CHIP_MEMCS,
             AMUXSEL => AMUXSEL,
             FSOE => FSOE,
             FSWE => FSWE,
             FSSTR => FSSTR,
             FSCS => FSCS,
             SRDY => SRDY,
             CPFSWE => CPFSWE,
             CPFSRD => CPFSRD,
             RXD => RXD,
             TXD => TXD );

end RTL1 ;






















