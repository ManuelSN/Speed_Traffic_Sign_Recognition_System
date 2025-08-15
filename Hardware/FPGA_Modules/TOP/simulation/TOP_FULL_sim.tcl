##  Company: University of Málaga
##  Project: TFM - Speed Traffic Sign Recognition System 
##  Engineer: Manuel Sánchez Natera


# Restart simulation
restart

add_wave {MCLK}
add_wave {XCLK}
add_wave {RST}
add_wave {request_signal}
add_wave {RXFn}
add_wave {RDn}
add_wave {TXEn}
add_wave {WRn}
#add_wave {SENSOR_EMU_EN}
#add_wave {RSTn}
# Internal signals
add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/DIN}} 
add_wave {{/TOP/IMAGE_PIPELINE/FIFO/WORD_COUNTER_REG}}
add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/sof_signal}}
add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/eof_signal}}
add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_EMULATOR/state_reg}} 
#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_EMULATOR/IMAGE_DATA}}
#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/FRAME_VALID}} 
#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_EMULATOR/LINE_VALID}} 
#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_EMULATOR/FRAME_VALID}} 
#add_wave {{/TOP/fifo_pop_signal}} 
#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/FIFO_FULL}} 
#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/fifo_push_next}} 
#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/fifo_push_reg}} 
#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/FIFO_EMPTY}}
#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/LINE_VALID}} 
#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/FRAME_VALID}} 
#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/IMAGE_DATA}}
#add_wave {{/TOP/IMAGE_PIPELINE/FIFO/EMPTY}}  
#add_wave {{/TOP/IMAGE_PIPELINE/FIFO/PUSH}}
#add_wave {{/TOP/IMAGE_PIPELINE/FIFO/wr_en}}  
#add_wave {{/TOP/IMAGE_PIPELINE/FIFO/DIN}}
#add_wave {{/TOP/IMAGE_PIPELINE/FIFO/RPOINTER_REG}}
#add_wave {{/TOP/IMAGE_PIPELINE/FIFO/WPOINTER_REG}}

#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/wr_en_reg}} 
#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/pixclk_sync}} 
add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/state_reg}}  
#add_wave {{/TOP/FT245/IFWRITE/state_reg}}
add_wave {{/TOP/FT245/WRREQ}} 
add_wave {wr_en}
add_wave {rd_en} 
#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_INTERFACE/data_valid_signal}}
add_wave {DATA}
#add_wave {image_data}

#add_wave {{/TOP/DISPLAY}}
add_wave {{/TOP/DISP7SEG/VALUE}} 
#add_wave {{/TOP/DISP7SEG/digit}} 
#add_wave {{/TOP/DISP7SEG/SEGMENTS}} 
#add_wave {{/TOP/DISP7SEG/digit_sel}} 
#add_wave {{/TOP/DISPLAYONn}} 

#add_wave {{/TOP/IMAGE_PIPELINE/SENSOR_EMU_EN}}
#add_wave {{/TOP/IMAGE_PIPELINE/sensor_emu_en_changes}}
#add_wave {{/TOP/IMAGE_PIPELINE/reset_signal}} 

# CLK at 100MHz (10ns)
add_force {MCLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns

# Input signals init values
add_force {RST} -radix bin {1 0ns} {0 10ns}
add_force {RXFn} -radix bin {1 0ns} 
add_force {TXEn} -radix bin {1 0ns} 
add_force {FRAME_VALID} -radix bin {0 0ns}
add_force {LINE_VALID} -radix bin {0 0ns}
add_force {SENSOR_EMU_EN} -radix bin {0 0ns} 
run 50ns

# Enable SENSOR EMULATOR
add_force {SENSOR_EMU_EN} -radix bin {1 0ns}
# Request data to FPGA from PC 
add_force {RXFn} -radix bin {0 0ns} {1 10ns} 
run 50ns

# Enable SENSOR EMULATOR to write frame data (< 30ms) to PC
add_force {TXEn} -radix bin {0 0ns} {1 10ns} {0 60ns} -repeat_every 100ns
run 32ms

# Option frame in color format (12.5MHz of XCLK). Needs the double time to transmit one frame (comment the rest of the lines).
# Comment this two lines to other simulation scenarios.
#run 32ms 
add_force {TXEn} -radix bin {1 0ns}

# Enable read data from PC (speed value)
add_force {TXEn} -radix bin {1 0ns} 
# Active signal FIFO with data available (RXFn) and inactive after 40ns
add_force {RXFn} -radix bin {0 0ns} {1 40ns}
# Force input DATA
add_force {DATA} -radix hex {0 0ns} {50 25ns}
run 40ns
remove_force {DATA} 
run 100ns

# Request data to FPGA from PC 
add_force {RXFn} -radix bin {0 0ns} {1 10ns} 
run 50ns

# Enable SENSOR EMULATOR to write frame data (< 30ms) to PC (worst case)
add_force {TXEn} -radix bin {0 0ns} {1 10ns} {0 60ns} -repeat_every 100ns
run 35ms

# Disable write and SENSOR EMULATOR
add_force {SENSOR_EMU_EN} -radix bin {0 0ns} 
add_force {TXEn} -radix bin {1 0ns}
run 60ns
