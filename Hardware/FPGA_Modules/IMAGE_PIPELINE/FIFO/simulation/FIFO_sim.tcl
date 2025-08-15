##  Company: University of Málaga
##  Project: TFM - Speed Traffic Sign Recognition System 
##  Engineer: Manuel Sánchez Natera


# Restart simulation
restart

# Input signals
add_wave {CLK}
add_wave {RST}
add_wave {DIN}
add_wave {PUSH}
add_wave {POP}
# Output signals
add_wave {DOUT}
add_wave {FULL}
add_wave {EMPTY}
# Internal signals
add_wave {WORD_COUNTER_REG}
add_wave {RPOINTER_REG}
add_wave {WPOINTER_REG}
add_wave {ram_name}
add_wave {RAM_DEPTH}

# Define CLK signal with a 10ns (100MHz) period.
add_force {CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns

# Force RESET
add_force {RST} -radix bin {1 0ns} {0 30ns}

# Force writing into FIFO until FULL
add_force {PUSH} -radix bin {1 0ns} {0 70ns}
add_force {POP} -radix bin {0 0ns}
# Set DIN value
add_force {DIN} -radix hex {0 0ns} {3 10ns} {5 30ns} {7 40ns} {9 50ns} {93 60ns}
run 80ns

# Force reading from FIFO until EMPTY
add_force {POP} -radix bin {1 0ns}
run 50ns

# Set DIN value
add_force {DIN} -radix hex {80 0ns} {33 10ns} {26 20ns} {14 30ns} {12 40ns}
# Force POP and PUSH active value
add_force {PUSH} -radix bin {1 0ns} {0 50ns}
add_force {POP} -radix bin {0 0ns} {1 30ns}
run 50ns

# Force RESET signal active (POP and PUSH inactive)
# Set DIN value
add_force {DIN} -radix hex {22 0ns} {88 10ns} {37 20ns}
add_force {POP} -radix bin {1 0ns} {0 20ns} 
add_force {RST} -radix bin {1 0ns} 
run 40ns
