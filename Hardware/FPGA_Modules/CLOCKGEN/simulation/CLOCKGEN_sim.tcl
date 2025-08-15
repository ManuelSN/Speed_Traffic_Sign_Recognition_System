##  Company: University of Málaga
##  Project: TFM - Speed Traffic Sign Recognition System 
##  Engineer: Manuel Sánchez Natera


# Restart simulation
restart

# Input signals
add_wave {CLKREF}
add_wave {RST}
# Output signals signals
add_wave {CLKGEN}

# CLKGEN at 100MHz (10ns)
add_force {CLKREF} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns

# RST signal values
add_force {RST} -radix hex {1 0ns} {0 10ns}
run 200ns
