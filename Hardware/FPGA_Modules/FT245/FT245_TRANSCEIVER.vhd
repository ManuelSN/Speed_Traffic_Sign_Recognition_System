----------------------------------------------------------------------------------
-- Company: University of Malaga
-- Engineer: Manuel Sanchez Natera
-- 
-- Create Date: 16/04/2025 20:28:34
-- Design Name: Speed Traffic Sign Recognition System
-- Module Name: FT245_TRANSCEIVER 
-- Project Name: Speed Traffic Sign Recognition System
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  This module is a interface to communicate with PC throught FT245 chip.
-- Dependencies: FT245_Write_async_IF, FT245_Read_async_IF
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-------------------------------------------------------------------
--------------------- TOP FT245 INTERFACE ---------------------------
-------------------------------------------------------------------

-------------------------------------------------------------------
--------------------- INSTANCE R/W MODULES ---------------------------
-------------------------------------------------------------------
    
entity FT245_TRANSCEIVER is
    Port (
            CLK        : in STD_LOGIC;
            RST        : in STD_LOGIC;
            WR_EN      : in STD_LOGIC;
            RD_EN      : in STD_LOGIC;
            DIN        : in STD_LOGIC_VECTOR(7 downto 0);  
            DOUT       : out STD_LOGIC_VECTOR(7 downto 0);  
            READY      : out STD_LOGIC;
            WRREQ      : out STD_LOGIC;
            RDREQ      : out STD_LOGIC;
            -- FT245 FIFO SYNC Phy Interface (UM232H-B)
            RXFn       : in STD_LOGIC;
            TXEn       : in STD_LOGIC;
            WRn        : out STD_LOGIC;
            RDn        : out STD_LOGIC;
            SIWUn      : out STD_LOGIC;
            PWRSAVn    : out STD_LOGIC;
            DATA       : inout STD_LOGIC_VECTOR(7 downto 0)
        );
end FT245_TRANSCEIVER;

architecture Behavioral of FT245_TRANSCEIVER is
----------------------------------------------------------------------
-- FPGA input data internal signal
----------------------------------------------------------------------
signal WRITE_TODATA, READ_FROMDATA  : STD_LOGIC_VECTOR(7 downto 0); -- data signal aux for inout signal "DATA"


begin
    
    ----------------------------------------------------------------------
    -- Fixed outputs
    ----------------------------------------------------------------------
    PWRSAVn  <= '1';  -- Power Saving chip mode disabled
    SIWUn    <= '1';  -- This signal is related to waking up the chip from a power saving mode, so it has no use.
    
    ---------------------------------------------------------------------    
    -- FPGA ==> FT245 ==> PC
    ----------------------------------------------------------------------
    IFWRITE: entity work.FT245_Write_async_IF 
          PORT MAP (
              -- Inputs 
              CLK       => CLK,
              RST       => RST,
              WR_EN     => WR_EN,
              TXEN      => TXEn,
              DIN       => DIN,
              -- Outputs 
              READY     => READY,
              WRn       => WRn,
              WRREQ     => WRREQ,
              DOUT      => WRITE_TODATA
          );

    ----------------------------------------------------------------------      
    -- PC ==> FT245 ==> FPGA 
    ----------------------------------------------------------------------
    IFREAD: entity work.FT245_Read_async_IF
        PORT MAP (
            -- Inputs 
            CLK         => CLK,
            RST         => RST, 
            RD_EN       => RD_EN,
            RXFn        => RXFn,
            DIN         => READ_FROMDATA,
            -- Outputs
            RDn         => RDn,
            RDREQ       => RDREQ,
            DOUT        => DOUT
        );

    -- Buffers to deal with 'inout' signal "DATA"
    DATA <= WRITE_TODATA when WR_EN = '1' else "ZZZZZZZZ";  
    --DATA <= "ZZZZZZZZ" when "ZZZZZZZZ" and WR_EN = '0';
    READ_FROMDATA <= DATA when RD_EN = '1' else "ZZZZZZZZ";
            
end Behavioral;
