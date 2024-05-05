--
--	Project  : DELTA ASIC
--                 Delay Equalisation Logic for Timeslot Aggregation 
--
-- 	Filename : fs_add_mux.ent.vhdl
--
--	Author   : D. K. May
--
--	Date     : 26th April 1994
--
--	SCCS     : %W% %G%
--
-- Description :
--
-- The entity declaration for the frame store address mux.
--
-- Modifications
--
-- 26/04/94 DKM     1.1  Original


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FS_ADD_MUX is
  port (A: in STD_LOGIC_VECTOR(18 downto 0);
        B: in STD_LOGIC_VECTOR(18 downto 0);
        SEL: in STD_LOGIC;
        SWITCH: out STD_LOGIC_VECTOR(18 downto 0));
end;
--
--	Project  : DELTA ASIC
--                 Delay Equalisation Logic for Timeslot Aggregation
--
-- 	Filename : fs_add_mux.beh.vhdl
--
--	Author   : D. K. May
--
--	Date     : 26th April 1994
--
--	SCCS     : %W% %G%
--
-- Description :
--
-- The architecture declaration for the frame store address mux.
-- This is used to select between the address generatored by the
-- Post processor and the pre processor.
--
-- Modifications
--
-- 26/04/94 DKM     1.1  Original


architecture RTL of FS_ADD_MUX is
begin
  MUX: process (A,B,SEL)
  begin
    if SEL = '1' then
      SWITCH <= A;
    else
      SWITCH <= B;
    end if;
  end process;
end RTL;
