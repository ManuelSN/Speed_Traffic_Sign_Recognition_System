##  Company: University of Málaga
##  Project: TFM - Speed Traffic Sign Recognition System 
##  Engineer: Manuel Sánchez Natera


# Restart simulation
restart

# Input signals
add_wave {CLK}
add_wave {RST}
add_wave {WR_EN}
add_wave {DIN}
add_wave {TXEn}
# Output signals
add_wave {WRn}
add_wave {WRREQ}
add_wave {READY}
add_wave {DOUT}
# Internal signals
add_wave {{/FT245_Write_async_IF/TXEn_sync}}
add_wave {state_reg}
 
# CLK at 100MHz (10ns)
add_force {CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns

# Input signals values
add_force {RST} -radix bin {1 0ns} {0 10ns}
add_force {TXEn} -radix bin {1 0ns} 
add_force {WR_EN} -radix bin {0 0ns} {1 10ns} 
add_force {DIN} -radix dec {0 0ns} 
run 50ns

# Write Cycle
# Active TXEn signal
add_force {TXEn} -radix bin {0 0ns} {1 30ns}  
add_force {DIN} -radix dec {0 0ns} {50 15ns} {110 35ns}
# Run (ns) => T7=49ns + 30ns (active pulse width TXEn)
run 80ns

# Write Cycle
# Active TXEn signal
add_force {TXEn} -radix bin {0 0ns} {1 30ns} 
add_force {DIN} -radix dec {110 0ns} {30 15ns} {90 35ns}
# Run (ns) => T7=49ns + 30ns (active pulse width TXEn)
run 80ns

# END OF WRITE
add_force {WR_EN} -radix bin {0 0ns} 
run 50ns
