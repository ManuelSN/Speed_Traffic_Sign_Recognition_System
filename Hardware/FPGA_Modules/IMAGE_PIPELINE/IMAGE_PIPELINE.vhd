----------------------------------------------------------------------------------
-- Company: University of Malaga
-- Engineer: Manuel Sanchez Natera
-- 
-- Create Date: 16/04/2025 20:28:34
-- Design Name: Speed Traffic Sign Recognition System
-- Module Name: IMAGE_PIPELINE
-- Project Name: Speed Traffic Sign Recognition System
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  This module integrate the capture process from Image Sensor.
-- Dependencies: SENSOR_EMULATOR, SENSOR_INTERFACE, FIFO
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity IMAGE_PIPELINE is
    
    Generic (
                ADDR_WIDTH : NATURAL range 1 to 63 := 16;       -- Address Bus Width
                DATA_WIDTH : NATURAL range 1 to 16 := 8         -- Data Bus Width
            );
    port (
        CLK              : in STD_LOGIC;                           -- System master clock
        RST              : in STD_LOGIC;                           -- System reset signal
        XCLK             : in STD_LOGIC;                           -- Signal Clock for image sensor 
        PIXCLK           : in STD_LOGIC;                           -- PIXEL sensor clock (drives the capture of each byte)  
        SENSOR_EMU_EN    : in STD_LOGIC;                           -- Image Sensor Emulator Enable
        FRAME_REQ        : in STD_LOGIC;                           -- Frame request
        FRAME_VALID      : in STD_LOGIC;                           -- Frame Valid
        LINE_VALID       : in STD_LOGIC;                           -- Line Valid
        FIFO_POP         : in STD_LOGIC;                           -- FIFO pop data to FT245 device
        DIN              : in STD_LOGIC_VECTOR(7 downto 0);        -- 8 bit input data from sensor (YUV 4:2:2 format)
        RD_FROM_EN       : out STD_LOGIC;                          -- Enable data read from FT245 device
        WR_TO_EN         : out STD_LOGIC;                          -- Enable data write to FT245 device
        IMAGE_DATA       : out STD_LOGIC_VECTOR(7 downto 0)        -- Frame input to process            
    );
end IMAGE_PIPELINE;

architecture behavioral of IMAGE_PIPELINE is

-----------------------------------------------------------------
--                  Control signals                            --  
-----------------------------------------------------------------
-- Image Sensor signals (real & emulated):
signal pixclk_signal, pixclk_emu_signal          : STD_LOGIC;
signal lvalid_signal, lvalid_emu_signal          : STD_LOGIC;
signal fvalid_signal, fvalid_emu_signal          : STD_LOGIC;
signal din_signal, din_emu_signal                : STD_LOGIC_VECTOR(7 downto 0); 
signal sensor_emu_en_sync                        : STD_LOGIC_VECTOR(1 downto 0);
signal sensor_emu_en_changes                     : STD_LOGIC;
-- FIFO signals    
signal fifo_push_signal     : STD_LOGIC;
signal fifo_full_signal     : STD_LOGIC;
signal fifo_empty_signal    : STD_LOGIC;
signal fifo_data_signal     : STD_LOGIC_VECTOR(7 downto 0);

signal reset_signal         : STD_LOGIC;

begin 

-- Toggle detection of SENSOR_EMU_EN input
process(CLK)
begin
    if rising_edge(CLK) then
        if RST = '1' then
          sensor_emu_en_changes <= '0';
        else
            sensor_emu_en_sync(0) <= SENSOR_EMU_EN;
            sensor_emu_en_sync(1) <= sensor_emu_en_sync(0);
            if sensor_emu_en_sync(1) /= sensor_emu_en_sync(0) then
                sensor_emu_en_changes <= '1';
            else
                sensor_emu_en_changes <= '0';
            end if;
        end if;
    end if;
end process;

-- MUX: Get inputs from real or emulated sensor
pixclk_signal  <= PIXCLK        when (sensor_emu_en_sync(1) = '0') else pixclk_emu_signal;
din_signal     <= DIN           when (sensor_emu_en_sync(1) = '0') else din_emu_signal;
lvalid_signal  <= LINE_VALID    when (sensor_emu_en_sync(1) = '0') else lvalid_emu_signal; 
fvalid_signal  <= FRAME_VALID   when (sensor_emu_en_sync(1) = '0') else fvalid_emu_signal;

-- Update reset signal control
reset_signal <= RST or sensor_emu_en_changes;

-- SENSOR EMULATOR component to emulate test the system
SENSOR_EMULATOR: entity work.SENSOR_EMULATOR
        port map(
            -- Inputs
            XCLK        => XCLK,
            RST         => reset_signal,
            -- Outputs
            PIXCLK      => pixclk_emu_signal,
            FRAME_VALID => fvalid_emu_signal,
            LINE_VALID  => lvalid_emu_signal,
            IMAGE_DATA  => din_emu_signal
        );        

-- SENSOR INTERFACE component to communicate with
SENSOR_INTERFACE: entity work.MT9V111_IF
        port map(
            -- Inputs 
            CLK         => CLK,
            RST         => reset_signal,
            PIXCLK      => pixclk_signal,
            LINE_VALID  => lvalid_signal,
            FRAME_VALID => fvalid_signal,
            FRAME_REQ   => FRAME_REQ,
            FIFO_EMPTY  => fifo_empty_signal,
            FIFO_FULL   => fifo_full_signal,
            DIN         => din_signal,
            -- Outputs
            FIFO_PUSH   => fifo_push_signal,
            RD_EN       => RD_FROM_EN,
            WR_EN       => WR_TO_EN,
            IMAGE_DATA  => fifo_data_signal
        );    

-- FIFO component to ensure no data loss
FIFO: entity work.FIFO
        generic map(
                ADDR_WIDTH => ADDR_WIDTH,       -- Address Bus Width
                DATA_WIDTH => DATA_WIDTH        -- Data Bus Width
        )
        port map(
            -- Inputs 
            CLK         => CLK,
            RST         => reset_signal,
            DIN         => fifo_data_signal,
            PUSH        => fifo_push_signal,
            POP         => FIFO_POP,
            -- Outputs
            FULL        => fifo_full_signal,
            EMPTY       => fifo_empty_signal,
            DOUT        => IMAGE_DATA
        );    

end behavioral;
