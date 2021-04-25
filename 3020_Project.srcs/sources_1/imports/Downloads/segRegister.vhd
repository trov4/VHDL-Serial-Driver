----------------------------------------------------------------------------------
-- Fayth Hawkins & Trevor Stanca
-- Create Date: 04/17/2021
-- Project Name: Serial Interface Project
-- Description: This is the Seven SegmentRegister. It takes in an integer input
--              and a 4 bit vector that determines what digit to select.
--              The output is 4 8 bit vectors that are the seven Segment display 
--              bit to be driven by Dr. Tippen's 7SegDriver
---------------------------
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity segRegister is
    Port ( 
    -- inputs
    num   : in integer range 16 downto 0;
    segEn : in std_logic_vector(3 downto 0);
    clock : in std_logic;
    reset : in std_logic;
    
    -- outputs
    digit0 : out std_logic_vector (3 downto 0);
    digit1 : out std_logic_vector (3 downto 0);
    digit2 : out std_logic_vector (3 downto 0);
    digit3 : out std_logic_vector (3 downto 0);
    
    blank0 : out std_logic;
    blank1 : out std_logic;
    blank2 : out std_logic;
    blank3 : out std_logic         
    );
        
end segRegister;

architecture segRegister_ARCH of segRegister is
--------------------------------------------------------------
-- CONSTANTS
--------------------------------------------------------------
 --Seven Segment Display--Constants
    constant BLANK_7SEG: std_logic_vector(3 downto 0) := "1111";
    constant ZERO_7SEG:  std_logic_vector(3 downto 0) := "0000";
    constant ONE_7SEG:   std_logic_vector(3 downto 0) := "0001";
    constant TWO_7SEG:   std_logic_vector(3 downto 0) := "0010";
    constant THREE_7SEG: std_logic_vector(3 downto 0) := "0011";
    constant FOUR_7SEG:  std_logic_vector(3 downto 0) := "0100";
    constant FIVE_7SEG:  std_logic_vector(3 downto 0) := "0101";
    constant SIX_7SEG:   std_logic_vector(3 downto 0) := "0110";
    constant SEVEN_7SEG: std_logic_vector(3 downto 0) := "0111";
    constant EIGHT_7SEG: std_logic_vector(3 downto 0) := "1000";
    constant NINE_7SEG:  std_logic_vector(3 downto 0) := "1001";

 -- input constants
 constant BLANK    : std_logic_vector(3 downto 0) := "0000";
 constant SEL_NUM3 : std_logic_vector(3 downto 0) := "1000";
 constant SEL_NUM2 : std_logic_vector(3 downto 0) := "0100"; 
 constant SEL_NUM1 : std_logic_vector(3 downto 0) := "0010";
 constant SEL_NUM0 : std_logic_vector(3 downto 0) := "0001";
 
 -- signal constnats
 constant ACTIVE : std_logic := '1';
 
 --------------------------------------------------------------
 -- INTERNAL SIGNALS
 --------------------------------------------------------------
 signal bcdFromDec : std_logic_vector(3 downto 0); 
begin

 --decode decimal
 with num select 
 bcdFromDec <= ZERO_7SEG when 0,
            ONE_7SEG when 1,
            TWO_7SEG when 2,
            THREE_7SEG when 3,
            FOUR_7SEG when 4,
            FIVE_7SEG when 5,
            SIX_7SEG when 6,
            SEVEN_7SEG when 7,
            EIGHT_7SEG when 8,
            NINE_7SEG when 9,
            BLANK_7SEG when others;

   REGISTER_SETTER : process(clock, reset, segEn, bcdFromDec) is
   variable num0 : std_logic_vector(3 downto 0) := ZERO_7SEG;
   variable num1 : std_logic_vector(3 downto 0) := ZERO_7SEG;
   variable num2 : std_logic_vector(3 downto 0) := ZERO_7SEG;
   variable num3 : std_logic_vector(3 downto 0) := ZERO_7SEG;
   begin

   -- RESET: set all outputs to 0 
   if(reset = ACTIVE) then
        blank0 <= ACTIVE;
        blank1 <= ACTIVE;
        blank2 <= ACTIVE;
        blank3 <= ACTIVE;
        
   -- set correct segEn when clock and segEn are lit 
   elsif(rising_edge(clock) and segEn/= BLANK) then
       -- default values
       num0 := num0;
       num1 := num1;
       num2 := num2;
       num3 := num3;
       
       digit0 <= num0;
       digit1 <= num1;
       digit2 <= num2;
       digit3 <= num3;
        case (segEn) is
        when SEL_NUM3 =>
            num3 := bcdFromDec;
            blank3 <= not ACTIVE;
        when SEL_NUM2 =>
            num2 := bcdFromDec;
            blank2 <= not ACTIVE;
        when SEL_NUM1 =>
            num1 := bcdFromDec;
            blank1 <= not ACTIVE;
        when others =>
            num0 := bcdFromDec;
            blank0 <= not ACTIVE;
        end case;
   end if;
   end process;
end segRegister_ARCH;
