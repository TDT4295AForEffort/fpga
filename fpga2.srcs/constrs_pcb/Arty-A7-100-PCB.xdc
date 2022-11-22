## This file is a general .xdc for the Arty A7-100 Rev. D and Rev. E
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project



## Clock signal

set_property -dict { PACKAGE_PIN P14    IOSTANDARD LVCMOS33 } [get_ports { hw_clk }];
create_clock -add -name sys_clk_pin -period 20.0 -waveform {0 5} [get_ports { hw_clk }];
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets { hw_clk }]

set_property CFGBVS VCCO [current_design];
set_property CONFIG_VOLTAGE 3.3 [current_design];

# Clock from mcu in case oscillator does not work.
# set_property -dict { PACKAGE_PIN N12    IOSTANDARD LVCMOS33 } [get_ports { hw_clk }];
# create_clock -add -name sys_clk_pin -period 20.8333333 -waveform {0 5} [get_ports { hw_clk }];
# set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets { hw_clk }]


# debug LEDs
set_property -dict { PACKAGE_PIN C11    IOSTANDARD LVCMOS33 } [get_ports { hw_led[0] }];
set_property -dict { PACKAGE_PIN C12    IOSTANDARD LVCMOS33 } [get_ports { hw_led[1] }];
set_property -dict { PACKAGE_PIN D13    IOSTANDARD LVCMOS33 } [get_ports { hw_led[2] }];
set_property -dict { PACKAGE_PIN C13    IOSTANDARD LVCMOS33 } [get_ports { hw_led[3] }];

# debug GPIOs mapped to be the button inputs from devboard demo
set_property -dict { PACKAGE_PIN C4    IOSTANDARD LVCMOS33 } [get_ports { hw_btn[0] }];
set_property -dict { PACKAGE_PIN D6    IOSTANDARD LVCMOS33 } [get_ports { hw_btn[1] }];
set_property -dict { PACKAGE_PIN C3    IOSTANDARD LVCMOS33 } [get_ports { hw_btn[2] }];
set_property -dict { PACKAGE_PIN D4    IOSTANDARD LVCMOS33 } [get_ports { hw_btn[3] }];


# debug GPIOs
#set_property -dict { PACKAGE_PIN C4     IOSTANDARD LVCMOS33 } [get_ports { hw_gpio[0]  }];
#set_property -dict { PACKAGE_PIN D6     IOSTANDARD LVCMOS33 } [get_ports { hw_gpio[1]  }];
#set_property -dict { PACKAGE_PIN C3     IOSTANDARD LVCMOS33 } [get_ports { hw_gpio[2]  }];
#set_property -dict { PACKAGE_PIN D4     IOSTANDARD LVCMOS33 } [get_ports { hw_gpio[3]  }];
#set_property -dict { PACKAGE_PIN C2     IOSTANDARD LVCMOS33 } [get_ports { hw_gpio[4]  }];
#set_property -dict { PACKAGE_PIN D3     IOSTANDARD LVCMOS33 } [get_ports { hw_gpio[5]  }];
#set_property -dict { PACKAGE_PIN D1     IOSTANDARD LVCMOS33 } [get_ports { hw_gpio[6]  }];
#set_property -dict { PACKAGE_PIN C1     IOSTANDARD LVCMOS33 } [get_ports { hw_gpio[7]  }];

# VGA
set_property -dict {PACKAGE_PIN B1  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_red[0]}]
set_property -dict {PACKAGE_PIN A2  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_red[1]}]
set_property -dict {PACKAGE_PIN B2  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_red[2]}]
set_property -dict {PACKAGE_PIN A3  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_red[3]}]
set_property -dict {PACKAGE_PIN A4  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_red[4]}]

set_property -dict {PACKAGE_PIN B10 IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_blue[0]}]
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_blue[1]}]
set_property -dict {PACKAGE_PIN B9  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_blue[2]}]
set_property -dict {PACKAGE_PIN A9  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_blue[3]}]
set_property -dict {PACKAGE_PIN A8  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_blue[4]}]

set_property -dict {PACKAGE_PIN B7  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_green[0]}]
set_property -dict {PACKAGE_PIN A7  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_green[1]}]
set_property -dict {PACKAGE_PIN B6  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_green[2]}]
set_property -dict {PACKAGE_PIN B5  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_green[3]}]
set_property -dict {PACKAGE_PIN A5  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_green[4]}]
set_property -dict {PACKAGE_PIN B4  IOSTANDARD LVCMOS33} [get_ports {hw_vga_out_green[5]}]

set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS33} [get_ports hw_hsync]
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports hw_vsync]

# SRAM controls (active-low)
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports {hw_sram_cLB}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports {hw_sram_cUB}]
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports {hw_sram_cOE}]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports {hw_sram_cWE}]
set_property -dict {PACKAGE_PIN T3  IOSTANDARD LVCMOS33} [get_ports {hw_sram_cCE}]

# SRAM_A (address bits)
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[0]}]
set_property -dict {PACKAGE_PIN R1  IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[1]}]
set_property -dict {PACKAGE_PIN P1  IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[2]}]
set_property -dict {PACKAGE_PIN N1  IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[3]}]
set_property -dict {PACKAGE_PIN M1  IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[4]}]
set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[5]}]
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[6]}]
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[7]}]
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[8]}]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[9]}]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[10]}]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[11]}]
set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[12]}]
set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[13]}]
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[14]}]
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[15]}]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[16]}]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[17]}]
set_property -dict {PACKAGE_PIN T2  IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[18]}]
set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVCMOS33} [get_ports {hw_sram_addr[19]}]

# SRAM_D (data bits)

set_property -dict {PACKAGE_PIN T4  IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[0]}]
set_property -dict {PACKAGE_PIN T5  IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[1]}]
set_property -dict {PACKAGE_PIN T7  IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[2]}]
set_property -dict {PACKAGE_PIN T8  IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[3]}]
set_property -dict {PACKAGE_PIN T9  IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[4]}]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[5]}]
set_property -dict {PACKAGE_PIN T12 IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[6]}]
set_property -dict {PACKAGE_PIN T13 IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[7]}]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[8]}]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[9]}]
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[10]}]
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[11]}]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[12]}]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[13]}]
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[14]}]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS33} [get_ports {hw_sram_data[15]}]


# fpga_flash
#set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVCMOS33} [get_ports {hw_flash_cCS}]
#set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports {hw_flash_do_io[0]}]
#set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {hw_flash_do_io[1]}]
#set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports {hw_flash_do_io[2]}]
#set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {hw_flash_do_io[3]}]

# FPGA_MCU_EXTRA1
#set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {hw_mcu_gpio_pin}]

## SPI
set_property -dict { PACKAGE_PIN H1    IOSTANDARD LVCMOS33 } [get_ports { hw_miso }];
set_property -dict { PACKAGE_PIN G2    IOSTANDARD LVCMOS33 } [get_ports { hw_mosi }];
set_property -dict { PACKAGE_PIN H2    IOSTANDARD LVCMOS33 } [get_ports { hw_sclk }];
set_property -dict { PACKAGE_PIN G1    IOSTANDARD LVCMOS33 } [get_ports { hw_ss }];

# fpga uc JTAG / FLASH
#set_property -dict { PACKAGE_PIN N7    IOSTANDARD LVCMOS33 } [get_ports { hw_jtag_tdi }];
#set_property -dict { PACKAGE_PIN N8    IOSTANDARD LVCMOS33 } [get_ports { hw_jtag_tdo }];
#set_property -dict { PACKAGE_PIN M7    IOSTANDARD LVCMOS33 } [get_ports { hw_jtag_tms }];
#set_property -dict { PACKAGE_PIN L7    IOSTANDARD LVCMOS33 } [get_ports { hw_jtag_tck }];

#set_property -dict { PACKAGE_PIN E8    IOSTANDARD LVCMOS33 } [get_ports { hw_flash_cclk }]; # clock from fpga to flash

#set_property -dict { PACKAGE_PIN M9    IOSTANDARD LVCMOS33 } [get_ports { hw_m0 }]; #3.3v
#set_property -dict { PACKAGE_PIN M10   IOSTANDARD LVCMOS33 } [get_ports { hw_m1 }]; #gnd
#set_property -dict { PACKAGE_PIN M11   IOSTANDARD LVCMOS33 } [get_ports { hw_m2 }]; #gnd

#set_property -dict { PACKAGE_PIN H10   IOSTANDARD LVCMOS33 } [get_ports { hw_done }];
#set_property -dict { PACKAGE_PIN K10   IOSTANDARD LVCMOS33 } [get_ports { hw_init }];
#set_property -dict { PACKAGE_PIN L9    IOSTANDARD LVCMOS33 } [get_ports { hw_program }];

#set_property -dict { PACKAGE_PIN E7    IOSTANDARD LVCMOS33 } [get_ports { hw_cfgbvs }]; # 3.3v

#set_property -dict { PACKAGE_PIN H8    IOSTANDARD LVCMOS33 } [get_ports { hw_vp }];    # gnd
#set_property -dict { PACKAGE_PIN J7    IOSTANDARD LVCMOS33 } [get_ports { hw_vn }];    # gnd
#set_property -dict { PACKAGE_PIN J8    IOSTANDARD LVCMOS33 } [get_ports { hw_vrefp }]; # gnd
#set_property -dict { PACKAGE_PIN H7    IOSTANDARD LVCMOS33 } [get_ports { hw_vrefn }]; # gnd
