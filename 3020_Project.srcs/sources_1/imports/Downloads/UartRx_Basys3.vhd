library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--*****************************************************************************
--*
--* Name: UartRx_Basys3 Test Wrapper (Modifided)
--* Designer: Scott Tippens & Paul Pieper
--*
--*     Connected through USB-Serial to the Basys3 Board.  REWRITE THIS SECTION
--*
--*****************************************************************************

entity UartRx_Basys3 is
	port(
		clk:   in   std_logic;
		--btnL : in std_logic;
        btnD : in std_logic;    --reset button? l a m a y o
        --btnR : in std_logic;
        --btnU : in std_logic;
        --sw   : in std_logic_vector(15 downto 0);
		RsRx:  in std_logic;
           
        led  : out std_logic_vector (15 downto 0);
        seg  : out std_logic_vector (6 downto 0);
        an   : out std_logic_vector (3 downto 0);
        RsTx : out std_logic
        );
end UartRx_Basys3;

architecture UartRx_Basys3_ARCH of UartRx_Basys3 is

	----general-definitions--------------------------------------------CONSTANTS--
	constant ACTIVE: std_logic := '1';
	constant CLOCK_FREQ:  integer := 100_000_000;
	constant BAUD_RATE:   integer := 9600; --6_250_000; --115_200;

	
	----connections--------------------------------------------------Basys3-SIGNALS--
--    signal btnD: std_logic;
--    signal btnL: std_logic;
--    signal btnR: std_logic;
--    signal btnU: std_logic;
--    signal clk:  std_logic;
--    signal an:   std_logic_vector(3 downto 0);
--    signal sw: std_logic_vector(15 downto 0);
--    signal led: std_logic_vector(15 downto 0);
--    signal seg: std_logic_vector (6 downto 0);
    ----connections--------------------------------------------------UartRx-SIGNALS--
    signal dataReady:  std_logic;
    signal data: std_logic_vector(7 downto 0);
    signal dataOut: std_logic_vector(7 downto 0);
    signal onOff: std_logic;
    signal ledEn: std_logic;
    signal enable: std_logic;
    signal digit: std_logic_vector(3 downto 0);
    signal val: integer range 16 downto 0;
    signal segEn: std_logic_vector(3 downto 0);
    signal digit0: std_logic_vector (3 downto 0);
    signal digit1: std_logic_vector (3 downto 0);
    signal digit2: std_logic_vector (3 downto 0);
    signal digit3: std_logic_vector (3 downto 0);
    signal blank0: std_logic;
    signal blank1: std_logic;
    signal blank2: std_logic;
    signal blank3: std_logic;

	----Components-------------------------------------------------------UartRX--
	component UartRx
		generic (
			       BAUD_RATE    : positive := BAUD_RATE; --6_250_000; 115200;
			       CLOCK_FREQ   : positive := 100_000_000
			     ); 
		port (
	               clock        : in  std_logic;
			       reset        : in  std_logic;
			       rxData       : in  std_logic;
	 		
	 		       dataReady    : out std_logic;
			       dataOut      : out std_logic_vector(7 downto 0)
			  );
	end component UartRx;
	
	-----------------------------------------------------------------DataDriver--
	component dataDriver
	   Port (
                -- inputs
                signal dataReady  : in std_logic;
                signal data       : in std_logic_vector(7 downto 0);
                signal reset      : in std_logic;
                signal clk        : in std_logic;
  
                -- outputs
                signal onOff      : out std_logic;
                signal ledEn      : out std_logic;
                signal segEn      : out std_logic_vector(3 downto 0);
                signal val        : out integer range 16 downto 0
             );
	
	end component dataDriver;
	
	------------------------------------------------------------------LedDriver--
	component LedDriver
	   Port ( 
	           reset    : in std_logic;
               clock    : in std_logic;
               onOff    : in std_logic;
               enable   : in std_logic;
               val      : in integer range 16 downto 0;
           
               leds     : out std_logic_vector (15 downto 0)
             );
           
	end component LedDriver;
	
	----------------------------------------------------------------SegRegister--
	component segRegister
	   Port ( 
                -- inputs
                signal num   : in integer range -1 to 17;
                signal segEn : in std_logic_vector(3 downto 0);
                signal clock : in std_logic;
                signal reset : in std_logic;
    
                -- outputs
                signal digit0 : out std_logic_vector (3 downto 0);
                signal digit1 : out std_logic_vector (3 downto 0);
                signal digit2 : out std_logic_vector (3 downto 0);
                signal digit3 : out std_logic_vector (3 downto 0);
                
                signal blank0 : out std_logic;
                signal blank1 : out std_logic;
                signal blank2 : out std_logic;
                signal blank3 : out std_logic                
             );
    
    end component segRegister;
    
    ----------------------------------------------------------------SegRegister--
    component SevenSegmentDriver
        Port(
                reset       : in std_logic;
                clock       : in std_logic;

                digit3      : in std_logic_vector(3 downto 0);    --leftmost digit
                digit2      : in std_logic_vector(3 downto 0);    --2nd from left digit
                digit1      : in std_logic_vector(3 downto 0);    --3rd from left digit
                digit0      : in std_logic_vector(3 downto 0);    --rightmost digit

                blank3      : in std_logic;    --leftmost digit
                blank2      : in std_logic;    --2nd from left digit
                blank1      : in std_logic;    --3rd from left digit
                blank0      : in std_logic;    --rightmost digit

                sevenSegs   : out std_logic_vector(6 downto 0);    --MSB=g, LSB=a
                anodes      : out std_logic_vector(3 downto 0)    --MSB=leftmost digit
             );
    end component SevenSegmentDriver;

begin

	--============================================================================
	--  UartRx
	--============================================================================
	UART_RX: UartRx
		generic map (
			BAUD_RATE  =>  BAUD_RATE,
			CLOCK_FREQ =>  CLOCK_FREQ
			)
		port map (
			    clock     => clk,
			    reset     => btnD,
                rxData    => RsRx,
                dataReady => dataReady,
                dataOut   => dataOut
			);

    --============================================================================
	--  dataDriver
	--============================================================================
	DATA_DRIVER: dataDriver
		port map (  -- inputs
                    dataReady  => dataReady,
                    data       => dataOut,
                    reset      => btnD,
                    clk        => clk,
  
                    -- outputs
                    onOff     => onOff,
                    ledEn     => ledEn,
                    segEn     => segEn, 
                    val       => val
                  );
                  
    --============================================================================
	--  LedDriver
	--============================================================================
	LED_DRIVER: LedDriver
		port map (  -- inputs
                    reset   => btnD,
                    clock   => clk,
                    onOff   => onOff,
                    enable  => ledEn,
                    val     => val,
           
                    leds    => led
                  );              
     
    --============================================================================
	--  segRegister
	--============================================================================
	SEG_REGISTER: segRegister
		Port map  ( 
                   -- inputs
                   num      => val,
                   segEn    => segEn,
                   clock    => clk,
                   reset    => btnD,
    
                   -- outputs
                   digit0     => digit0,
                   digit1     => digit1,
                   digit2     => digit2,
                   digit3     => digit3,
                   
                   blank0    => blank0,
                   blank1    => blank1,
                   blank2    => blank2,
                   blank3    => blank3        
                   );
    --============================================================================
	--  SevenSegmentDriver
	--============================================================================
	SEG_DRIVER: SevenSegmentDriver
		Port map  (           
                   reset        => btnD,
                   clock        => clk,

                   digit3       =>    digit3,         --leftmost digit
                   digit2       =>    digit2,         --2nd from left digit
                   digit1       =>    digit1,         --3rd from left digit
                   digit0       =>    digit0,         --rightmost digit

                   blank3       =>    blank3,   --leftmost digit
                   blank2       =>    blank2,   --2nd from left digit
                   blank1       =>    blank1,   --3rd from left digit
                   blank0       =>    blank0,   --rightmost digit

                   sevenSegs    =>    seg,          --MSB=g, LSB=a
                   anodes       =>    an            --MSB=leftmost digit
                   );

end UartRx_Basys3_ARCH;
