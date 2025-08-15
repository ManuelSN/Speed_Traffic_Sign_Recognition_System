----------------------------------------------------------------------------------
-- Company: University of Malaga
-- Engineer: Manuel Sanchez Natera
-- 
-- Create Date: 16/04/2025 20:28:34
-- Design Name: Speed Traffic Sign Recognition System
-- Module Name: SENSOR_EMULATOR
-- Project Name: Speed Traffic Sign Recognition System
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  This module allows to emulate the image sensor for testing the capture process.
-- Dependencies: 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SENSOR_EMULATOR is
    Port ( 
           XCLK         : in STD_LOGIC;
           RST          : in STD_LOGIC;  
           PIXCLK       : out STD_LOGIC;
           FRAME_VALID  : out STD_LOGIC;
           LINE_VALID   : out STD_LOGIC;
           IMAGE_DATA   : out STD_LOGIC_VECTOR (7 downto 0)
    );       
end SENSOR_EMULATOR;



architecture Behavioral of SENSOR_EMULATOR is

------------------------------------------------------------------------------------------
--  Pixel clocks counter signals to emulate real sensor parameters                      --
------------------------------------------------------------------------------------------
                                                                -- PIXCLK clocks  | 12MHz(DEFAULT) |     25MHz      | 
 -- Need 2 bytes to send data of 1 pixel (NUM_PIXELS * 2)       ------------------|----------------|----------------|
constant ACTIVE_DATA_COUNT          : NATURAL := 1280;          --  1280  clks    |  106.7us       |      51.2us    |
constant FRAME_START_BLANKING       : NATURAL := 300;           --  300   clks    |     25us       |        12us    |  
constant FRAME_END_BLANKING         : NATURAL := 14;            --   14   clks    |   1.17us       |      0.56us    |
constant HORIZONTAL_BLANKING        : NATURAL := 318;           --  318   clks    |   26.5us       |     12.72us    |
constant VERTICAL_BLANKING          : NATURAL := 20778;         --  20778 clks    |   1.73ms       |   0.83112ms    |
                                                                -- =================================================
------------------------------------------- Total Frame Time:      787814 clks    |  65.65ms       |    31.512ms    |

-- Image Resolution (640x480)
constant NUM_PIXELS                 : NATURAL := 640;       -- Number of pixels per line
constant NUM_LINES                  : NATURAL := 480;       -- Number of lines per frame

-- IMAGE PATTERN TEST values
constant IMAGE_GRADIENT_PATTERN_STEP        : NATURAL := 256;   
constant IMAGE_PATTERN_FRAME_START_BYTE     : STD_LOGIC_VECTOR(7 downto 0) := x"14";
constant IMAGE_PATTERN_FRAME_END_BYTE       : STD_LOGIC_VECTOR(7 downto 0) := x"28";
constant IMAGE_PATTERN_LINE_START_BYTE      : STD_LOGIC_VECTOR(7 downto 0) := x"97";
constant IMAGE_PATTERN_LINE_END_BYTE        : STD_LOGIC_VECTOR(7 downto 0) := x"17";
constant IMAGE_PATTERN_HBLANKING_BYTE       : STD_LOGIC_VECTOR(7 downto 0) := x"A5";
constant IMAGE_PATTERN_VBLANKING_BYTE       : STD_LOGIC_VECTOR(7 downto 0) := x"45";

-- FSM Signals                                                
type state_type is (SOFBLANKING, ACTIVE, HBLANKING, EOFBLANKING, VBLANKING);
signal state_reg, state_next : state_type;

-- Sensor emulator output signals
signal frame_valid_reg, frame_valid_next            : STD_LOGIC;
signal line_valid_reg, line_valid_next              : STD_LOGIC;
signal image_data_reg, image_data_next              : STD_LOGIC_VECTOR(7 downto 0);
-- Sensor emulator control signals
signal active_count                                 : UNSIGNED(10 downto 0);    -- Min resolution to count until ACTIVE_DATA_COUNT
signal lines_count                                  : UNSIGNED(8 downto 0);     -- Min resolution to count until NUM_LINES
signal sofblank_count                               : UNSIGNED(8 downto 0);     -- Min resolution to count until FRAME_START_BLANKING 
signal eofblank_count                               : UNSIGNED(3 downto 0);     -- Min resolution to count until FRAME_END_BLANKING 
signal hblank_count                                 : UNSIGNED(8 downto 0);     -- Min resolution to count until HORIZONTAL_BLANKING 
signal vblank_count                                 : UNSIGNED(14 downto 0);    -- Min resolution to count until VERTICAL_BLANKING

-- Function to get a specific pixel value in hex format to emulate a gradient pattern image ( Format YUV 4:2:2 -> Cb_i // Y_i // Cr_i // Y_i+1 )
function GET_HEX_PIXEL_VALUE (pixel_index : unsigned(10 downto 0)) return std_logic_vector is
    variable value : unsigned(7 downto 0);
  begin
    value := to_unsigned(to_integer(pixel_index) mod IMAGE_GRADIENT_PATTERN_STEP, 8);
    return std_logic_vector(value);
end function;
    
begin
    
    -- Process to register signals in each falling edge of CLK_IN
    REG: process(XCLK, RST)
    begin
        if RST = '1' then
            state_reg               <= SOFBLANKING;
            line_valid_reg          <= '0';
            frame_valid_reg         <= '0';
            image_data_reg          <= (others=>'0');
        elsif falling_edge(XCLK) then
            state_reg               <= state_next;
            line_valid_reg          <= line_valid_next;
            frame_valid_reg         <= frame_valid_next;
            image_data_reg          <= image_data_next;
        end if;
    end process;
   
    -- Process to update counters of ACTIVE status period 
    ACTIVE_COUNTER: process(XCLK, RST, state_reg, line_valid_reg)
    begin
        if RST = '1' then
            active_count <= (others=>'0');
            lines_count <= (others=>'0');
        elsif state_reg /= ACTIVE then
            active_count <= (others=>'0');
            if state_reg /= HBLANKING then
                lines_count <= (others=>'0');
            end if;
        elsif falling_edge(XCLK) then
            if line_valid_reg = '1' then
                active_count <= active_count + 1;
                if active_count = ACTIVE_DATA_COUNT-1 then
                    lines_count <= lines_count + 1;
                end if;
            end if;
        end if;  
    end process;

    -- Process to count the start of frame blanking period
    SOFBLANK_COUNTER: process(XCLK, RST, state_reg)
    begin
        if RST = '1' or state_reg /= SOFBLANKING then
            sofblank_count <= (others=>'0');
        elsif falling_edge(XCLK) then
            sofblank_count <= sofblank_count + 1;
        end if;
    end process;
    
    -- Process to count the end of frame blanking period
    EOFBLANK_COUNTER: process(XCLK, RST, state_reg)
    begin
        if RST = '1' or state_reg /= EOFBLANKING then
            eofblank_count <= (others=>'0');
        elsif falling_edge(XCLK) then
            eofblank_count <= eofblank_count + 1;
        end if;
    end process;
    
    -- Process to count horizontal blanking period
    HBLANK_COUNTER: process(XCLK, RST, state_reg, line_valid_reg)
    begin
        if RST = '1' or state_reg /= HBLANKING then
            hblank_count <= (others=>'0');
        elsif falling_edge(XCLK) and line_valid_reg = '0' then
            hblank_count <= hblank_count + 1;
        end if;
    end process;
    
    -- Process to count vertical blanking period (between frames)
    VBLANK_COUNTER: process(XCLK, RST, state_reg, frame_valid_reg)
    begin
        if RST = '1' or (state_reg /= VBLANKING) then
            vblank_count <= (others=>'0');
        elsif falling_edge(XCLK) and frame_valid_reg = '0' then
            vblank_count <= vblank_count + 1;
        end if;
    end process;
    
    -- SENSOR EMULATOR FSM
    SENSOR_FSM: process(state_reg, line_valid_reg, frame_valid_reg, sofblank_count, active_count, hblank_count, lines_count, eofblank_count, vblank_count)
    begin
        state_next        <= state_reg;
        line_valid_next   <= line_valid_reg;
        frame_valid_next  <= frame_valid_reg;
        case state_reg is
            -- FRAME START BLANKING STATE
            when SOFBLANKING =>
                image_data_next  <= IMAGE_PATTERN_FRAME_START_BYTE;
                frame_valid_next <= '1';
                line_valid_next  <= '0';
                if sofblank_count = FRAME_START_BLANKING-1 then
                    line_valid_next <= '1';
                    image_data_next <= GET_HEX_PIXEL_VALUE(active_count);
                    state_next <= ACTIVE;
                end if;
            -- ACTIVE IMAGE DATA STATE
            when ACTIVE =>
                image_data_next <= GET_HEX_PIXEL_VALUE(active_count);
                if lines_count = NUM_LINES-1 and active_count = ACTIVE_DATA_COUNT-1 then
                    line_valid_next <= '0';
                    image_data_next <= IMAGE_PATTERN_FRAME_END_BYTE;
                    state_next <= EOFBLANKING;
                elsif active_count = ACTIVE_DATA_COUNT-1 then
                    line_valid_next <= '0';
                    image_data_next <= IMAGE_PATTERN_HBLANKING_BYTE;
                    state_next <= HBLANKING;
                end if;
            -- HORIZONTAL BLANKING STATE
            when HBLANKING =>
                image_data_next <= IMAGE_PATTERN_HBLANKING_BYTE;
                if  hblank_count = HORIZONTAL_BLANKING-1 then
                    line_valid_next <= '1';
                    image_data_next <= GET_HEX_PIXEL_VALUE(active_count);
                    state_next <= ACTIVE;
                end if;
            -- FRAME END BLANKING STATE
            when EOFBLANKING =>
                image_data_next <= IMAGE_PATTERN_FRAME_END_BYTE;
                if eofblank_count = FRAME_END_BLANKING-1 then
                    frame_valid_next <= '0';
                    image_data_next <= IMAGE_PATTERN_VBLANKING_BYTE;
                    state_next <= VBLANKING; 
                end if;
            -- VERTICAL BLANKING  STATE (BETWEEN FRAMES)
            when VBLANKING =>
                image_data_next <= IMAGE_PATTERN_VBLANKING_BYTE;
                if vblank_count = VERTICAL_BLANKING-1 then
                    image_data_next  <= IMAGE_PATTERN_FRAME_START_BYTE;
                    frame_valid_next <= '1';
                    state_next <= SOFBLANKING; 
                end if;
        end case;      
    end process;
    
    -- Output logic
    PIXCLK <= XCLK;
    FRAME_VALID <= frame_valid_reg;
    LINE_VALID <= line_valid_reg;
    IMAGE_DATA <= image_data_reg; 

end Behavioral;
