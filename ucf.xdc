set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK }]; #IO_L12P_T1_MRCC_35 Sch=gclk[100]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK }];
set_property SEVERITY {Warning} [ get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [ get_drc_checks UCIO-1]

#button
set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS33 } [get_ports { BUTTON }]; #IO_L12N_T1_MRCC_16 Sch=sw[0]

#reset
set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 } [get_ports { RESET }]; #IO_L6N_T0_VREF_16 Sch=btn[0]

## LEDs
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { LED[0] }]; #IO_L24N_T3_35 Sch=led[4]
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { LED[1] }]; #IO_25_35 Sch=led[5]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { LED[2] }]; #IO_L24P_T3_A01_D17_14 Sch=led[6]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { LED[3] }]; #IO_L24N_T3_A00_D16_14 Sch=led[7]

## Pmod Header JA
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { TXD }]; #IO_0_15 Sch=ja[1]

set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS33 } [get_ports { VGA_OUT_RED[0]    }]; #IO_L11P_T1_SRCC_15 Sch=jb_p[1]
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { VGA_OUT_BLUE[0]   }]; #IO_L23P_T3_FOE_B_15 Sch=jb_p[3]
 # PMOD JC
 
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports {VGA_OUT_GREEN[0] }]; #IO_L20P_T3_A08_D24_14 Sch=jc_p[1]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { HSYNC }]; #IO_L22P_T3_A05_D21_14 Sch=jc_p[3] 
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { VSYNC }]; #IO_L22N_T3_A04_D20_14 Sch=jc_n[3]
