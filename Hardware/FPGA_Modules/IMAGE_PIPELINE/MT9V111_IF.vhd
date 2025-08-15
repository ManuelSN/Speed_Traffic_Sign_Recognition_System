----------------------------------------------------------------------------------
-- Company: University of Malaga
-- Engineer: Manuel Sanchez Natera
-- 
-- Create Date: 16/04/2025 20:28:34
-- Design Name: Speed Traffic Sign Recognition System
-- Module Name: MT9V111_IF
-- Project Name: Speed Traffic Sign Recognition System
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  This module allows to get data image from the image sensor.
-- Dependencies: 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MT9V111_IF is
    port (
        CLK               : in STD_LOGIC;                          -- System master clock
        RST               : in STD_LOGIC;                          -- System reset signal
        PIXCLK            : in STD_LOGIC;                          -- PIXEL sensor clock (drives the capture of each byte)  
        LINE_VALID        : in STD_LOGIC;                          -- Valid frame line
        FRAME_VALID       : in STD_LOGIC;                          -- Valid complete frame
        FRAME_REQ         : in STD_LOGIC;                          -- Frame request
        FIFO_EMPTY        : in STD_LOGIC;                          -- FIFO empty status
        FIFO_FULL         : in STD_LOGIC;                          -- FIFO full status
        DIN               : in STD_LOGIC_VECTOR(7 downto 0);       -- 8 bit data from sensor (YUV 4:2:2 format)
        FIFO_PUSH         : out STD_LOGIC;                         -- FIFO push data
        RD_EN             : out STD_LOGIC;                         -- Enable data read
        WR_EN             : out STD_LOGIC;                         -- Enable data write
        IMAGE_DATA        : out STD_LOGIC_VECTOR(7 downto 0)       -- Frame input to process            
    );
end MT9V111_IF;

architecture behavioral of MT9V111_IF is

-- FSM of capture process signals
type STATES is (OFF, IDLE, BLANKING, CAPTURE, FLUSH);
signal state_reg, state_next : STATES;

-- Control signals
signal wr_en_reg, wr_en_next                     : STD_LOGIC;
signal rd_en_reg, rd_en_next                     : STD_LOGIC;
signal fifo_push_reg, fifo_push_next             : STD_LOGIC;
signal img_reg, img_next                         : STD_LOGIC_VECTOR(7 downto 0);
signal sof_signal, eof_signal                    : STD_LOGIC; -- Start of Frame and End of Frame signals
signal pixclk_sync, pixclk_sync_aux              : STD_LOGIC; -- PIXCLK signal sync
signal data_valid_signal, byte_count             : STD_LOGIC;
signal frame_valid_reg, pixclk_sync_reg          : STD_LOGIC;

--  YUV 4:2:2 transmission:
--  -----------------------
--    Pixel 0  |  Pixel 1
--   ----------|------------
--    U0 Y0 V0 | Y1
  
begin


 
-- Synchronize PIXCLK (2FF) to system clock domain (CLK)
process(CLK)
begin
    if rising_edge(CLK) then
        pixclk_sync_aux <= PIXCLK;
        pixclk_sync <= pixclk_sync_aux;
    end if;
end process;
   
COLOR_FORMAT: process
begin
    wait until rising_edge(CLK);
    if RST = '1' or sof_signal = '1' then
        data_valid_signal <= '0';
    else
        pixclk_sync_reg <= pixclk_sync;
        if pixclk_sync = '1' and pixclk_sync_reg = '0' then
            data_valid_signal <= '1';
        else
            data_valid_signal <= '0';
        end if;
   end if;
end process;

--GRAY_FORMAT: process
--begin
--    wait until rising_edge(CLK);
--    if RST = '1' or sof_signal = '1' then
--        data_valid_signal <= '0';
--        byte_count <= '0';
--    else
--        pixclk_sync_reg <= pixclk_sync;
--        if pixclk_sync = '1' and pixclk_sync_reg = '0' then
--            data_valid_signal <= byte_count;
--            byte_count <= not byte_count;
--        else
--            data_valid_signal <= '0';
--        end if;
--    end if;
--end process;

-- Detection of FRAME_VALID Edges
process(CLK)
begin
    if rising_edge(CLK) then
        frame_valid_reg <= FRAME_VALID;
    end if;
end process; 
sof_signal <= '1' when FRAME_VALID = '1' and frame_valid_reg = '0' else '0';
eof_signal <= '1' when FRAME_VALID = '0' and frame_valid_reg = '1' else '0';
 
-- States Register Process
STATES_REG : process(CLK)
begin
    if rising_edge(CLK) then
        if RST = '1' then
            state_reg <= IDLE;
            rd_en_reg <= '0';
            wr_en_reg <= '0';
            fifo_push_reg  <= '0'; 
            img_reg <= (others => '0');
        elsif FIFO_FULL = '1' then      -- Image Capturing Process stops when FIFO is FULL (in order to not lost data and avoid framing errors forcing a reset)
            state_reg <= FLUSH;
            rd_en_reg <= '0';
            wr_en_reg <= '1';
            fifo_push_reg  <= '0'; 
        else 
            state_reg       <= state_next;
            rd_en_reg       <= rd_en_next;
            wr_en_reg       <= wr_en_next;
            fifo_push_reg   <= fifo_push_next;
            img_reg         <= img_next;
        end if;
    end if;
end process STATES_REG;
        
-- CAPTURE_PROCESS: Image Capturing Process FSM
CAPTURE_PROCESS : process(FIFO_EMPTY, FRAME_REQ, sof_signal, eof_signal, LINE_VALID, DIN, state_reg, img_reg, rd_en_reg, wr_en_reg, data_valid_signal, fifo_push_reg)
begin
    state_next       <= state_reg;
    rd_en_next       <= rd_en_reg;
    wr_en_next       <= wr_en_reg;
    fifo_push_next   <= fifo_push_reg;
    img_next         <= img_reg;
    case state_reg is
        when OFF => 
            fifo_push_next          <= '0';
            rd_en_next              <= '1';
            wr_en_next              <= '0';
            img_next                <= (others => '0'); 
            if FRAME_REQ = '1' then 
                state_next <= IDLE;
            end if;
        when IDLE =>
            if (sof_signal = '1') then
                state_next <= BLANKING;
            end if;
        when BLANKING => 
            fifo_push_next          <= '0';
            rd_en_next              <= '0';
            wr_en_next              <= not FIFO_EMPTY; 
            img_next                <= (others => '0');
            if eof_signal = '1' then
                if FIFO_EMPTY = '0' then
                    state_next <= FLUSH;
                else
                    state_next <= OFF;
                end if;
            elsif LINE_VALID = '1' then
                state_next <= CAPTURE;
            end if;
        when CAPTURE =>
            fifo_push_next  <= data_valid_signal;    
            wr_en_next      <= not FIFO_EMPTY; 
            img_next        <= DIN;
            if LINE_VALID = '0' then
                state_next <= BLANKING;
            end if;                                          
        when FLUSH =>
            wr_en_next  <= not FIFO_EMPTY;
            img_next    <= DIN;
            if FIFO_EMPTY = '1' then
                state_next <= OFF;
            end if;
        end case;
    
end process;

-- Output logic
FIFO_PUSH  <= fifo_push_reg;
RD_EN      <= rd_en_reg;
WR_EN      <= wr_en_reg;
IMAGE_DATA <= img_reg;

end behavioral;
