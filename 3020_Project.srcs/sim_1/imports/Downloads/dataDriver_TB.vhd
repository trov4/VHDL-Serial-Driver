----------------------------------------------------------------------------------
-- Trevor Stanca
-- April 13, 2021
--
-- dataDriver_TB:
--  The test bench for the dataDriver block, will transition to each point in
--  the statemachine for dataDriver and compore the output signals with what is
--  expected
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dataDriver_TB is
end dataDriver_TB;

architecture dataDriver_TB_ARCH of dataDriver_TB is
--CONSTANTS-----------------------------------------------------------------------
constant ACTIVE : std_logic := '1';
constant HIGH   : std_logic := '1';
constant LOW    : std_logic := '0';

-- letters
constant ASCII_L_UP  : std_logic_vector(7 downto 0) := "0100" & "1100"; --4C 
constant ASCII_L_LOW : std_logic_vector(7 downto 0) := "0110" & "1100"; --6C

constant ASCII_M_UP  : std_logic_vector(7 downto 0) := "0100" & "1101"; --4D 
constant ASCII_M_LOW : std_logic_vector(7 downto 0) := "0110" & "1101"; --6D

constant ASCII_D_UP  : std_logic_vector(7 downto 0) := "0100" & "0100"; --44
constant ASCII_D_LOW : std_logic_vector(7 downto 0) := "0110" & "0100"; --64

-- numbers
constant ASCII_0 : std_logic_vector (7 downto 0) := "0011" & "0011"; -- 33
constant ASCII_1 : std_logic_vector (7 downto 0) := "0011" & "0100";
constant ASCII_2 : std_logic_vector (7 downto 0) := "0011" & "0101";
constant ASCII_3 : std_logic_vector (7 downto 0) := "0011" & "0110"; 
constant ASCII_4 : std_logic_vector (7 downto 0) := "0011" & "0111";
constant ASCII_5 : std_logic_vector (7 downto 0) := "0011" & "1000";
constant ASCII_6 : std_logic_vector (7 downto 0) := "0011" & "1001";
constant ASCII_7 : std_logic_vector (7 downto 0) := "0011" & "1010";
constant ASCII_8 : std_logic_vector (7 downto 0) := "0011" & "1011";
constant ASCII_9 : std_logic_vector (7 downto 0) := "0011" & "1100"; --39

--define component----------------------------------------------------------------
component dataDriver
  Port (
  -- inputs
  signal dataReady  : in std_logic;
  signal data       : in std_logic_vector(7 downto 0);
  signal reset      : in std_logic;
  signal clk        : in std_logic;
  
  -- outputs
  signal onOff      : out std_logic;
  signal ledEn     : out std_logic;
  signal segEn      : out std_logic_vector(3 downto 0);
  signal val        : out integer range 7 downto 0
   ); 
end component;

--inputs into component-----------------------------------------------------------
signal dataReady : std_logic;
signal data      : std_logic_vector (7 downto 0);
signal reset     : std_logic; 
signal clk       : std_logic;

--outputs from component----------------------------------------------------------
signal onOff : std_logic;
signal ledEn : std_logic;
signal segEn : std_logic_vector (3 downto 0);
signal val   : integer range 16 downto 0;

begin
--UUT-----------------------------------------------------------------------------
UUT : dataDriver 
port map (
    -- inputs
    clk       => clk,
    data      => data,
    dataReady => dataReady,
    reset     => reset,
    
    -- outputs
    onOff => onOff,
    ledEn => ledEn,
    segEn => segEn,
    val   => val
);

--SYSTEM_CLOCK : process
--begin 
--        clk <= not ACTIVE;
--        wait for 5 ns;
--        clk <= ACTIVE;
--        wait for 5 ns;
--end process;

SYSTEM_DRIVER : process
begin
    -- reset
    dataReady <= not ACTIVE;
    data <= "00000000";
    reset <= ACTIVE;
    
    wait for 15 ns;
    
    --------------------------------------
    -- check a signle digit led on
    --------------------------------------
    data <= ASCII_L_UP;
    dataReady <= ACTIVE;
    reset <= '0';
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    data <= ASCII_2;
    dataReady <= ACTIVE;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    --------------------------------------
    -- check a single digit led off
    --------------------------------------
    data <= ASCII_M_UP;
    dataReady <= ACTIVE;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
        
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    data <= ASCII_4;
    dataReady <= ACTIVE;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    
    --------------------------------------
    -- check two digit led on
    --------------------------------------
    data <= ASCII_L_UP;
    dataReady <= ACTIVE;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= ACTIVE;
    data <= ASCII_1;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    data <= ASCII_3;
    dataReady <= ACTIVE;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    --------------------------------------
    -- check two digit led off
    --------------------------------------
    data <= ASCII_M_UP;
    dataReady <= ACTIVE;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= ACTIVE;
    data <= ASCII_1;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    data <= ASCII_4;
    dataReady <= ACTIVE;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    --------------------------------------
    -- check seg driver
    --------------------------------------
    data <= ASCII_D_UP;
    dataReady <= ACTIVE;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
        
        -- need some extra time on this one
        
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;
            
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    -- first digit
    data <= ASCII_1;
    dataReady <= ACTIVE;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    -- second digit
    data <= ASCII_2;
    dataReady <= ACTIVE;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;   
    dataReady <= LOW;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    -- third digit
    data <= ASCII_3;
    dataReady <= ACTIVE;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    -- fourth digit
    data <= ASCII_4;
    dataReady <= ACTIVE;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    dataReady <= LOW;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    -------------------------------------------------
    -- check to see if it transitions with any input
    -------------------------------------------------
    data <= ASCII_9;
    dataReady <= ACTIVE;
    
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;    
    reset <= ACTIVE;
    
    wait;    
end process;

end dataDriver_TB_ARCH;
