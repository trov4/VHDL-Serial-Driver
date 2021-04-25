----------------------------------------------------------------------------------
-- Program:     Led_Driver
-- Author:      Paul Pieper
-- Professor:   Scott Tippens
-- Date:        2021-10-4
--
-- Desc:        This is the LED Driver for the CPE3020 VHDL Project. This is a
--              switch-case statement that will check for 3 input enable signals
--              in order to determine which LED should be changed and to what 
--              state it should be changed to.
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity LedDriver is
    Port ( reset        : in std_logic;
           clock        : in std_logic;
           onOff        : in std_logic;
           enable       : in std_logic;
           val          : in integer range 15 downto 0;
           
           leds         : out std_logic_vector (15 downto 0));
end LedDriver;

architecture LedDriver_ARCH of LedDriver is

----general definitions--------------------------------------CONSTANTS
constant ACTIVE:    std_logic := '1';
constant NO_LED:    std_logic_vector := "0000000000000000";

begin
    
--====================================================================
--  ENABLE_DISABLE_LED
--  Checks for enable signal on rising_edge(clock). If enable = active
--  it will check for onOff signal. ACTIVE means turn corresponding
--  LED on, NOT ACTIVE means turn that LED off.
--====================================================================
ENABLE_DISABLE_LED: process(reset, clock)
begin
    if (reset = ACTIVE) then
        leds <= (others=>'0');
    elsif (rising_edge(clock)) then
        if (enable = ACTIVE) then
            leds(val) <= onOff;
        end if;
     end if;
end process;

end LedDriver_ARCH;
