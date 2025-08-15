##  Company: University of Málaga
##  Project: TFM - Speed Traffic Sign Recognition System 
##  Engineer: Manuel Sánchez Natera


# Restart simulation
restart

# Input signals
add_wave {CLK_IN}
add_wave {RST}
# Output signals
add_wave {PIXCLK}
add_wave {FRAME_VALID}
add_wave {LINE_VALID}
add_wave {IMAGE_DATA}
# Internal signals
add_wave {state_reg}
add_wave {sofblank_count}
add_wave {active_count}
add_wave {lines_count}
add_wave {hblank_count}
add_wave {eofblank_count}
add_wave {vblank_count}

# Define CLK signal with 40ns (25MHz) period.
add_force {CLK_IN} -radix bin {0 0ns} {1 20ns} -repeat_every 40ns

# Force active RST
add_force {RST} -radix bin {1 0ns} {0 1us}
run 1us

# Simulate one frame transmission (Total Frame Time)
run 35ms

