----------------------------------------------------------------------------------
-- Trevor Stanca
-- April 7, 2021
--
-- dataDriver
--  Used for the final project in CPE 3020. Will take the outputs from the UARTRX
--  block given and will drive decode the inputs into something of meaning. 
--  This will start will signally the led driver and sevenSegment Driver.
--
-- Inputs:
--  dataReady
--  data
--  reset
--  clk
--
-- Outputs:
--  ledEnable
--  onOff
--  segEn
--  val
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity dataDriver is
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
   end dataDriver;

architecture dataDriver_ARCH of dataDriver is
-- constants
--------------------------------------------------------
-- ascii -- up is uppercase -- low is lowercase
--------------------------------------------------------
-- letters
constant ASCII_L_UP  : std_logic_vector(7 downto 0) := "0100" & "1100"; --4C 
constant ASCII_L_LOW : std_logic_vector(7 downto 0) := "0110" & "1100"; --6C

constant ASCII_M_UP  : std_logic_vector(7 downto 0) := "0100" & "1101"; --4D 
constant ASCII_M_LOW : std_logic_vector(7 downto 0) := "0110" & "1101"; --6D

constant ASCII_D_UP  : std_logic_vector(7 downto 0) := "0100" & "0100"; --44
constant ASCII_D_LOW : std_logic_vector(7 downto 0) := "0110" & "0100"; --64

-- numbers
constant ASCII_0 : std_logic_vector (7 downto 0) := "0011" & "0000"; -- 33
constant ASCII_1 : std_logic_vector (7 downto 0) := "0011" & "0001";
constant ASCII_2 : std_logic_vector (7 downto 0) := "0011" & "0010";
constant ASCII_3 : std_logic_vector (7 downto 0) := "0011" & "0011"; 
constant ASCII_4 : std_logic_vector (7 downto 0) := "0011" & "0100";
constant ASCII_5 : std_logic_vector (7 downto 0) := "0011" & "0101";
constant ASCII_6 : std_logic_vector (7 downto 0) := "0011" & "0110";
constant ASCII_7 : std_logic_vector (7 downto 0) := "0011" & "0111";
constant ASCII_8 : std_logic_vector (7 downto 0) := "0011" & "1000";
constant ASCII_9 : std_logic_vector (7 downto 0) := "0011" & "1001"; --39
 
-- null
constant ASCII_N : std_logic_vector (7 downto 0) :="0000" & "0000"; -- 00
--------------------------------------------------------
-- control constants
--------------------------------------------------------
constant HIGH : std_logic := '1';
constant LOW  : std_logic := '0';

constant DIG3 : std_logic_vector(3 downto 0) := "1000";
constant DIG2 : std_logic_vector(3 downto 0) := "0100";
constant DIG1 : std_logic_vector(3 downto 0) := "0010";
constant DIG0 : std_logic_vector(3 downto 0) := "0001";

--------------------------------------------------------
-- internal sigals
--------------------------------------------------------
-- to convert the input number too
signal asciiNum : integer range 9 downto -4;

-- state machine 
type ledStates_t is (WAITING, LED_ON_START, LED_OFF_Start,
                     LED_ON_DIG1, LED_ON_DIG2, LED_OFF_DIG1,
                     LED_OFF_DIG2, SEG_WAIT, SEG_3, SEG_2,
                     SEG_1, SEG_0);
signal current_state : ledStates_t;

begin
-- convert ascii to integer. Encode each letter
-- and have -1 be the default.
-- -2 is ledOn, -3 is ledOff, -4 is segment
with data select 
asciiNum <= 0 when ASCII_0,
            1 when ASCII_1,
            2 when ASCII_2,
            3 when ASCII_3,
            4 when ASCII_4,
            5 when ASCII_5,
            6 when ASCII_6,
            7 when ASCII_7,
            8 when ASCII_8,
            9 when ASCII_9,
            
            -- encoding, take lowercase or upper case
            -2 when ASCII_L_UP,
            -2 when ASCII_L_LOW,
            -3 when ASCII_M_UP,
            -3 when ASCII_M_LOW,
            -4 when ASCII_D_UP,
            -4 when ASCII_D_LOW,
            
            -- default
            -1 when others;

STATE_ACTION : process (clk, reset) is 
variable internalVal : integer range 0 to 16 := 16;
variable set          : boolean := FALSE;      
begin
-- prevent latching
if (reset = HIGH) then
    current_state <= WAITING;
elsif(rising_edge(clk)) then
    -- default values
    onOff <= LOW;
    ledEn <= LOW;
    internalVal := internalVal;
    set := set;
    val <= internalVal;
    segEn <= (others => LOW);
    
current_state <= current_state;
--------------------------------------------------------------------------
-- statemachine
--------------------------------------------------------------------------
case (current_state) is
    when WAITING =>     
       set := FALSE;
           
        if (dataReady = HIGH) then
            if (asciiNum = -2) then
                current_state <= LED_ON_START;
            elsif (asciiNum = -3) then
                current_state <= LED_OFF_START;
            elsif( asciiNum = -4) then
                current_state <= SEG_WAIT;
            end if;
        end if;

    -----------------------------------------
    -- 7 seg setting sequence
    -----------------------------------------
      when SEG_WAIT => 
            if (dataReady = LOW and not set) then
               set := TRUE; 
            elsif (dataReady = HIGH and set) then
                set := FALSE;
                current_state <= SEG_3;
                segEn <= DIG3;
                internalVal := asciiNum;
            end if;
            
      when SEG_3 =>
            if (not set) then
                segEn <= DIG3;
            end if;
            
            if(dataReady = LOW) then 
                set := TRUE;
            elsif(dataReady = HIGH) then
                set := FALSE;
                segEn <= DIG2;
                internalVal := asciiNum;
                val <= internalVal;
                current_state <= SEG_2;
            end if;
            
      when SEG_2 =>
            if (not set) then
                segEn <= DIG2;
            end if;
            
            if(dataReady = LOW) then 
                set := TRUE;
            elsif(dataReady = HIGH) then
                set := FALSE;
                segEn <= DIG1;
                internalVal := asciiNum;
                val <= internalVal;
                current_state <= SEG_1;
            end if;
            
      when SEG_1 => 
             if (not set) then
                segEn <= DIG1;
            end if;
            
            if(dataReady = LOW) then 
                set := TRUE;
            elsif(dataReady = HIGH) then
                set := FALSE;
                segEn <= DIG0;
                internalVal := asciiNum;
                val <= internalVal;
                current_state <= SEG_0;
            end if;
            
      when SEG_0 =>
            if (not set) then
                segEn <= DIG0;
            end if;
            
            if(dataReady = LOW) then 
                set := TRUE;
                current_state <= WAITING;
            end if;
    -----------------------------------------
    -- led ON sequence
    -----------------------------------------
    when LED_ON_START =>
        if (dataReady = LOW) then
            current_state <= LED_ON_DIG1;
        end if;
        
    when LED_ON_DIG1 => 
        if ( dataReady = HIGH) then
            internalVal := 10*asciiNum;
            val <= internalVal;
            set := TRUE; 
        elsif( dataReady = LOW and set) then
            set := FALSE;
            current_state <= LED_ON_DIG2;
        end if;
        
    when LED_ON_DIG2 => 
        if ( dataReady = HIGH) then
            internalVal := internalVal + asciiNum;
            val <= internalVal;
            set := TRUE; 
            onOff <= HIGH;
            ledEn <= HIGH;
            
        elsif( dataReady = LOW and set) then
            set := FALSE;
            current_state <= WAITING;
        end if;

    -----------------------------------------
    -- led OFF sequence
    -----------------------------------------        
    when LED_OFF_START =>
        if (dataReady = LOW) then
            current_state <= LED_OFF_DIG1;
        end if;
        
    when LED_OFF_DIG1 => 
        if ( dataReady = HIGH) then
            internalVal := 10*asciiNum;
            set := TRUE; 
        elsif( dataReady = LOW and set) then
            set := FALSE;
            current_state <= LED_OFF_DIG2;
        end if;
        
    when LED_OFF_DIG2 =>
        if ( dataReady = HIGH) then
            internalVal := internalVal + asciiNum;
            val <= internalVal;
            set := TRUE; 
            ledEn <= HIGH;
            
        elsif( dataReady = LOW and set) then
            set := FALSE;
            current_state <= WAITING;
        end if; 
end case;
end if;
end process;

end dataDriver_ARCH;