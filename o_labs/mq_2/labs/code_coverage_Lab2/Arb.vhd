--
--	Project  : DELTA ASIC
--                 Delay Equalisation Logic for Timeslot Aggregation 
--
-- 	Filename : arbitrator.ent.vhdl
--
--	Author   : D. K. May
--
--	Date     : 26th April 1994
--
--	SCCS     : %W% %G%
--
-- Description :
--
-- The entity declaration for the frame store arbitrator.
--
-- Modifications
--
-- 26/04/94 DKM     1.1  Original


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ARBITRATOR is
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
end;
--
--	Project  : DELTA ASIC
--                 Delay Equalisation Logic for Timeslot Aggregation
--
-- 	Filename : arbitrator.beh.vhdl
--
--	Author   : D. K. May
--
--	Date     : 26th April 1994
--
--	SCCS     : %W% %G%
--
-- Description :
--
-- The architecture declaration for the frame store arbitrator.
-- This is used to control the accesses to the frame store, as 
-- both the micro and the post/pre processor require access.
-- Basicly the ASIC is given priority over the micro. If the 
-- micro is in the middle of a cycle then SRDY is used to add
-- wait states to the micro cycle while the ASIC accesses the 
-- Frame store. If the ASIC is in the middle of an access and
-- the micro requests access it is again held by wait states.
--
-- Modifications
--
-- 26/04/94 DKM     1.1  Original


architecture RTL of ARBITRATOR is
  type FS_STATE is (IDLE,PRE_PROC_WR1,PRE_PROC_WR2,POST_PROC_RD,
                    CPU_READ1,CPU_READ2,CPU_WR1,CPU_WR2);
  signal FRAME_STORE_STATE: FS_STATE;
  signal RDFLAG_KEEP: STD_LOGIC;
  signal WRFLAG_KEEP: STD_LOGIC;
  signal WRFLAG: STD_LOGIC;
  signal RDFLAG: STD_LOGIC;
  signal CPU_RD_DELAYED: STD_LOGIC;
  signal CPU_WR_DELAYED: STD_LOGIC;
  signal ADDRESS_MUX_SEL: STD_LOGIC;
begin
STATE_MAC: process
  begin
    wait until RISING_EDGE (CLOCK);
      if RESET = '0' then
        FRAME_STORE_STATE      <= IDLE;
        ADDRESS_MUX_SEL        <= '0';
        FRAME_STORE_WE         <= '1';
        FRAME_STORE_OE         <= '1';
        RDFLAG_KEEP            <= '1';
        WRFLAG_KEEP            <= '1';
        FRAME_STORE_STROBE     <= '1';
        CPU_FS_WE              <= '1';
      else
        case FRAME_STORE_STATE is
        when IDLE =>
          if PRE_PROC_WR_REQUEST = '0' then
            FRAME_STORE_STATE <= PRE_PROC_WR1;
            ADDRESS_MUX_SEL <= '1';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          elsif POST_PROC_RD_REQUEST = '0' then
            FRAME_STORE_STATE <= POST_PROC_RD;
            ADDRESS_MUX_SEL <= '1';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '0';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          elsif WRFLAG = '1' then
            FRAME_STORE_STATE <= CPU_WR1;
            ADDRESS_MUX_SEL <= '0';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          elsif RDFLAG = '1' then
            FRAME_STORE_STATE <= CPU_READ1;
            ADDRESS_MUX_SEL <= '0';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          else
            FRAME_STORE_STATE <= IDLE;
            ADDRESS_MUX_SEL <= '0';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          end if;
        when PRE_PROC_WR1 =>
          FRAME_STORE_STATE <= PRE_PROC_WR2;
          ADDRESS_MUX_SEL <= '1';
          FRAME_STORE_WE  <= '0';
          FRAME_STORE_OE  <= '1';
          RDFLAG_KEEP     <= '1';
          WRFLAG_KEEP     <= '1';
          FRAME_STORE_STROBE     <= '1';
          CPU_FS_WE     <= '1';
        when PRE_PROC_WR2 =>
          if WRFLAG = '1' then
            FRAME_STORE_STATE <= CPU_WR1;
            ADDRESS_MUX_SEL <= '0';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          elsif RDFLAG = '1' then
            FRAME_STORE_STATE <= CPU_READ1;
            ADDRESS_MUX_SEL <= '0';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          else
            FRAME_STORE_STATE <= IDLE;
            ADDRESS_MUX_SEL <= '0'; 
            FRAME_STORE_WE  <= '1'; 
            FRAME_STORE_OE  <= '1'; 
            RDFLAG_KEEP     <= '1'; 
            WRFLAG_KEEP     <= '1'; 
            FRAME_STORE_STROBE     <= '1'; 
            CPU_FS_WE     <= '1';
          end if;
        when POST_PROC_RD =>
          if WRFLAG = '1' then
            FRAME_STORE_STATE <= CPU_WR1;
            ADDRESS_MUX_SEL <= '0';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          elsif RDFLAG = '1' then 
            FRAME_STORE_STATE <= CPU_READ1;
            ADDRESS_MUX_SEL <= '0';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          else  
            FRAME_STORE_STATE <= IDLE;
            ADDRESS_MUX_SEL <= '0';  
            FRAME_STORE_WE  <= '1';  
            FRAME_STORE_OE  <= '1';  
            RDFLAG_KEEP     <= '1';  
            WRFLAG_KEEP     <= '1';  
            FRAME_STORE_STROBE     <= '1';  
            CPU_FS_WE     <= '1';
          end if;
        when CPU_READ1 =>
          if PRE_PROC_WR_REQUEST = '0' then
            FRAME_STORE_STATE <= PRE_PROC_WR1;
            ADDRESS_MUX_SEL <= '1';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          elsif POST_PROC_RD_REQUEST = '0' then
            FRAME_STORE_STATE <= POST_PROC_RD;
            ADDRESS_MUX_SEL <= '1';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '0';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          else
            FRAME_STORE_STATE <= CPU_READ2;
            ADDRESS_MUX_SEL <= '0';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '0';
            RDFLAG_KEEP     <= '0';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '0';
            CPU_FS_WE     <= '1';
          end if; 
        when CPU_READ2 =>
          if PRE_PROC_WR_REQUEST = '0' then
            FRAME_STORE_STATE <= PRE_PROC_WR1;
            ADDRESS_MUX_SEL <= '1';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          elsif POST_PROC_RD_REQUEST = '0' then
            FRAME_STORE_STATE <= POST_PROC_RD;
            ADDRESS_MUX_SEL <= '1';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '0';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          else
            FRAME_STORE_STATE <= IDLE;
            ADDRESS_MUX_SEL <= '0';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          end if; 
        when CPU_WR1 =>
          if PRE_PROC_WR_REQUEST = '0' then 
            FRAME_STORE_STATE <= PRE_PROC_WR1; 
            ADDRESS_MUX_SEL <= '1';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          elsif POST_PROC_RD_REQUEST = '0' then 
            FRAME_STORE_STATE <= POST_PROC_RD; 
            ADDRESS_MUX_SEL <= '1';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '0';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          else 
            FRAME_STORE_STATE <= CPU_WR2;
            ADDRESS_MUX_SEL <= '0';
            FRAME_STORE_WE  <= '0';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '0';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '0';
          end if;  
        when CPU_WR2 =>
          if PRE_PROC_WR_REQUEST = '0' then 
            FRAME_STORE_STATE <= PRE_PROC_WR1; 
            ADDRESS_MUX_SEL <= '1';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          elsif POST_PROC_RD_REQUEST = '0' then 
            FRAME_STORE_STATE <= POST_PROC_RD;  
            ADDRESS_MUX_SEL <= '1';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '0';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          else  
            FRAME_STORE_STATE <= IDLE; 
            ADDRESS_MUX_SEL <= '0';
            FRAME_STORE_WE  <= '1';
            FRAME_STORE_OE  <= '1';
            RDFLAG_KEEP     <= '1';
            WRFLAG_KEEP     <= '1';
            FRAME_STORE_STROBE     <= '1';
            CPU_FS_WE     <= '1';
          end if;   
        when others =>
          null;
        end case;
      end if;
  end process;

FLAG_GEN: process
  begin
    wait until RISING_EDGE (CLOCK);
      CPU_RD_DELAYED <= CPU_RD;
      if RESET = '0' or RDFLAG_KEEP = '0' then
        RDFLAG <= '0';
      elsif CPU_RD = '0' and CPU_RD_DELAYED = '1' and MEMORY_CS = '0' then
        RDFLAG <= '1';
      end if;
      CPU_WR_DELAYED <= CPU_WR;
      if RESET = '0' or WRFLAG_KEEP = '0' then
        WRFLAG <= '0';
      elsif CPU_WR = '0' and CPU_WR_DELAYED = '1' and MEMORY_CS = '0' then
        WRFLAG <= '1';
      end if;
  end process;

FRAME_STORE_CS <= ADDRESS_MUX_SEL nor (not(ADDRESS_MUX_SEL) and (CPU_RD nand CPU_WR) and not(MEMORY_CS));
CPU_READY <= not((RDFLAG_KEEP and RDFLAG) or (WRFLAG_KEEP and WRFLAG)) ;
CPU_FS_RD <= CPU_RD or MEMORY_CS ;
ADD_MUX_SEL <= ADDRESS_MUX_SEL;

end RTL;
