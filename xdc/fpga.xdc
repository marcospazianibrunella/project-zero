# XDC constraints for the Xilinx Alveo U280 board
# part: xcu280-fsvh2892-2L-e

#Clock Trees
#
#    1) AB-557-03 - ABRACON AB-557-03-HCHC-F-L-C-T @ 100.000Mhz Dual Output PCIe MEMs Oscillator
#
#      - OUT0--> SYS_CLK5_P/SYS_CLK5_N @ 100.000Mhz - PCIe REFCLK1 for x16 and Bifurcated x8 Lanes 8-15 Asynchronous Clocking
#                PINS: MGTREFCLK1P_225_AP13/MGTREFCLK1N_225_AP12
#
#      - OUT1--> SYSCLK_P/SYSCLK_P @ 100.000Mhz 1-to-4 Clock buffer
#           |
#           |--> SI53340-B-GM --> OUT0  SYSCLK0_P/SYSCLK0_N 100.000Mhz - System Clock for first DDR4 MIG interface and HBM Interfaces.
#                             |   PINS: IO_L12P_T1U_N10_GC_A08_D24_65/IO_L12N_T1U_N11_GC_A09_D25_65
#                             |
#                             |-> OUT1  SYSCLK1_P/SYSCLK1_N 100.000Mhz - System Clock for second DDR4 MIG interface.
#                             |   PINS: IO_L13P_T2L_N0_GC_QBC_69/IO_L13N_T2L_N1_GC_QBC_69
#                             |
#                             |-> OUT2  SYSCLK2_P/SYSCLK2_N 100.000Mhz - PCIe REFCLK1 for Bifurcated x8 Lanes 0-7 Asynchronous Clocking
#                             |   PINS: MGTREFCLK1P_227_AK13/MGTREFCLK1N_227_AK12
#                             |
#                             |-> OUT3  SYSCLK3_P/SYSCLK3_N 100.000Mhz - BANK 75 100Mhz Input clock
#                                 PINS: IO_L11P_T1U_N8_GC_75/IO_L11N_T1U_N9_GC_75
#
#    2) SI570 - SiLabs 570BAB000544DG @ 156.250Mhz Programmable Oscillator (Re-programming I2C access ONLY possible via Satellite Controller)
#
#      - OUT---> SI570_OUTPUT_P/SI570_OUTPUT_N @ 156.250Mhz LVDS
#           |
#           |--> SI53340-B-GM --> OUT0  USER_SI570_CLOCK_P/USER_SI570_CLOCK_N 156.250Mhz - General Perpose System Clock.
#                             |   PINS: IO_L12P_T1U_N10_GC_75_G30/IO_L12N_T1U_N11_GC_75_F30
#                             |
#                             |-> OUT1  Not Connected
#                             |   PINS: NA
#                             |
#                             |-> OUT2  MGT_SI570_CLOCK0_C_P/MGT_SI570_CLOCK0_C_N 156.250Mhz - QSFP0 REFCLK0
#                             |   PINS: MGTREFCLK0P_134_T42/MGTREFCLK0N_134_T43
#                             |
#                             |-> OUT3  MGT_SI570_CLOCK1_C_P/MGT_SI570_CLOCK1_C_N 156.250Mhz - QSFP0 REFCLK1
#                                 PINS: MGTREFCLK0P_135_P42/MGTREFCLK0N_135_P43
#
#    3) SI546 - SiLabs 546BAB001028BBG Selectable output Oscillator 156.2500Mhz/161.1328125Mhz For QSFP0 REFCLK1
#
#      - OE_B <-- Active low input to SI546 to enable output frequency - Connected to
#                PINS: "QSFP0_OEB"  - IO_L9P_T1L_N4_AD12P_75_H32
#      - FS   <-- Clock Select Pin FS = 1 -> 161.132812 MHz 1.8V LVDS (default when FPGA pin Hi-Z or driven High)
#                                  FS = 0 -> 156.25 MHz 1.8V LVDS When driven low by FPGA
#                PINS: "QSFP0_FS"   - IO_L9N_T1L_N5_AD12N_75_G32
#
#      - OUT0--> QSFP0_CLOCK_P/QSFP0_CLOCK_N @ 161.1328125Mhz
#                PINS: MGTREFCLK1P_134_R40/MGTREFCLK1N_134_R41
#
#    4) SI546 - SiLabs 546BAB001028BBG Selectable output Oscillator 156.2500Mhz/161.1328125Mhz For QSFP1 REFCLK1
#
#      - OE_B <-- Active low input to SI546 to enable output frequency - Connected to
#                PINS: QSFP1_OEB    - IO_L8N_T1L_N3_AD5N_75_H30
#      - FS   <-- Clock Select Pin FS = 1 -> 161.132812 MHz 1.8V LVDS (default when FPGA pin Hi-Z or driven High)
#                                  FS = 0 -> 156.25 MHz 1.8V LVDS when driven low by FPGA
#                PINS: "QSFP1_FS"   - IO_L7N_T1L_N1_QBC_AD13N_75_G33
#
#      - OUT0--> QSFP1_CLOCK_P/QSFP1_CLOCK_N @ 161.1328125Mhz
#                PINS: MGTREFCLK1P_135_M42/MGTREFCLK1N_135_M43

# General configuration
set_property CFGBVS GND                                [current_design];
set_property CONFIG_VOLTAGE 1.8                        [current_design];
set_property BITSTREAM.CONFIG.CONFIGFALLBACK ENABLE    [current_design];
set_property BITSTREAM.GENERAL.COMPRESS TRUE           [current_design];
set_property CONFIG_MODE SPIx4                         [current_design];
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4           [current_design];
set_property BITSTREAM.CONFIG.CONFIGRATE 85.0          [current_design];
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN DISABLE [current_design];
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES        [current_design];
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLUP         [current_design];
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR YES       [current_design];

# HBM overtemp
set_property -dict {LOC D32 IOSTANDARD LVCMOS18} [get_ports hbm_cattrip]

set_false_path -to [get_ports {hbm_cattrip}]
set_output_delay 0 [get_ports {hbm_cattrip}]

# System clock and reset
set_property -dict {LOC L30 IOSTANDARD LVCMOS18} [get_ports sys_rstn] ;# CPU Resetn
set_false_path -from [get_ports {sys_rstn}]
set_input_delay 0 [get_ports {sys_rstn}]

# QSFP0 Interface
set_property -dict {LOC L53 } [get_ports qsfp0_rx_p[0]] ;# MGTYRXP0_134 GTYE4_CHANNEL_X0Y40 / GTYE4_COMMON_X0Y10
set_property -dict {LOC L54 } [get_ports qsfp0_rx_n[0]] ;# MGTYRXN0_134 GTYE4_CHANNEL_X0Y40 / GTYE4_COMMON_X0Y10
set_property -dict {LOC L48 } [get_ports qsfp0_tx_p[0]] ;# MGTYTXP0_134 GTYE4_CHANNEL_X0Y40 / GTYE4_COMMON_X0Y10
set_property -dict {LOC L49 } [get_ports qsfp0_tx_n[0]] ;# MGTYTXN0_134 GTYE4_CHANNEL_X0Y40 / GTYE4_COMMON_X0Y10
set_property -dict {LOC K51 } [get_ports qsfp0_rx_p[1]] ;# MGTYRXP1_134 GTYE4_CHANNEL_X0Y41 / GTYE4_COMMON_X0Y10
set_property -dict {LOC K52 } [get_ports qsfp0_rx_n[1]] ;# MGTYRXN1_134 GTYE4_CHANNEL_X0Y41 / GTYE4_COMMON_X0Y10
set_property -dict {LOC L44 } [get_ports qsfp0_tx_p[1]] ;# MGTYTXP1_134 GTYE4_CHANNEL_X0Y41 / GTYE4_COMMON_X0Y10
set_property -dict {LOC L45 } [get_ports qsfp0_tx_n[1]] ;# MGTYTXN1_134 GTYE4_CHANNEL_X0Y41 / GTYE4_COMMON_X0Y10
set_property -dict {LOC J53 } [get_ports qsfp0_rx_p[2]] ;# MGTYRXP2_134 GTYE4_CHANNEL_X0Y42 / GTYE4_COMMON_X0Y10
set_property -dict {LOC J54 } [get_ports qsfp0_rx_n[2]] ;# MGTYRXN2_134 GTYE4_CHANNEL_X0Y42 / GTYE4_COMMON_X0Y10
set_property -dict {LOC K46 } [get_ports qsfp0_tx_p[2]] ;# MGTYTXP2_134 GTYE4_CHANNEL_X0Y42 / GTYE4_COMMON_X0Y10
set_property -dict {LOC K47 } [get_ports qsfp0_tx_n[2]] ;# MGTYTXN2_134 GTYE4_CHANNEL_X0Y42 / GTYE4_COMMON_X0Y10
set_property -dict {LOC H51 } [get_ports qsfp0_rx_p[3]] ;# MGTYRXP3_134 GTYE4_CHANNEL_X0Y43 / GTYE4_COMMON_X0Y10
set_property -dict {LOC H52 } [get_ports qsfp0_rx_n[3]] ;# MGTYRXN3_134 GTYE4_CHANNEL_X0Y43 / GTYE4_COMMON_X0Y10
set_property -dict {LOC J48 } [get_ports qsfp0_tx_p[3]] ;# MGTYTXP3_134 GTYE4_CHANNEL_X0Y43 / GTYE4_COMMON_X0Y10
set_property -dict {LOC J49 } [get_ports qsfp0_tx_n[3]] ;# MGTYTXN3_134 GTYE4_CHANNEL_X0Y43 / GTYE4_COMMON_X0Y10
set_property -dict {LOC R40 } [get_ports qsfp0_mgt_refclk_1_p] ;# MGTREFCLK1P_134 from SI546
set_property -dict {LOC R41 } [get_ports qsfp0_mgt_refclk_1_n] ;# MGTREFCLK1N_134 from SI546
set_property -dict {LOC H32 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp0_refclk_oe_b]
set_property -dict {LOC G32 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp0_refclk_fs]
set_false_path -to [get_ports {qsfp0_refclk_oe_b qsfp0_refclk_fs}]
set_output_delay 0 [get_ports {qsfp0_refclk_oe_b qsfp0_refclk_fs}]

# QSFP1 Interface
set_property -dict {LOC G53 } [get_ports qsfp1_rx_p[0]] ;# MGTYRXP0_135 GTYE4_CHANNEL_X0Y44 / GTYE4_COMMON_X0Y11
set_property -dict {LOC G54 } [get_ports qsfp1_rx_n[0]] ;# MGTYRXN0_135 GTYE4_CHANNEL_X0Y44 / GTYE4_COMMON_X0Y11
set_property -dict {LOC G48 } [get_ports qsfp1_tx_p[0]] ;# MGTYTXP0_135 GTYE4_CHANNEL_X0Y44 / GTYE4_COMMON_X0Y11
set_property -dict {LOC G49 } [get_ports qsfp1_tx_n[0]] ;# MGTYTXN0_135 GTYE4_CHANNEL_X0Y44 / GTYE4_COMMON_X0Y11
set_property -dict {LOC F51 } [get_ports qsfp1_rx_p[1]] ;# MGTYRXP1_135 GTYE4_CHANNEL_X0Y45 / GTYE4_COMMON_X0Y11
set_property -dict {LOC F52 } [get_ports qsfp1_rx_n[1]] ;# MGTYRXN1_135 GTYE4_CHANNEL_X0Y45 / GTYE4_COMMON_X0Y11
set_property -dict {LOC E48 } [get_ports qsfp1_tx_p[1]] ;# MGTYTXP1_135 GTYE4_CHANNEL_X0Y45 / GTYE4_COMMON_X0Y11
set_property -dict {LOC E49 } [get_ports qsfp1_tx_n[1]] ;# MGTYTXN1_135 GTYE4_CHANNEL_X0Y45 / GTYE4_COMMON_X0Y11
set_property -dict {LOC E53 } [get_ports qsfp1_rx_p[2]] ;# MGTYRXP2_135 GTYE4_CHANNEL_X0Y46 / GTYE4_COMMON_X0Y11
set_property -dict {LOC E54 } [get_ports qsfp1_rx_n[2]] ;# MGTYRXN2_135 GTYE4_CHANNEL_X0Y46 / GTYE4_COMMON_X0Y11
set_property -dict {LOC C48 } [get_ports qsfp1_tx_p[2]] ;# MGTYTXP2_135 GTYE4_CHANNEL_X0Y46 / GTYE4_COMMON_X0Y11
set_property -dict {LOC C49 } [get_ports qsfp1_tx_n[2]] ;# MGTYTXN2_135 GTYE4_CHANNEL_X0Y46 / GTYE4_COMMON_X0Y11
set_property -dict {LOC D51 } [get_ports qsfp1_rx_p[3]] ;# MGTYRXP3_135 GTYE4_CHANNEL_X0Y47 / GTYE4_COMMON_X0Y11
set_property -dict {LOC D52 } [get_ports qsfp1_rx_n[3]] ;# MGTYRXN3_135 GTYE4_CHANNEL_X0Y47 / GTYE4_COMMON_X0Y11
set_property -dict {LOC A49 } [get_ports qsfp1_tx_p[3]] ;# MGTYTXP3_135 GTYE4_CHANNEL_X0Y47 / GTYE4_COMMON_X0Y11
set_property -dict {LOC A50 } [get_ports qsfp1_tx_n[3]] ;# MGTYTXN3_135 GTYE4_CHANNEL_X0Y47 / GTYE4_COMMON_X0Y11
set_property -dict {LOC M42 } [get_ports qsfp1_mgt_refclk_1_p] ;# MGTREFCLK1P_135 from SI546
set_property -dict {LOC M43 } [get_ports qsfp1_mgt_refclk_1_n] ;# MGTREFCLK1N_135 from SI546
set_property -dict {LOC H30 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp1_refclk_oe_b]
set_property -dict {LOC G33 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp1_refclk_fs]
set_false_path -to [get_ports {qsfp1_refclk_oe_b qsfp1_refclk_fs}]
set_output_delay 0 [get_ports {qsfp1_refclk_oe_b qsfp1_refclk_fs}]


# PCIe Clocks and Reset
#set_property -dict {LOC AR15} [get_ports pcie_refclk_1_p] ;# MGTREFCLK0P_225 (for x16 or x8 bifurcated lanes 8-16)
#set_property -dict {LOC AR14} [get_ports pcie_refclk_1_n] ;# MGTREFCLK0N_225 (for x16 or x8 bifurcated lanes 8-16)
#set_property -dict {LOC BH26 IOSTANDARD LVCMOS18 PULLUP true} [get_ports pcie_rst_n]
#set_false_path -from [get_ports {pcie_rst_n}]
#set_input_delay 0 [get_ports {pcie_rst_n}]
#
## PCIe GTY 227 
#set_property -dict {LOC AN1  }  [get_ports {pcie_4x_0_rx_n[3]} ] ;# Bank 227 - MGTYRXN0_227
#set_property -dict {LOC AN5  }  [get_ports {pcie_4x_0_rx_n[2]} ] ;# Bank 227 - MGTYRXN1_227
#set_property -dict {LOC AM3  }  [get_ports {pcie_4x_0_rx_n[1]} ] ;# Bank 227 - MGTYRXN2_227
#set_property -dict {LOC AL1  }  [get_ports {pcie_4x_0_rx_n[0]} ] ;# Bank 227 - MGTYRXN3_227
#set_property -dict {LOC AN2  }  [get_ports {pcie_4x_0_rx_p[3]} ] ;# Bank 227 - MGTYRXP0_227
#set_property -dict {LOC AN6  }  [get_ports {pcie_4x_0_rx_p[2]} ] ;# Bank 227 - MGTYRXP1_227
#set_property -dict {LOC AM4  }  [get_ports {pcie_4x_0_rx_p[1]} ] ;# Bank 227 - MGTYRXP2_227
#set_property -dict {LOC AL2  }  [get_ports {pcie_4x_0_rx_p[0]} ] ;# Bank 227 - MGTYRXP3_227
#set_property -dict {LOC AP8  }  [get_ports {pcie_4x_0_tx_n[3]} ] ;# Bank 227 - MGTYTXN0_227
#set_property -dict {LOC AN10 }  [get_ports {pcie_4x_0_tx_n[2]} ] ;# Bank 227 - MGTYTXN1_227
#set_property -dict {LOC AM8  }  [get_ports {pcie_4x_0_tx_n[1]} ] ;# Bank 227 - MGTYTXN2_227
#set_property -dict {LOC AL10 }  [get_ports {pcie_4x_0_tx_n[0]} ] ;# Bank 227 - MGTYTXN3_227
#set_property -dict {LOC AP9  }  [get_ports {pcie_4x_0_tx_p[3]} ] ;# Bank 227 - MGTYTXP0_227
#set_property -dict {LOC AN11 }  [get_ports {pcie_4x_0_tx_p[2]} ] ;# Bank 227 - MGTYTXP1_227
#set_property -dict {LOC AM9  }  [get_ports {pcie_4x_0_tx_p[1]} ] ;# Bank 227 - MGTYTXP2_227
#set_property -dict {LOC AL11 }  [get_ports {pcie_4x_0_tx_p[0]} ] ;# Bank 227 - MGTYTXP3_227
#
#
## Clock Constraints 
#create_clock -period 10 -name pcie_mgt_refclk_1 [get_ports pcie_refclk_1_p]
