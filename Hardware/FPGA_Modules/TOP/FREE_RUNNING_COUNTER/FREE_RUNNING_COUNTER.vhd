----------------------------------------------------------------------------------
-- Company: University of Malaga
-- Engineer: Manuel Sánchez Natera
-- 
-- Create Date: 23.11.2024 13:01:25
-- Design Name: 
-- Module Name: FREE_RUNNING_COUNTER - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FREE_RUNNING_COUNTER is
    Generic (
        NBITS : NATURAL := 8 -- Free-running counter of NBITS
    );
    
    Port ( CLK : in STD_LOGIC;
           COUNT : out STD_LOGIC_VECTOR(NBITS-1 downto 0));
           
end FREE_RUNNING_COUNTER;

architecture Behavioral of FREE_RUNNING_COUNTER is

signal COUNT_REG  : UNSIGNED(NBITS-1 downto 0);
signal COUNT_NEXT : UNSIGNED(NBITS-1 downto 0);

begin

    -- NBITS FREE-RUNNING COUNTER
    process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            COUNT_REG <= COUNT_NEXT;
        end if;
    end process;
    -- Next state logic
    COUNT_NEXT <= COUNT_REG + 1;
    COUNT <= STD_LOGIC_VECTOR(COUNT_REG);  
    
end Behavioral;
