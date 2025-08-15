----------------------------------------------------------------------------------
-- Company: University of Malaga
-- Engineer: Manuel Sanchez Natera
-- 
-- Create Date: 16/04/2025 20:28:34
-- Design Name: Speed Traffic Sign Recognition System
-- Module Name: TOP 
-- Project Name: Speed Traffic Sign Recognition System
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  This main module integrate the differents system modules.
-- Dependencies:  DISP7SEG, FT245_TRANSCEIVER, IMAGE_PIPELINE, CLOCKGEN, *FREE_RUNNING_COUNTER (only test)
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity TOP is

    Port ( MCLK             : in STD_LOGIC;
           RST              : in STD_LOGIC;
           -- IMAGE SENSOR
           PIXCLK           : in STD_LOGIC;
           SENSOR_EMU_EN    : in STD_LOGIC;                   
           FRAME_VALID      : in STD_LOGIC;
           LINE_VALID       : in STD_LOGIC;
           SENSOR_DATA      : in STD_LOGIC_VECTOR(7 downto 0);
           XCLK             : out STD_LOGIC;
		   RSTn             : out STD_LOGIC;
		   LED              : out STD_LOGIC;
           --LED              : out std_logic_vector(15 downto 0)   -- 16 LEDs BASYS3		   
           -- H7SEG IF
           DISPLAY          : out STD_LOGIC_VECTOR (7 downto 0);
           DISPLAYONn       : out STD_LOGIC_VECTOR (3 downto 0);
           -- FT245_TRANSCEIVER IF
           RXFn             : in STD_LOGIC;
           TXEn             : in STD_LOGIC;
           WRn              : out STD_LOGIC;
           RDn              : out STD_LOGIC;
           SIWUn            : out STD_LOGIC;
           PWRSAVn          : out STD_LOGIC;
           DATA             : inout STD_LOGIC_VECTOR(7 downto 0)
       );
end TOP;

architecture Behavioral of TOP is

----------------------------------------------------------------------
-- HEX7SEG MODULE
----------------------------------------------------------------------   
signal value_to_display : NATURAL;
--signal internal_data : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; -- Signal for TEST => WRITE TO PC 
signal binary_value, binary_value_reg : unsigned(7 downto 0);

----------------------------------------------------------------------
-- FT245 MODULE
----------------------------------------------------------------------  
signal ready, wr_en, rd_en, wr_n, rd_n, request_signal, ready_signal : STD_LOGIC;
signal image_data   : STD_LOGIC_VECTOR(7 downto 0);
signal data_from_ext : STD_LOGIC_VECTOR(7 downto 0);


----------------------------------------------------------------------
-- FIFO MODULE
----------------------------------------------------------------------  
constant ADDR_WIDTH    : NATURAL := 16; -- FIFO ADDRESS bus width
constant DATA_WIDTH    : NATURAL := 8;  -- FIFO DATA bus width

signal fifo_pop_signal : STD_LOGIC;


----------------------------------------------------------------------
-- CLOCK MODULE
----------------------------------------------------------------------  
signal xclk_signal : STD_LOGIC;


begin

-- Instantiate the differents system modules:

----------------------------------------------------------------------
-- CLOCK MODULE generate clock signal (XCLK) for IMAGE SENSOR
----------------------------------------------------------------------
CLOCKGEN: entity work.CLOCKGEN
    PORT MAP(
        -- Inputs
        CLKREF  => MCLK,
        RST     => RST,
        -- Outputs
        CLKGEN  => xclk_signal
    );
        
----------------------------------------------------------------------
-- WRITE TEST MODULE (FREE-RUNNING COUNTER)
----------------------------------------------------------------------   
--WRITE_TEST: entity WORK.FREE_RUNNING_COUNTER
--port map (
--    CLK => MCLK,
--    COUNT => internal_data(7 downto 0)
--);

----------------------------------------------------------------------
-- HEX7SEG MODULE
----------------------------------------------------------------------   
DISP7SEG: entity work.DISP7SEG
    PORT MAP (
        -- Module Inputs
        CLK    =>  MCLK,
        RST    =>  RST,
        VALUE  =>  value_to_display, 
        -- Module Outputs
        CAT    =>  DISPLAY,
        AN     =>  DISPLAYONn
     );
     
----------------------------------------------------------------------
-- FT245 TRANSCEIVER MODULE
----------------------------------------------------------------------       
FT245: entity work.FT245_TRANSCEIVER
    PORT MAP (
        -- Module Inputs
        CLK     => MCLK,
        RST     => RST,
        WR_EN   => wr_en,
        RD_EN   => rd_en,
        DIN     => image_data,              -- internal_data(7 downto 0) for WRITE TEST
        DOUT    => data_from_ext,
        READY   => ready_signal,
        WRREQ   => fifo_pop_signal,
        RDREQ   => request_signal,
        RXFn    => RXFn,
        TXEn    => TXEn,
        WRn     => WRn,
        RDn     => RDn,
        SIWUn   => SIWUn,
        PWRSAVn => PWRSAVn,
        -- Module Inputs/Outputs
        DATA    => DATA
     );
     
----------------------------------------------------------------------        
-- IMAGE PIPELINE MODULE
----------------------------------------------------------------------  

IMAGE_PIPELINE: entity work.IMAGE_PIPELINE
    GENERIC MAP (
        ADDR_WIDTH => ADDR_WIDTH,
        DATA_WIDTH => DATA_WIDTH
    )
    PORT MAP (
        -- Inputs
        CLK             => MCLK,
        RST             => RST,
        XCLK            => xclk_signal,       
        PIXCLK          => PIXCLK,
        SENSOR_EMU_EN   => SENSOR_EMU_EN,
        FRAME_REQ       => request_signal,
        FRAME_VALID     => FRAME_VALID,
        LINE_VALID      => LINE_VALID,
        FIFO_POP        => fifo_pop_signal,
        DIN             => SENSOR_DATA,
        -- Outputs
        RD_FROM_EN      => rd_en,
        WR_TO_EN        => wr_en,
        IMAGE_DATA      => image_data
    );

    -- Signal conections
    RSTn   <= not RST;
    XCLK   <= xclk_signal;
    LED    <= SENSOR_EMU_EN;
--    LED(0) <= data_from_ext(0);
--    LED(1) <= data_from_ext(1);
--    LED(2) <= data_from_ext(2);
--    LED(3) <= data_from_ext(3);
--    LED(4) <= data_from_ext(4);
--    LED(5) <= data_from_ext(5);
--    LED(6) <= data_from_ext(6);
--    LED(7) <= data_from_ext(7);
       
    binary_value_reg <= unsigned(data_from_ext);  -- Convert std_logic_vector to unsigned
    BIN_TO_NATURAL: process(binary_value_reg)
    variable temp_value : natural := 0;
    begin
        temp_value := 0;
        -- Convert each binary value into natural format
        for i in 0 to 7 loop
            if binary_value_reg(i) = '1' then
                temp_value := temp_value + (2 ** i);
            end if;
        end loop;
        value_to_display <= temp_value;
    end process;

end Behavioral;
