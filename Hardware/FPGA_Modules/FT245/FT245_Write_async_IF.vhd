----------------------------------------------------------------------------------
-- Company: University of Malaga
-- Engineer: Manuel Sanchez Natera
-- 
-- Create Date: 16/04/2025 20:28:34
-- Design Name: Speed Traffic Sign Recognition System
-- Module Name: FT245_Write_async_IF 
-- Project Name: Speed Traffic Sign Recognition System
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  This module is a interface to write data to PC throught FT245 chip.
-- Dependencies: 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

    
entity FT245_Write_async_IF is
    Generic(
			NWCYCLES: NATURAL range 1 to 8 := 4 -- To ensure min WRn active pulse width (>= 4)
    );
    Port ( 
           CLK      : in STD_LOGIC;
           RST      : in STD_LOGIC;
           -- USER IO ------------------------------------
           DIN      : in STD_LOGIC_VECTOR (7 downto 0);
           WR_EN    : in STD_LOGIC;
           READY    : out STD_LOGIC;
           -- FT245-like interface -----------------------
           TXEn     : in STD_LOGIC;
           WRn      : out STD_LOGIC;
           WRREQ    : out STD_LOGIC;
           DOUT     : out STD_LOGIC_VECTOR (7 downto 0)
           );
end FT245_Write_async_IF;

architecture Behavioral of FT245_Write_async_IF is

-- States definition for FT245_WRITE_IF FSM
type state_type is (IDLE, WAIT_FOR_TXE, WRITE_DATA);
-- Signals definition to control FSM
signal state_reg, state_next: state_type;
signal output_next, output_reg : STD_LOGIC_VECTOR (7 downto 0);
-- Registered signals (READY, WRn, WRREQ):
signal wrreq_reg, wrreq_next, ready_reg, ready_next, wrn_reg, wrn_next : STD_LOGIC;
signal wait_cycles_count : NATURAL := NWCYCLES; -- Write cycles control counter

-- Synchronized signals
signal sync_out     : STD_LOGIC_VECTOR(1 downto 0); -- Two stages
signal TXEn_sync    : STD_LOGIC;                    -- Write cycle

begin

    -- Two-stage synchronizer (2 FF)
    SYNC: process(RST, CLK)
    begin
		if RST = '1' then
			sync_out <= "11";
        elsif (CLK'EVENT and CLK = '1') then
			sync_out <= TXEn & sync_out(1);
		end if;
    end process SYNC;
    TXEn_sync <= sync_out(0);
    
    -- state register
    REG: process(RST, CLK)
    begin
		if RST = '1' then
			state_reg <= IDLE;
            wrreq_reg <= '0';
            ready_reg <= '1';
            wrn_reg <= '1';
		elsif (CLK'event and CLK='1') then
			state_reg <= state_next;
			output_reg <= output_next;
			wrn_reg <= wrn_next;
			ready_reg <= ready_next;
			wrreq_reg <= wrreq_next; 
			if wrn_next = '0' then
				wait_cycles_count <= wait_cycles_count + 1;
			else
				wait_cycles_count <= 0;
			end if; 
        end if;
    end process REG;


    -- next state logic
    COMB: process(state_reg, wrn_reg, wrreq_reg, ready_reg, output_reg, WR_EN, TXEn_sync, DIN, wait_cycles_count)
    begin
        state_next <= state_reg;
        output_next <= output_reg;
        wrn_next <= wrn_reg;
        wrreq_next <= wrreq_reg;
        ready_next <= ready_reg;
        case state_reg is
          when IDLE =>
            wrreq_next <= '0';
            ready_next <= '1';
            if WR_EN = '1' then
              state_next <= WAIT_FOR_TXE;
            end if;
          when WAIT_FOR_TXE =>
            ready_next <= '0';
            wrreq_next <= '0';
            if TXEn_sync = '0' then
               wrreq_next <= '1';
               wrn_next <= '0';
               state_next <= WRITE_DATA;
               output_next <= DIN;      -- for DIN to be ready when the status changes to WRITE_DATA
            end if;
          when WRITE_DATA =>
             wrreq_next <= '0';
             if wait_cycles_count = NWCYCLES then
                 wrn_next <= '1';
                 if WR_EN = '1' then
                    state_next <= WAIT_FOR_TXE;
                else 
                    state_next <= IDLE;
                end if;
            end if;
        end case;    
    end process COMB;

    -- Signal conections
    DOUT <= output_reg;
    WRn <= wrn_reg;
    READY <= ready_reg;
    WRREQ   <= wrreq_reg;
      
    
end Behavioral;
