##  Company: University of Málaga
##  Project: TFM - Speed Traffic Sign Recognition System 
##  Engineer: Manuel Sánchez Natera


# Restart simulation
restart

# Input signals
add_wave {CLK}
add_wave {RST}
add_wave {DIN}
add_wave {WR_EN}
add_wave {TXEn}
# Output signals
add_wave {READY}
add_wave {WRn}
add_wave {WRREQ}
add_wave {DOUT}
# Internal signals
add_wave {state_reg}
 
# CLK at 100MHz (10ns)
add_force {CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns

# Input signals values
add_force {RST} -radix hex {1 0ns} {0 10ns}
add_force {TXEn} -radix bin {1 0ns} 
add_force {WR_EN} -radix bin {0 0ns} {1 10ns} 
add_force {DIN} -radix bin {0 0ns} 
run 50ns

# Write Cycle
add_force {TXEn} -radix bin {0 0ns} {1 30ns}  # Active TXEn signal
add_force {DIN} -radix dec {50 0ns}
# T6 + T7 = 14ns + 49ns
run 70ns

# Write Cycle
add_force {TXEn} -radix bin {0 0ns} {1 30ns} # Active TXEn signal
add_force {DIN} -radix dec {110 0ns}
# T6 + T7 = 14ns + 49ns
run 70ns

# END OF WRITE
add_force {WR_EN} -radix bin {0 0ns} 
run 50ns



