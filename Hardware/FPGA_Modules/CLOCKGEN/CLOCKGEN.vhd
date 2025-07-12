----------------------------------------------------------------------------------
-- Company: University of Malaga
-- Engineer: Manuel Sanchez Natera
-- 
-- Create Date: 16/04/2025 20:28:34
-- Design Name: Speed Traffic Sign Recognition System
-- Module Name: CLOCKGEN 
-- Project Name: Speed Traffic Sign Recognition System
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  This module generate a clock signal as result of divide the input clock signal.
-- Dependencies: 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity CLOCKGEN is
   Generic(
			NCYCLES: NATURAL := 3 -- 1 ==> count 2 CLKREF rising edge to divide the CLKREF by 4; 3 ==> count 4 CLKREF rising edge to divide the CLKREF by 8
    );
    Port (    
            CLKREF  : in STD_LOGIC;
            RST     : in STD_LOGIC;
            
            CLKGEN  : out STD_LOGIC
        );
end CLOCKGEN;

architecture Behavioral of CLOCKGEN is

signal clk_gen       : STD_LOGIC;
signal cycles_count  : NATURAL;

begin

    CLKDIVIDER: process
    begin
        wait until (CLKREF'EVENT and CLKREF = '1');
            if RST = '1' then
                cycles_count <= 0;
                clk_gen <= '0';
            elsif cycles_count < NCYCLES then
                cycles_count <= cycles_count + 1;
            else
                clk_gen <= not clk_gen;
                cycles_count <= 0;
            end if;
    end process CLKDIVIDER;

    -- Signal connections
    CLKGEN <= clk_gen;
   
end Behavioral;
