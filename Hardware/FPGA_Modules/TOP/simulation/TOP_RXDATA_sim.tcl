##  Company: University of Málaga
##  Project: TFM - Speed Traffic Sign Recognition System 
##  Engineer: Manuel Sánchez Natera


# Restart simulation
restart

# Input signals
add_wave {MCLK}
add_wave {RST}
add_wave {DATA}
add_wave {RD_EN}
add_wave {RXFn}
# Output signals
add_wave {RDn}
add_wave {RDREQ}
# Internal signals
add_wave {{/TOP/FT245/IFREAD/state_reg}}
add_wave {{/TOP/DISPLAY}}
add_wave {{/TOP/DISP7SEG/VALUE}} 
add_wave {{/TOP/DISP7SEG/digit}} 
add_wave {{/TOP/DISP7SEG/SEGMENTS}} 
add_wave {{/TOP/DISP7SEG/digit_sel}} 
add_wave {{/TOP/DISPLAYONn}} 
add_wave {{/TOP/FT245/IFREAD/wait_cycles_count}}

 
# CLK at 100MHz (10ns)
add_force {MCLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns

# Input signals values
add_force {RST} -radix hex {1 0ns} {0 10ns}
add_force {RD_EN} -radix bin {0 0ns} 
add_force {RXFn} -radix bin {1 0ns} 
run 50ns

# Enable data read
add_force {RD_EN} -radix bin {1 0ns} 
run 20ns

# Active signal FIFO with data available (RXFn)
add_force {RXFn} -radix bin {0 0ns} 
run 15ns

# Force input DATA
#T3
run 25ns 
add_force {DATA} -radix dec {50 0ns} 

# Inactive signal FIFO with data available (RXFn)
add_force {RXFn} -radix bin {1 0ns}
run 40ns
remove_force {DATA} 

run 10ns
# Active signal FIFO with data available (RXFn)
add_force {RXFn} -radix bin {0 0ns} 

# Force input DATA
run 50ns
add_force {DATA} -radix dec {110 0ns} 

# Active signal FIFO with data available (RXFn)
add_force {RXFn} -radix bin {0 0ns} 
run 15ns

#T3
run 25ns 

# Inactive signal FIFO with data available (RXFn)
add_force {RXFn} -radix bin {1 0ns}
run 40ns
remove_force {DATA} 

run 10ns
# Active signal FIFO with data available (RXFn)
add_force {RXFn} -radix bin {0 0ns} 

run 50ns
