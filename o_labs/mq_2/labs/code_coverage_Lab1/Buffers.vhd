
-- 


-- VHDL entity and architecture file.

library ieee;
USE ieee.std_logic_1164.all;

ENTITY schmitt IS
   PORT (
      a	: IN    std_logic;
      pi	: IN    std_logic;
      Z	: OUT   std_logic;
      po	: OUT   
   std_logic
   );
END schmitt;

ARCHITECTURE schmitt_ARCH OF schmitt IS
BEGIN
Z <= a;
po <= NOT (a AND pi);
END schmitt_ARCH;

library ieee;
USE ieee.std_logic_1164.all;


ENTITY bd4st IS
   PORT (
      a	: IN    std_logic;
      en	: IN    std_logic;
      tn	: IN    std_logic;
      pi	: IN    std_logic;
      io	: INOUT std_logic;
      zi	: OUT   std_logic;
      po	: OUT   std_logic
   );
END bd4st;

ARCHITECTURE bd4st_ARCH OF bd4st IS
BEGIN
io <= 'Z' WHEN (en = '1' OR tn = '0') ELSE a;
zi <= io;
po <= NOT (pi AND io);
END bd4st_ARCH;

library ieee;
USE ieee.std_logic_1164.all;

ENTITY bt4r IS
   PORT (
      a	: IN    std_logic;
      en	: IN    std_logic;
      tn	: IN    std_logic;
      Z	: OUT   std_logic
   );
END bt4r;

ARCHITECTURE bt4r_ARCH OF bt4r IS

BEGIN 
Z <= 'Z' WHEN (en = '1' OR tn = '0') ELSE a;
END bt4r_ARCH;

