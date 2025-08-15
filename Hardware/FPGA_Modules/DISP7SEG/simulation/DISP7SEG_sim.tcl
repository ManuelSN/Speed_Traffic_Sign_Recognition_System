##  Company: University of Málaga
##  Project: TFM - Speed Traffic Sign Recognition System 
##  Engineer: Manuel Sánchez Natera


# Restart simulation
restart

# Input signal
add_wave {{/DISP7SEG/CLK}}
add_wave {{/DISP7SEG/RST}} 
add_wave {{/DISP7SEG/VALUE}} 
add_wave {{/DISP7SEG/digit_sel}}
add_wave {{/DISP7SEG/digit}}

# CLK at 100MHz (10ns)
add_force {CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns

# RST signal values
add_force {RST} -radix hex {1 0ns} {0 10ns}

# Force input VALUE
add_force {VALUE} -radix dec {50 0ns} 

run 10000000ns
