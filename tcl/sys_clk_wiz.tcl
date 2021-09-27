##################################################################
# CREATE IP sys_clk_wiz
##################################################################

set sys_clk_wiz [create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name sys_clk_wiz]

set_property -dict { 
  CONFIG.PRIMITIVE {MMCM}
  CONFIG.PRIM_SOURCE {Differential_clock_capable_pin}
  CONFIG.CLKOUT1_DRIVES {Buffer}
  CONFIG.CLKOUT2_DRIVES {Buffer}
  CONFIG.CLKOUT3_DRIVES {Buffer}
  CONFIG.CLKOUT4_DRIVES {Buffer}
  CONFIG.CLKOUT5_DRIVES {Buffer}
  CONFIG.CLKOUT6_DRIVES {Buffer}
  CONFIG.CLKOUT7_DRIVES {Buffer}
  CONFIG.FEEDBACK_SOURCE {FDBK_AUTO}
  CONFIG.USE_LOCKED {true}
  CONFIG.USE_RESET {true}
  CONFIG.MMCM_BANDWIDTH {OPTIMIZED}
  CONFIG.MMCM_CLKFBOUT_MULT_F {12.000}
  CONFIG.MMCM_COMPENSATION {AUTO}
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {12.000}
  CONFIG.AUTO_PRIMITIVE {MMCM}
  CONFIG.CLKOUT1_JITTER {115.831}
  CONFIG.CLKOUT1_PHASE_ERROR {87.180}
} [get_ips sys_clk_wiz]

set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $sys_clk_wiz

##################################################################

