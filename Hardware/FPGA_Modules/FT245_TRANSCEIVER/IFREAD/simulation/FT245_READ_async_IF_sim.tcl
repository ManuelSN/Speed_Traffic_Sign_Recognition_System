##  Company: University of Málaga
##  Project: TFM - Speed Traffic Sign Recognition System 
##  Engineer: Manuel Sánchez Natera


# Restart simulation
restart

# Input signals
add_wave {CLK}
add_wave {RST}
add_wave {DIN}
add_wave {RD_EN}
add_wave {RXFn}
# Output signals
add_wave {RDn}
add_wave {RDREQ}
add_wave {DOUT}
# Internal signals
add_wave {{/FT245_Read_async_IF/RXFn_sync}} 
add_wave {state_reg}

# CLK at 100MHz (10ns)
add_force {CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns

# Input signals values
add_force {RST} -radix hex {1 0ns} {0 10ns}
add_force {RXFn} -radix bin {1 0ns} 
add_force {RD_EN} -radix bin {0 0ns} {1 10ns} 
add_force {DIN} -radix dec {20 0ns} 
run 40ns

# Force input DATA
# DIN Timing: T3 + T3 = 28ns
add_force {DIN} -radix dec {50 0ns} {20 60ns}
# Active signal FIFO with data available (RXFn) 
# RXFn Timing: T4 + T1 + T2 = 40ns(>30ns) + 14ns + 49ns = 103ns
# 40ns + 20ns + 50ns = 110ns in clock steps (10ns)
add_force {RXFn} -radix bin {0 0ns} {1 60ns} 
run 110ns 

# Force input DATA
# DIN Timing: T3 + T3 = 28ns
add_force {DIN} -radix dec {110 0ns} {20 60ns}
# Active signal FIFO with data available (RXFn) 
# RXFn Timing: T4 + T1 + T2 = 40ns(>30ns) + 14ns + 49ns = 103ns
# 40ns + 20ns + 50ns = 110ns in clock steps (10ns)
add_force {RXFn} -radix bin {0 0ns} {1 60ns}
run 110ns

# END OF READ
add_force {RD_EN} -radix bin {0 0ns} 
run 40ns
