----------------------------------------------------------------------------------
-- Company: University of Malaga
-- Engineer: Manuel Sanchez Natera
-- 
-- Create Date: 16/04/2025 20:28:34
-- Design Name: Speed Traffic Sign Recognition System
-- Module Name: FIFO
-- Project Name: Speed Traffic Sign Recognition System
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  This module is a memory that allows to save images from sensor while sending it to PC. 
-- Dependencies: 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FIFO is

 Generic (
            ADDR_WIDTH : NATURAL range 1 to 63 := 16;       -- Address Bus Width
            DATA_WIDTH : NATURAL range 1 to 16 := 8         -- Data Bus Width
    );
    
    Port ( CLK      : in STD_LOGIC;
           RST      : in STD_LOGIC;
           DIN      : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           PUSH     : in STD_LOGIC;
           POP      : in STD_LOGIC;
           FULL     : out STD_LOGIC;
           DOUT     : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           EMPTY    : out STD_LOGIC);
end FIFO;

architecture Behavioral of FIFO is

-- CONSTANT
constant RAM_DEPTH : integer := 2**ADDR_WIDTH;

-- Signals declaration for LUTram
signal fifo_full, fifo_empty : STD_LOGIC;

type ram_type is array (RAM_DEPTH-1 downto 0) of STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
signal ram_name : ram_type;

signal wr_en, r_en  : STD_LOGIC;

-- Signals declaration for counter of FIFO logic control
signal WPOINTER_REG, RPOINTER_REG   : INTEGER range 0 to (RAM_DEPTH-1) := 0;
signal WPOINTER_NEXT, RPOINTER_NEXT : INTEGER range 0 to (RAM_DEPTH-1) := 0;
signal FIN_W, FIN_R                 : STD_LOGIC;

-- Signals declaration for counter of FIFO logic state
signal WORD_COUNTER_REG   : INTEGER range 0 to (RAM_DEPTH) := 0;

begin


-- Depending on the size and the synthesis tool, this encoding may cause a BlockRAM to be inferred instead of a LUTRAM. 
-- However, this is not absolute: in very small FIFOs, some synthesisers may still use LUTRAM even with synchronous reading.
LUTRAM:process
begin
    wait until rising_edge(CLK);
    if wr_en = '1' then 
        ram_name(WPOINTER_REG) <= DIN;  -- write port
    end if;
    DOUT <= ram_name(RPOINTER_REG);     -- read port 
end process;

-- Control logic
wr_en <= '1' when (PUSH = '1' and fifo_full = '0') else '0';
r_en  <= '1' when (POP = '1' and fifo_empty = '0') else '0';

UPDATE_POINTERS:process(CLK, RST)
begin
    if (CLK'event and CLK = '1') then
        if (RST = '1') then
            WPOINTER_REG <= 0;
            RPOINTER_REG <= 0;
        else
            if (FIN_W = '1') then
                WPOINTER_REG <= 0;
            else
                WPOINTER_REG <= WPOINTER_NEXT;
            end if;
          
            if (FIN_R = '1') then
                RPOINTER_REG <= 0;
            else
                RPOINTER_REG <= RPOINTER_NEXT;
            end if;
        end if;   
    end if;
end process;

WPOINTER_NEXT <= WPOINTER_REG + 1 when (wr_en = '1') else WPOINTER_REG;
RPOINTER_NEXT <= RPOINTER_REG + 1 when (r_en = '1') else RPOINTER_REG;
-- Counter End logic
FIN_W <= '1' when WPOINTER_REG = RAM_DEPTH-1 else '0';
FIN_R <= '1' when RPOINTER_REG = RAM_DEPTH-1 else '0';     

WORD_COUNTER:process(CLK, RST, wr_en, r_en)
begin
    if (CLK'event and CLK = '1') then
        if (RST = '1') then
            WORD_COUNTER_REG <= 0;
        elsif (wr_en = '0' and r_en = '1') then
            WORD_COUNTER_REG <= WORD_COUNTER_REG - 1;
        elsif (wr_en = '1' and r_en = '0') then
            WORD_COUNTER_REG <= WORD_COUNTER_REG + 1;
        end if;
    end if; 
end process;

-- FIFO state control
fifo_empty <= '1' when (WORD_COUNTER_REG = 0) else '0';
fifo_full <= '1' when (WORD_COUNTER_REG = RAM_DEPTH) else '0';

-- Output logic 
FULL <= fifo_full;
EMPTY <= fifo_empty;

end Behavioral;
