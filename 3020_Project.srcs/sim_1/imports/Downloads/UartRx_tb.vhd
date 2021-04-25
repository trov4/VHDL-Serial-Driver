library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--*****************************************************************************
--*
--* Name: UartRx Test Bench (Modifying)
--* Designer: Scott Tippens & Paul Pieper
--*
--*     Test the UartRx component by simulating the reception of three values
--*     (X"A5", X"5A", and X"FF").  The test conditions are for a clock rate
--*     of 100 MHz and baud rate of 115200.
--*
--*****************************************************************************

entity UartRx_tb is
end UartRx_tb;



architecture UartRx_tb_ARCH of UartRx_tb is

	----general-definitions--------------------------------------------CONSTANTS--
	constant ACTIVE: std_logic := '1';
	constant CLOCK_FREQ:  integer := 100_000_000;
	constant BAUD_RATE:   integer := 9600;  --115_200;
	constant BIT_TIME:    time    := (1_000_000_000/BAUD_RATE) * 1 ns;

	
	----connections--------------------------------------------------UUT-SIGNALS--
	--signal reset:    std_logic;
	signal RsRx:     std_logic;
	signal clk:      std_logic;
	
	--Basys Replacement Signals----------------------------------------------------
    signal btnD: std_logic;
    --signal btnL: std_logic;
    --signal btnR: std_logic;
    signal an:   std_logic_vector(3 downto 0);
   
    signal sw: std_logic_vector(15 downto 0);
    signal led: std_logic_vector(15 downto 0);
    signal seg: std_logic_vector (6 downto 0);	
    
    ----Components-------------------------------------------------------UartRX--
	component UartRx_Basys3
		port (
	          clk  : in std_logic;
		      --btnL : in std_logic;
              btnD : in std_logic;    --reset button? l a m a y o
              --btnR : in std_logic;
              --btnU : in std_logic;
              --sw   : in std_logic_vector(15 downto 0);
		      RsRx : in std_logic;
           
              led  : out std_logic_vector (15 downto 0);
              seg  : out std_logic_vector (6 downto 0);
              an   : out std_logic_vector (3 downto 0)
              );
	end component UartRx_Basys3;
	
begin

	--============================================================================
	--  UUT
	--============================================================================
	UUT: UartRx_Basys3
		port map (
			  clk => clk,
			  --btnL : in std_logic;
              btnD => btnD,    --reset button? l a m a y o
              --btnR : in std_logic;
              --btnU : in std_logic;
              --sw   => sw,
		      RsRx => RsRx,
           
              led  => led,
              seg  => seg,
              an   => an
			);


	--============================================================================
	--  Reset
	--============================================================================
	SYSTEM_RESET: process
	begin
		btnD <= ACTIVE;
		wait for 15 ns;
		btnD <= not ACTIVE;
		wait;
	end process SYSTEM_RESET;

	
	--============================================================================
	--  Clock
	--============================================================================
	SYSTEM_CLOCK: process
	begin
		clk <= not ACTIVE;
		wait for 5 ns;
		clk <= ACTIVE;
		wait for 5 ns;
	end process SYSTEM_CLOCK;


	--============================================================================
	--  Signal Driver
	--============================================================================
	SIGNAL_DRIVER: process
	begin
	
		----set serial line to idle-----------------------------------------------
		RsRx <= '1';
		wait for BIT_TIME;
		
		--------------------------------------------------------------------------
		--CHECK SEVEN SEGMENT DRIVER, setting to 1075
		--------------------------------------------------------------------------

		----transmit 0x64 (D)---------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;

		
		----transmit 0x31 (1)---------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;

				
		----transmit 0x30 (0)---------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;

		----transmit 0x37 (7)---------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;

		----transmit 0x35 (5)---------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		
		-----------------------------------------------------------------------------
        --Try setting a single digit LED
		-----------------------------------------------------------------------------
        ----transmit 0x4C (L)--------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		
		----transmit 0x30 (0)---------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		
		----transmit 0x37 (7)---------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		
		-----------------------------------------------------------------------------
        --Try un-setting a single digit LED
		-----------------------------------------------------------------------------
        ----transmit 0x4d (M)--------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;

		----transmit 0x30 (0)---------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;

		----transmit 0x37 (7)---------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;

		-----------------------------------------------------------------------------
        --Try setting a two digit LED
		-----------------------------------------------------------------------------
        ----transmit 0x4C (L)--------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		
		----transmit 0x31 (1)---------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;	
		
		----transmit 0x35 (5)---------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		
		-----------------------------------------------------------------------------
        --Try un-setting a two digit LED
		-----------------------------------------------------------------------------
        ----transmit 0x4d (M)--------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		
		----transmit 0x31 (1)---------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;	
		
		----transmit 0x35 (5)---------------------------------------------------------
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '0';
		wait for BIT_TIME;
		RsRx <= '1';
		wait for BIT_TIME;
		
		wait;

	end process SIGNAL_DRIVER;


end UartRx_tb_ARCH;
