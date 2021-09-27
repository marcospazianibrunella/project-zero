`timescale 1ns / 1ps

`include "fpga.svh"

module fpga (

    input  sys_rstn,
    output hbm_cattrip,

    /* PCIe */
    input pcie_refclk1_p,
    input pcie_refclk1_n,
    input pcie_rst_n,

    /* PCIe XDMA GTY 227 */
    input  [3:0] pcie_4x_0_rx_p,
    input  [3:0] pcie_4x_0_rx_n,
    output [3:0] pcie_4x_0_tx_p,
    output [3:0] pcie_4x_0_tx_n,

    /* Ethernet */
    /* CMAC QSFP0 */
    input  [3:0] qsfp0_rx_p,
    input  [3:0] qsfp0_rx_n,
    output [3:0] qsfp0_tx_p,
    output [3:0] qsfp0_tx_n,
    input        qsfp0_mgt_refclk_1_p,
    input        qsfp0_mgt_refclk_1_n,
    output       qsfp0_refclk_oe_b,
    output       qsfp0_refclk_fs,

    /* CMAC QSFP1 */
    input  [3:0] qsfp1_rx_p,
    input  [3:0] qsfp1_rx_n,
    output [3:0] qsfp1_tx_p,
    output [3:0] qsfp1_tx_n,
    input        qsfp1_mgt_refclk_1_p,
    input        qsfp1_mgt_refclk_1_n,
    output       qsfp1_refclk_oe_b,
    output       qsfp1_refclk_fs

);
  assign hbm_cattrip = 1'b0; /* To avoid powerdown of the board due to HBM Overtemperature signal wrong interpretation */

  /* Systems Clocks and Resets */
  logic clk_161mhz_ref_i;

  logic clk_50mhz_i, rst_50mhz_i;
  logic clk_125mhz_i, rst_125mhz_i;

  /* QSFPs */

  assign qsfp0_refclk_oe_b = 1'b0;
  assign qsfp0_refclk_fs   = 1'b1;
  assign qsfp1_refclk_oe_b = 1'b0;
  assign qsfp1_refclk_fs   = 1'b1;
  /*- FS   <-- Clock Select Pin FS = 1 -> 161.132812 MHz 1.8V LVDS (default when FPGA pin Hi-Z or driven High)
                                FS = 0 -> 156.25 MHz 1.8V LVDS when driven low by FPGA
                                    */

  logic [`AXIS_ETH_DATA_WIDTH-1:0] s_qsfp0_axis_tdata;  // To QSFP0
  logic [`AXIS_ETH_KEEP_WIDTH-1:0] s_qsfp0_axis_tkeep;
  logic                            s_qsfp0_axis_tvalid;
  logic                            s_qsfp0_axis_tready;
  logic                            s_qsfp0_axis_tlast;
  logic [                16+1-1:0] s_qsfp0_axis_tuser;

  logic [`AXIS_ETH_DATA_WIDTH-1:0] m_qsfp0_axis_tdata;  // From QSFP0 
  logic [`AXIS_ETH_KEEP_WIDTH-1:0] m_qsfp0_axis_tkeep;
  logic                            m_qsfp0_axis_tvalid;
  logic                            m_qsfp0_axis_tready;
  logic                            m_qsfp0_axis_tlast;
  logic [                16+1-1:0] m_qsfp0_axis_tuser;

  logic [`AXIS_ETH_DATA_WIDTH-1:0] s_qsfp1_axis_tdata;  // To QSFP1
  logic [`AXIS_ETH_KEEP_WIDTH-1:0] s_qsfp1_axis_tkeep;
  logic                            s_qsfp1_axis_tvalid;
  logic                            s_qsfp1_axis_tready;
  logic                            s_qsfp1_axis_tlast;
  logic [                16+1-1:0] s_qsfp1_axis_tuser;

  logic [`AXIS_ETH_DATA_WIDTH-1:0] m_qsfp1_axis_tdata;  // From QSFP1 
  logic [`AXIS_ETH_KEEP_WIDTH-1:0] m_qsfp1_axis_tkeep;
  logic                            m_qsfp1_axis_tvalid;
  logic                            m_qsfp1_axis_tready;
  logic                            m_qsfp1_axis_tlast;
  logic [                16+1-1:0] m_qsfp1_axis_tuser;

  /* Begin of Modules Instantiations */

  sys_clk_rst SYS_CLK_RST_i (
      .clk_161mhz_in(clk_161mhz_ref_i),
      .sys_rst_in   (~sys_resetn),

      .pcie_refclk1_p (pcie_refclk1_p),
      .pcie_refclk1_n (pcie_refclk1_n),
      .pcie_sys_clk   (pcie_sys_clk),
      .pcie_sys_clk_gt(pcie_sys_clk_gt),

      .clk_50mhz_out (clk_50mhz_i),
      .rst_50mhz_out (rst_50mhz_i),
      .clk_125mhz_out(clk_125mhz_i),
      .rst_125mhz_out(rst_125mhz_i)
  );

  ethernet_subsys ETHERNET_SUBSYS_i (
      .clk_125mhz_in(clk_125mhz_i),
      .rst_125mhz_in(rst_125mhz_i),

      .qsfp0_161mhz_refclk_in_p(qsfp0_mgt_refclk_1_p),
      .qsfp0_161mhz_refclk_in_n(qsfp0_mgt_refclk_1_n),
      .qsfp0_gt_rx_p           (qsfp0_rx_p),
      .qsfp0_gt_rx_n           (qsfp0_rx_n),
      .qsfp0_gt_tx_p           (qsfp0_tx_p),
      .qsfp0_gt_tx_n           (qsfp0_tx_n),

      .qsfp1_161mhz_refclk_in_p(qsfp1_mgt_refclk_1_p),
      .qsfp1_161mhz_refclk_in_n(qsfp1_mgt_refclk_1_n),
      .qsfp1_gt_rx_p           (qsfp1_rx_p),
      .qsfp1_gt_rx_n           (qsfp1_rx_n),
      .qsfp1_gt_tx_p           (qsfp1_tx_p),
      .qsfp1_gt_tx_n           (qsfp1_tx_n),

      .clk_161mhz_out(clk_161mhz_ref_i),  // Master Clock for the entire FPGA

      .s_qsfp0_axis_tdata (s_qsfp0_axis_tdata),  // To QSFP0
      .s_qsfp0_axis_tkeep (s_qsfp0_axis_tkeep),
      .s_qsfp0_axis_tvalid(s_qsfp0_axis_tvalid),
      .s_qsfp0_axis_tready(s_qsfp0_axis_tready),
      .s_qsfp0_axis_tlast (s_qsfp0_axis_tlast),
      .s_qsfp0_axis_tuser (s_qsfp0_axis_tuser),

      .m_qsfp0_axis_tdata (m_qsfp0_axis_tdata),  // From QSFP0 
      .m_qsfp0_axis_tkeep (m_qsfp0_axis_tkeep),
      .m_qsfp0_axis_tvalid(m_qsfp0_axis_tvalid),
      .m_qsfp0_axis_tready(m_qsfp0_axis_tready),
      .m_qsfp0_axis_tlast (m_qsfp0_axis_tlast),
      .m_qsfp0_axis_tuser (m_qsfp0_axis_tuser),

      .s_qsfp1_axis_tdata (s_qsfp1_axis_tdata),  // To QSFP1
      .s_qsfp1_axis_tkeep (s_qsfp1_axis_tkeep),
      .s_qsfp1_axis_tvalid(s_qsfp1_axis_tvalid),
      .s_qsfp1_axis_tready(s_qsfp1_axis_tready),
      .s_qsfp1_axis_tlast (s_qsfp1_axis_tlast),
      .s_qsfp1_axis_tuser (s_qsfp1_axis_tuser),

      .m_qsfp1_axis_tdata (m_qsfp1_axis_tdata),  // From QSFP1 
      .m_qsfp1_axis_tkeep (m_qsfp1_axis_tkeep),
      .m_qsfp1_axis_tvalid(m_qsfp1_axis_tvalid),
      .m_qsfp1_axis_tready(m_qsfp1_axis_tready),
      .m_qsfp1_axis_tlast (m_qsfp1_axis_tlast),
      .m_qsfp1_axis_tuser (m_qsfp1_axis_tuser)

  );

  PCIe_subsys PCIe_SUBSYS_i (
      .sys_clk   (pcie_sys_clk),
      .sys_clk_gt(pcie_sys_clk_gt),
      .sys_rst_n (pcie_rst_n),

      .pcie_4x_0_rx_p(pcie_4x_0_rx_p),
      .pcie_4x_0_rx_n(pcie_4x_0_rx_n),
      .pcie_4x_0_tx_p(pcie_4x_0_tx_p),
      .pcie_4x_0_tx_n(pcie_4x_0_tx_n)
  );

  /* Loopback on QSFPs */
  assign s_qsfp0_axis_tdata  = m_qsfp0_axis_tdata;
  assign s_qsfp0_axis_tkeep  = m_qsfp0_axis_tkeep;
  assign s_qsfp0_axis_tlast  = m_qsfp0_axis_tlast;
  assign s_qsfp0_axis_tuser  = m_qsfp0_axis_tuser;
  assign s_qsfp0_axis_tvalid = m_qsfp0_axis_tvalid;

  assign s_qsfp1_axis_tdata  = m_qsfp1_axis_tdata;
  assign s_qsfp1_axis_tkeep  = m_qsfp1_axis_tkeep;
  assign s_qsfp1_axis_tlast  = m_qsfp1_axis_tlast;
  assign s_qsfp1_axis_tuser  = m_qsfp1_axis_tuser;
  assign s_qsfp1_axis_tvalid = m_qsfp1_axis_tvalid;



endmodule
