###########################################################
## 	Basys3 board - Pins & Signals connections
###########################################################

## Clock signal 
set_property PACKAGE_PIN W5 [get_ports MCLK]
set_property IOSTANDARD LVCMOS33 [get_ports MCLK]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {MCLK}]

## 	Switches (most of them without use on this application)

set_property PACKAGE_PIN V17 [get_ports SENSOR_EMU_EN]
set_property IOSTANDARD LVCMOS33 [get_ports SENSOR_EMU_EN]
#set_property PACKAGE_PIN V16 [get_ports {SW[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[1]}]
#set_property PACKAGE_PIN W16 [get_ports {SW[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[2]}]
#set_property PACKAGE_PIN W17 [get_ports {SW[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[3]}]
#set_property PACKAGE_PIN W15 [get_ports {SW[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[4]}]
#set_property PACKAGE_PIN V15 [get_ports {SW[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[5]}]
#set_property PACKAGE_PIN W14 [get_ports {SW[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[6]}]
#set_property PACKAGE_PIN W13 [get_ports {SW[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[7]}]
#set_property PACKAGE_PIN V2 [get_ports {SW[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[8]}]
#set_property PACKAGE_PIN T3 [get_ports {SW[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[9]}]
#set_property PACKAGE_PIN T2 [get_ports {SW[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[10]}]
#set_property PACKAGE_PIN R3 [get_ports {SW[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[11]}]
#set_property PACKAGE_PIN W2 [get_ports {SW[12]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[12]}]
#set_property PACKAGE_PIN U1 [get_ports {SW[13]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[13]}]
#set_property PACKAGE_PIN T1 [get_ports {SW[14]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[14]}]
#set_property PACKAGE_PIN R2 [get_ports {SW[15]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SW[15]}]

## 	LEDs 

set_property PACKAGE_PIN U16 [get_ports LED]
set_property IOSTANDARD LVCMOS33 [get_ports LED]
#set_property PACKAGE_PIN U16 [get_ports {LED[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
#set_property PACKAGE_PIN E19 [get_ports {LED[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
#set_property PACKAGE_PIN U19 [get_ports {LED[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
#set_property PACKAGE_PIN V19 [get_ports {LED[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
#set_property PACKAGE_PIN W18 [get_ports {LED[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
#set_property PACKAGE_PIN U15 [get_ports {LED[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
#set_property PACKAGE_PIN U14 [get_ports {LED[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
#set_property PACKAGE_PIN V14 [get_ports {LED[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
#set_property PACKAGE_PIN V13 [get_ports {LED[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[8]}]
#set_property PACKAGE_PIN V3 [get_ports {LED[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[9]}]
#set_property PACKAGE_PIN W3 [get_ports {LED[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[10]}]
#set_property PACKAGE_PIN U3 [get_ports {LED[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[11]}]
#set_property PACKAGE_PIN P3 [get_ports {LED[12]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[12]}]
#set_property PACKAGE_PIN N3 [get_ports {LED[13]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[13]}]
#set_property PACKAGE_PIN P1 [get_ports {LED[14]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[14]}]
#set_property PACKAGE_PIN L1 [get_ports {LED[15]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LED[15]}]


## 	7 segment display

# Cathodes
set_property PACKAGE_PIN W7 [get_ports {DISPLAY[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[0]}]
set_property PACKAGE_PIN W6 [get_ports {DISPLAY[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[1]}]
set_property PACKAGE_PIN U8 [get_ports {DISPLAY[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[2]}]
set_property PACKAGE_PIN V8 [get_ports {DISPLAY[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[3]}]
set_property PACKAGE_PIN U5 [get_ports {DISPLAY[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[4]}]
set_property PACKAGE_PIN V5 [get_ports {DISPLAY[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[5]}]
set_property PACKAGE_PIN U7 [get_ports {DISPLAY[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[6]}]
set_property PACKAGE_PIN V7 [get_ports {DISPLAY[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[7]}]

# Anodes
set_property PACKAGE_PIN U2 [get_ports {DISPLAYONn[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAYONn[0]}]
set_property PACKAGE_PIN U4 [get_ports {DISPLAYONn[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAYONn[1]}]
set_property PACKAGE_PIN V4 [get_ports {DISPLAYONn[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAYONn[2]}]
set_property PACKAGE_PIN W4 [get_ports {DISPLAYONn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAYONn[3]}]


## 	Buttons (most of them without use on this application)

set_property PACKAGE_PIN U18 [get_ports RST]
set_property IOSTANDARD LVCMOS33 [get_ports RST]
#set_property PACKAGE_PIN T18 [get_ports upBtn]
#set_property IOSTANDARD LVCMOS33 [get_ports upBtn]
#set_property PACKAGE_PIN W19 [get_ports leftBtn]
#set_property IOSTANDARD LVCMOS33 [get_ports leftBtn]
#set_property PACKAGE_PIN T17 [get_ports rightBtn]
#set_property IOSTANDARD LVCMOS33 [get_ports rightBtn]
#set_property PACKAGE_PIN U17 [get_ports downBtn]
#set_property IOSTANDARD LVCMOS33 [get_ports downBtn]

## 	Header JA - connected to UM232H-B CTRL Signals (FT245 CHIP)

# JA1 port
set_property PACKAGE_PIN J1 [get_ports RXFn]
set_property IOSTANDARD LVCMOS33 [get_ports RXFn]
# JA2 port
set_property PACKAGE_PIN L2 [get_ports RDn]
set_property IOSTANDARD LVCMOS33 [get_ports RDn]
# JA3 port
set_property PACKAGE_PIN J2 [get_ports SIWUn]
set_property IOSTANDARD LVCMOS33 [get_ports SIWUn]
# JA7 port
set_property PACKAGE_PIN H1 [get_ports TXEn]
set_property IOSTANDARD LVCMOS33 [get_ports TXEn]
# JA8 port
set_property PACKAGE_PIN K2 [get_ports WRn]
set_property IOSTANDARD LVCMOS33 [get_ports WRn]
# JA9 port
set_property PACKAGE_PIN G3 [get_ports PWRSAVn]
set_property IOSTANDARD LVCMOS33 [get_ports PWRSAVn]

## 	Header JXADC - connected to UM232H-B DATA Signals (FT245 CHIP)

# JXAC1
set_property PACKAGE_PIN J3 [get_ports {DATA[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA[0]}]
# JXAC2
set_property PACKAGE_PIN L3 [get_ports {DATA[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA[1]}]
# JXAC3
set_property PACKAGE_PIN M2 [get_ports {DATA[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA[2]}]
# JXAC4
set_property PACKAGE_PIN N2 [get_ports {DATA[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA[3]}]
# JXAC7
set_property PACKAGE_PIN K3 [get_ports {DATA[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA[4]}]
# JXAC8
set_property PACKAGE_PIN M3 [get_ports {DATA[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA[5]}]
#JXAC9
set_property PACKAGE_PIN M1 [get_ports {DATA[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA[6]}]
# JXAC10
set_property PACKAGE_PIN N1 [get_ports {DATA[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA[7]}]

## 	Header JB - connected to IMAGE SENSOR Signals (MT9V111)

# JB1
set_property PACKAGE_PIN A14 [get_ports RSTn]
set_property IOSTANDARD LVCMOS33 [get_ports RSTn]
# JB2
set_property PACKAGE_PIN A16 [get_ports {SENSOR_DATA[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SENSOR_DATA[0]}]
# JB3
set_property PACKAGE_PIN B15 [get_ports {SENSOR_DATA[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SENSOR_DATA[2]}]
# JB4
set_property PACKAGE_PIN B16 [get_ports {SENSOR_DATA[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SENSOR_DATA[4]}]
# JB8
set_property PACKAGE_PIN A17 [get_ports {SENSOR_DATA[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SENSOR_DATA[1]}]
# JB9
set_property PACKAGE_PIN C15 [get_ports {SENSOR_DATA[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SENSOR_DATA[3]}]
# JB10
set_property PACKAGE_PIN C16 [get_ports {SENSOR_DATA[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SENSOR_DATA[5]}]

## 	Header JC - connected to IMAGE SENSOR Signals (MT9V111)

# JC1
set_property PACKAGE_PIN K17 [get_ports {SENSOR_DATA[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SENSOR_DATA[6]}]
# JC2
set_property PACKAGE_PIN M18 [get_ports XCLK]
set_property IOSTANDARD LVCMOS33 [get_ports XCLK]
# JC3
set_property PACKAGE_PIN N17 [get_ports LINE_VALID]
set_property IOSTANDARD LVCMOS33 [get_ports LINE_VALID]
# JC4
#set_property PACKAGE_PIN P18 [get_ports SDA]
#set_property IOSTANDARD LVCMOS33 [get_ports SDA]
# JC7
set_property PACKAGE_PIN L17 [get_ports PIXCLK]
set_property IOSTANDARD LVCMOS33 [get_ports PIXCLK]
# JC8
set_property PACKAGE_PIN M19 [get_ports {SENSOR_DATA[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SENSOR_DATA[7]}]
# JC9
set_property PACKAGE_PIN P17 [get_ports FRAME_VALID]
set_property IOSTANDARD LVCMOS33 [get_ports FRAME_VALID]
# JC10
#set_property PACKAGE_PIN R18 [get_ports SCL]
#set_property IOSTANDARD LVCMOS33 [get_ports SCL]

###########################################################
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
###########################################################
