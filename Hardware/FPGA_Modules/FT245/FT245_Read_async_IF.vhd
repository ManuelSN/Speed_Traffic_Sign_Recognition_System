----------------------------------------------------------------------------------
-- Company: University of Malaga
-- Engineer: Manuel Sanchez Natera
-- 
-- Create Date: 16/04/2025 20:28:34
-- Design Name: Speed Traffic Sign Recognition System
-- Module Name: FT245_Read_async_IF 
-- Project Name: Speed Traffic Sign Recognition System
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  This module is a interface to read data from PC throught FT245 chip.
-- Dependencies: 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FT245_Read_async_IF is
 Generic(
			NRCYCLES: NATURAL range 1 to 8 := 4 -- To ensure min RDn active pulse width (>= 4)
    );
    Port ( 
           CLK      : in STD_LOGIC;
           RST      : in STD_LOGIC;
           -- USER IO ------------------------------------
           DOUT     : out STD_LOGIC_VECTOR (7 downto 0);
           RD_EN    : in STD_LOGIC;
           -- FT245-like interface -----------------------
           RXFn     : in STD_LOGIC;
           RDn      : out STD_LOGIC;
           RDREQ    : out STD_LOGIC;
           DIN      : in STD_LOGIC_VECTOR (7 downto 0)
        );
end FT245_Read_async_IF;

architecture Behavioral of FT245_Read_async_IF is

-- States definition for FT245_READ_IF FSM
type state_type is (IDLE, WAIT_FOR_RXFn, READ_DATA);
-- Signals definition to control FSM
signal state_reg, state_next: state_type;
signal input_next, input_reg : STD_LOGIC_VECTOR (7 downto 0);
-- Registered signals (RDn, RDREQ):
signal rdn_reg, rdn_next, rdreq_reg, rdreq_next : STD_LOGIC;
signal wait_cycles_count : NATURAL := NRCYCLES; -- Read cycles control counter

-- Synchronized signals
signal sync_out  : STD_LOGIC_VECTOR(1 downto 0); -- Two stages
signal RXFn_sync : STD_LOGIC;                    -- Read cycle

begin

     -- Sync of 2 stages (2 FF)
    SYNC: process(RST, CLK)
    begin
        if RST = '1' then
			sync_out <= "11";
        elsif (CLK'EVENT and CLK = '1') then
			sync_out <= RXFn & sync_out(1);
		end if;
    end process SYNC;
    RXFn_sync <= sync_out(0);
    
    
    -- state register
    REG: process(RST, CLK)
    begin
		if RST = '1' then
            input_reg <= (others => '0');
            rdn_reg <= '1';
            rdreq_reg <= '0';
            state_reg <= IDLE;
		elsif (CLK'event and CLK='1') then
			state_reg <= state_next;
			input_reg <= input_next;
			rdn_reg <= rdn_next;
			rdreq_reg <= rdreq_next;  
			if rdn_next = '0' then
				wait_cycles_count <= wait_cycles_count + 1;
			else
				wait_cycles_count <= 0;
			end if;
        end if;
    end process REG;


    -- next state logic
    COMB: process(state_reg, rdn_reg, rdreq_reg, input_reg, RD_EN, RXFn_sync, DIN, wait_cycles_count)
    begin
        state_next <= state_reg;
        input_next <= input_reg;
        rdreq_next <= rdreq_reg;
        rdn_next <= rdn_reg;
        case state_reg is
          when IDLE =>
            rdn_next <= '1';
            if RD_EN = '1' then
              state_next <= WAIT_FOR_RXFn;
            end if;
          when WAIT_FOR_RXFn =>    
            if RXFn_sync = '0' then         
               rdn_next <= '0';
               state_next <= READ_DATA;
            end if;
          when READ_DATA =>
            rdreq_next <= '0';
            if wait_cycles_count = 1 then
                input_next <= DIN; 
                rdreq_next <= '1';
            elsif wait_cycles_count = NRCYCLES then               
                rdn_next <= '1';
                if RD_EN = '1' then
                    state_next <= WAIT_FOR_RXFn;
                else 
                    state_next <= IDLE;
                end if;
            end if;
        end case;    
    end process COMB;

    -- Output signal connections
    DOUT  <= input_reg;
    RDn   <= rdn_reg;
    RDREQ   <= rdreq_reg;
      
    
end Behavioral;
