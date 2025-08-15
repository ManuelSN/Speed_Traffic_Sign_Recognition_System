----------------------------------------------------------------------------------
-- Company: University of Malaga
-- Engineer: Manuel Sanchez Natera
-- 
-- Create Date: 16/04/2025 20:28:34
-- Design Name: Speed Traffic Sign Recognition System
-- Module Name: DISP7SEG 
-- Project Name: Speed Traffic Sign Recognition System
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  This module shows a value on the BASYS3 7 segments display.
-- Dependencies: 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity DISP7SEG is
  Generic (
    -- refresh_ms = (2^CLK_COUNT_BITS) / CLK(HZ))
    CLK_COUNT_BITS : NATURAL := 20 --  defines the length of a counter that controls the refresh rate of the display. (20bits -> refresh period of 10.5ms (380Hz), we can refresh up to 4 digits, so 2.62ms digit refresh period)
  );
    Port ( CLK   : in STD_LOGIC;
           RST   : in STD_LOGIC;
           CAT   : out STD_LOGIC_VECTOR (7 downto 0);
           AN    : out STD_LOGIC_VECTOR (3 downto 0);
           VALUE : in NATURAL range 0 to 999
          );       -- Only 3 digits are represented (decimal format)
end DISP7SEG;

architecture Behavioral of DISP7SEG is

-- Aliases for the cathodes of the 7 segments related to the units (the “DP” decimal point is unconnected):
alias CA  : STD_LOGIC is CAT(0);
alias CB  : STD_LOGIC is CAT(1);
alias CC  : STD_LOGIC is CAT(2);
alias CD  : STD_LOGIC is CAT(3);
alias CE  : STD_LOGIC is CAT(4);
alias CF  : STD_LOGIC is CAT(5);
alias CG  : STD_LOGIC is CAT(6);
-- Signals for 7segments value:
signal SEGMENTS : STD_LOGIC_VECTOR(6 downto 0);

-- Signals to connect each 7 segments that will represent each digit corresponding to the values of the units, tens and hundreds 
-- respectively of the input VALUE to the module that comes in decimal format:
subtype digit_type is NATURAL range 0 to 9;
signal  digit : digit_type;
signal UNITS_DIGIT, TENS_DIGIT, HUNDREDS_DIGIT : digit_type;

-- This signal determines how many number of cycles to reserve for each digit (refresh time window)
signal clk_cnt   : UNSIGNED(CLK_COUNT_BITS - 1 downto 0);
signal digit_sel : UNSIGNED(1 downto 0); -- 2MSB

begin
    
    -- The exact frequency is not essential. Select a counter length that lies in the range from 50 to a couple of hundred Hertz.
    COUNT: process(RST, CLK)
    begin
        if (CLK'EVENT and CLK = '1') then
            if RST = '1' then
                clk_cnt <= (others => '0');
            else
                clk_cnt <= clk_cnt + 1;       
            end if;
        end if;
    end process COUNT;
    digit_sel <= clk_cnt((CLK_COUNT_BITS - 1) downto (CLK_COUNT_BITS - 2)); -- 2MSB of clk_cnt


    HUNDREDS_DIGIT <= VALUE/100;
    TENS_DIGIT <= ((VALUE - (HUNDREDS_DIGIT*100))/10);
    UNITS_DIGIT <= VALUE - (HUNDREDS_DIGIT*100) - (TENS_DIGIT*10);
    DIGSELECT: process(digit_sel, UNITS_DIGIT, TENS_DIGIT, HUNDREDS_DIGIT)
    begin
        digit <= 0; 
        case digit_sel is  
             when "00" =>
                digit <= UNITS_DIGIT; 
                AN <= "1110"; 
             when "01" => 
                digit <= TENS_DIGIT; 
                AN <= "1101";
             when "10" => 
                digit <= HUNDREDS_DIGIT; 
                AN <= "1011";
            when others => 
                AN <= "1111";
        end case;
     end process DIGSELECT;
     
    DISPLAY: process(digit)
    begin
        case digit is  
            when 0 =>   SEGMENTS <= "0000001";  
            when 1 =>   SEGMENTS <= "1001111"; 
            when 2 =>   SEGMENTS <= "0010010";
            when 3 =>   SEGMENTS <= "0000110";
            when 4 =>   SEGMENTS <= "1001100";
            when 5 =>   SEGMENTS <= "0100100";
            when 6 =>   SEGMENTS <= "0100000";
            when 7 =>   SEGMENTS <= "0001111";
            when 8 =>   SEGMENTS <= "0000000";
            when 9 =>   SEGMENTS <= "0000100";              
        end case;
     end process DISPLAY;
     
    (CA,CB,CC,CD,CE,CF,CG) <= SEGMENTS;

end Behavioral;
