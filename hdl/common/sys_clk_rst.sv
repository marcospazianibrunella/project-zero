module sys_clk_rst (
    input clk_161mhz_in,
    input sys_rst_in,

    input  pcie_refclk1_p,
    input  pcie_refclk1_n,
    output pcie_sys_clk,
    output pcie_sys_clk_gt,

    output clk_50mhz_out,
    output rst_50mhz_out,
    output clk_125mhz_out,
    output rst_125mhz_out
);

  logic clk_50mhz_mmcm_out;
  logic clk_125mhz_mmcm_out;
  logic clk_250mhz_mmcm_out;

  logic clk_50mhz_i;
  logic clk_125mhz_i;

  /* Not Needed at the moment! */
  logic clk_250mhz_i;
  logic rst_250mhz_i;

  logic mmcm_locked;
  logic mmcm_clkfb;

  /* Clock Generation */

  /* MMCM instance
  161.13 MHz in, 50 MHz + 125 MHz + 250MHz out
  PFD range: 10 MHz to 500 MHz
  VCO range: 800 MHz to 1600 MHz
  M = 128, D = 15 sets Fvco = 1375 MHz (in range)
  Divide by 27.5 to get output frequency of 50 MHz
  Divide by 11 to get output frequency of 125 MHz
  Divide by 5.5 to get output frequency of 250 MHz
*/
  MMCME4_BASE #(
      .BANDWIDTH("OPTIMIZED"),
      .CLKOUT0_DIVIDE_F(27.5),
      .CLKOUT0_DUTY_CYCLE(0.5),
      .CLKOUT0_PHASE(0),
      .CLKOUT1_DIVIDE(11),
      .CLKOUT1_DUTY_CYCLE(0.5),
      .CLKOUT1_PHASE(0),
      .CLKOUT2_DIVIDE(5.5),
      .CLKOUT2_DUTY_CYCLE(0.5),
      .CLKOUT2_PHASE(0),
      .CLKOUT3_DIVIDE(1),
      .CLKOUT3_DUTY_CYCLE(0.5),
      .CLKOUT3_PHASE(0),
      .CLKOUT4_DIVIDE(1),
      .CLKOUT4_DUTY_CYCLE(0.5),
      .CLKOUT4_PHASE(0),
      .CLKOUT5_DIVIDE(1),
      .CLKOUT5_DUTY_CYCLE(0.5),
      .CLKOUT5_PHASE(0),
      .CLKOUT6_DIVIDE(1),
      .CLKOUT6_DUTY_CYCLE(0.5),
      .CLKOUT6_PHASE(0),
      .CLKFBOUT_MULT_F(128),
      .CLKFBOUT_PHASE(0),
      .DIVCLK_DIVIDE(15),
      .REF_JITTER1(0.010),
      .CLKIN1_PERIOD(6.206),
      .STARTUP_WAIT("FALSE"),
      .CLKOUT4_CASCADE("FALSE")
  ) clk_mmcm_inst (
      .CLKIN1(clk_161mhz_in),
      .CLKFBIN(mmcm_clkfb),
      .RST(sys_reset),
      .PWRDWN(1'b0),
      .CLKOUT0(clk_50mhz_mmcm_out),
      .CLKOUT0B(),
      .CLKOUT1(clk_125mhz_mmcm_out),
      .CLKOUT1B(),
      .CLKOUT2(clk_250mhz_mmcm_out),
      .CLKOUT2B(),
      .CLKOUT3(),
      .CLKOUT3B(),
      .CLKOUT4(),
      .CLKOUT5(),
      .CLKOUT6(),
      .CLKFBOUT(mmcm_clkfb),
      .CLKFBOUTB(),
      .LOCKED(mmcm_locked)
  );

  IBUFDS_GTE4 #(
      .REFCLK_HROW_CK_SEL(2'b00)
  ) ibufds_gte4_pcie_mgt_refclk_inst (
      .I    (pcie_refclk_1_p),
      .IB   (pcie_refclk_1_n),
      .CEB  (1'b0),
      .O    (pcie_sys_clk_gt),
      .ODIV2(pcie_sys_clk)
  );

  /* Buffer Clocks */
  BUFG clk_50mhz_bufg_inst (
      .I(clk_50mhz_mmcm_out),
      .O(clk_50mhz_i)
  );

  BUFG clk_125mhz_bufg_inst (
      .I(clk_125mhz_mmcm_out),
      .O(clk_125mhz_i)
  );

  BUFG clk_250mhz_bufg_inst (
      .I(clk_250mhz_mmcm_out),
      .O(clk_250mhz_i)
  );

  sync_reset #(
      .N(4)
  ) sync_reset_50mhz_inst (
      .clk(clk_50mhz_i),
      .rst(~mmcm_locked),
      .out(rst_50mhz_out)
  );

  sync_reset #(
      .N(4)
  ) sync_reset_125mhz_inst (
      .clk(clk_125mhz_i),
      .rst(~mmcm_locked),
      .out(rst_125mhz_out)
  );

  sync_reset #(
      .N(4)
  ) sync_reset_250mhz_inst (
      .clk(clk_250mhz_i),
      .rst(~mmcm_locked),
      .out(rst_250mhz_i)
  );

  assign clk_50mhz_out  = clk_50mhz_i;
  assign clk_125mhz_out = clk_125mhz_i;

endmodule
