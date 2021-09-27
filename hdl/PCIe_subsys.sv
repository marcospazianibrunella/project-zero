module PCIe_subsys (
    input sys_clk,
    input sys_clk_gt,
    input sys_rst_n,

    output axi_aclk_250mhz_out,
    output axi_arstn_250mhz_out,

    /* PCIe XDMA GTY 227 */
    input  [3:0] pcie_4x_0_rx_p,
    input  [3:0] pcie_4x_0_rx_n,
    output [3:0] pcie_4x_0_tx_p,
    output [3:0] pcie_4x_0_tx_n
);

  logic          m_axib_awready = 0;
  logic          m_axib_wready = 0;
  logic [   3:0] m_axib_bid = 0;
  logic [   1:0] m_axib_bresp = 0;
  logic          m_axib_bvalid = 0;
  logic          m_axib_arready = 0;
  logic [   3:0] m_axib_rid = 0;
  logic [ 255:0] m_axib_rdata = 0;
  logic [   1:0] m_axib_rresp = 0;
  logic          m_axib_rlast = 0;
  logic          m_axib_rvalid = 0;

  logic [31 : 0] s_axil_awaddr = 0;
  logic [   2:0] s_axil_awprot = 0;
  logic          s_axil_awvalid = 0;
  logic [  31:0] s_axil_wdata = 0;
  logic [   3:0] s_axil_wstrb = 0;
  logic          s_axil_wvalid = 0;
  logic          s_axil_bready = 0;
  logic [  31:0] s_axil_araddr = 0;
  logic [   2:0] s_axil_arprot = 0;
  logic          s_axil_arvalid = 0;
  logic          s_axil_rready = 0;

  logic [   3:0] s_axib_awid = 0;
  logic [  31:0] s_axib_awaddr = 0;
  logic [   3:0] s_axib_awregion = 0;
  logic [   7:0] s_axib_awlen = 0;
  logic [   2:0] s_axib_awsize = 0;
  logic [   1:0] s_axib_awburst = 0;
  logic          s_axib_awvalid = 0;
  logic [ 255:0] s_axib_wdata = 0;
  logic [  31:0] s_axib_wstrb = 0;
  logic          s_axib_wlast = 0;
  logic          s_axib_wvalid = 0;
  logic          s_axib_bready = 0;
  logic [   3:0] s_axib_arid = 0;
  logic [  31:0] s_axib_araddr = 0;
  logic [   3:0] s_axib_arregion = 0;
  logic [   7:0] s_axib_arlen = 0;
  logic [   2:0] s_axib_arsize = 0;
  logic [   1:0] s_axib_arburst = 0;
  logic          s_axib_arvalid = 0;
  logic          s_axib_rready = 0;



  xdma_0 XDMA0_i (
      .sys_clk   (sys_clk),  // input wire sys_clk
      .sys_clk_gt(sys_clk_gt),  // input wire sys_clk_gt
      .sys_rst_n (sys_rst_n),  // input wire sys_rst_n

      .cfg_ltssm_state(),  // output wire [5 : 0] cfg_ltssm_state
      .user_lnk_up    (),  // output wire user_lnk_up

      .pci_exp_txp(pcie_4x_0_tx_p),  // output wire [3 : 0] pci_exp_txp
      .pci_exp_txn(pcie_4x_0_tx_n),  // output wire [3 : 0] pci_exp_txn
      .pci_exp_rxp(pcie_4x_0_rx_p),  // input wire [3 : 0] pci_exp_rxp
      .pci_exp_rxn(pcie_4x_0_rx_n),  // input wire [3 : 0] pci_exp_rxn

      .axi_aclk       (axi_aclk_250mhz_out),  // output wire axi_aclk
      .axi_aresetn    (axi_arstn_250mhz_out),  // output wire axi_aresetn
      .axi_ctl_aresetn(),  // output wire axi_ctl_aresetn

      .m_axib_awid   (m_axib_awid),  // output wire [3 : 0] m_axib_awid
      .m_axib_awaddr (m_axib_awaddr),  // output wire [31 : 0] m_axib_awaddr
      .m_axib_awlen  (m_axib_awlen),  // output wire [7 : 0] m_axib_awlen
      .m_axib_awsize (m_axib_awsize),  // output wire [2 : 0] m_axib_awsize
      .m_axib_awburst(m_axib_awburst),  // output wire [1 : 0] m_axib_awburst
      .m_axib_awprot (m_axib_awprot),  // output wire [2 : 0] m_axib_awprot
      .m_axib_awvalid(m_axib_awvalid),  // output wire m_axib_awvalid
      .m_axib_awready(m_axib_awready),  // input wire m_axib_awready
      .m_axib_awlock (m_axib_awlock),  // output wire m_axib_awlock
      .m_axib_awcache(m_axib_awcache),  // output wire [3 : 0] m_axib_awcache
      .m_axib_wdata  (m_axib_wdata),  // output wire [255 : 0] m_axib_wdata
      .m_axib_wstrb  (m_axib_wstrb),  // output wire [31 : 0] m_axib_wstrb
      .m_axib_wlast  (m_axib_wlast),  // output wire m_axib_wlast
      .m_axib_wvalid (m_axib_wvalid),  // output wire m_axib_wvalid
      .m_axib_wready (m_axib_wready),  // input wire m_axib_wready
      .m_axib_bid    (m_axib_bid),  // input wire [3 : 0] m_axib_bid
      .m_axib_bresp  (m_axib_bresp),  // input wire [1 : 0] m_axib_bresp
      .m_axib_bvalid (m_axib_bvalid),  // input wire m_axib_bvalid
      .m_axib_bready (m_axib_bready),  // output wire m_axib_bready
      .m_axib_arid   (m_axib_arid),  // output wire [3 : 0] m_axib_arid
      .m_axib_araddr (m_axib_araddr),  // output wire [31 : 0] m_axib_araddr
      .m_axib_arlen  (m_axib_arlen),  // output wire [7 : 0] m_axib_arlen
      .m_axib_arsize (m_axib_arsize),  // output wire [2 : 0] m_axib_arsize
      .m_axib_arburst(m_axib_arburst),  // output wire [1 : 0] m_axib_arburst
      .m_axib_arprot (m_axib_arprot),  // output wire [2 : 0] m_axib_arprot
      .m_axib_arvalid(m_axib_arvalid),  // output wire m_axib_arvalid
      .m_axib_arready(m_axib_arready),  // input wire m_axib_arready
      .m_axib_arlock (m_axib_arlock),  // output wire m_axib_arlock
      .m_axib_arcache(m_axib_arcache),  // output wire [3 : 0] m_axib_arcache
      .m_axib_rid    (m_axib_rid),  // input wire [3 : 0] m_axib_rid
      .m_axib_rdata  (m_axib_rdata),  // input wire [255 : 0] m_axib_rdata
      .m_axib_rresp  (m_axib_rresp),  // input wire [1 : 0] m_axib_rresp
      .m_axib_rlast  (m_axib_rlast),  // input wire m_axib_rlast
      .m_axib_rvalid (m_axib_rvalid),  // input wire m_axib_rvalid
      .m_axib_rready (m_axib_rready),  // output wire m_axib_rready

      .s_axil_awaddr (s_axil_awaddr),  // input wire [31 : 0] s_axil_awaddr
      .s_axil_awprot (s_axil_awprot),  // input wire [2 : 0] s_axil_awprot
      .s_axil_awvalid(s_axil_awvalid),  // input wire s_axil_awvalid
      .s_axil_awready(s_axil_awready),  // output wire s_axil_awready
      .s_axil_wdata  (s_axil_wdata),  // input wire [31 : 0] s_axil_wdata
      .s_axil_wstrb  (s_axil_wstrb),  // input wire [3 : 0] s_axil_wstrb
      .s_axil_wvalid (s_axil_wvalid),  // input wire s_axil_wvalid
      .s_axil_wready (s_axil_wready),  // output wire s_axil_wready
      .s_axil_bvalid (s_axil_bvalid),  // output wire s_axil_bvalid
      .s_axil_bresp  (s_axil_bresp),  // output wire [1 : 0] s_axil_bresp
      .s_axil_bready (s_axil_bready),  // input wire s_axil_bready
      .s_axil_araddr (s_axil_araddr),  // input wire [31 : 0] s_axil_araddr
      .s_axil_arprot (s_axil_arprot),  // input wire [2 : 0] s_axil_arprot
      .s_axil_arvalid(s_axil_arvalid),  // input wire s_axil_arvalid
      .s_axil_arready(s_axil_arready),  // output wire s_axil_arready
      .s_axil_rdata  (s_axil_rdata),  // output wire [31 : 0] s_axil_rdata
      .s_axil_rresp  (s_axil_rresp),  // output wire [1 : 0] s_axil_rresp
      .s_axil_rvalid (s_axil_rvalid),  // output wire s_axil_rvalid
      .s_axil_rready (s_axil_rready),  // input wire s_axil_rready
      .interrupt_out (interrupt_out),  // output wire interrupt_out

      .s_axib_awid    (s_axib_awid),  // input wire [3 : 0] s_axib_awid
      .s_axib_awaddr  (s_axib_awaddr),  // input wire [31 : 0] s_axib_awaddr
      .s_axib_awregion(s_axib_awregion),  // input wire [3 : 0] s_axib_awregion
      .s_axib_awlen   (s_axib_awlen),  // input wire [7 : 0] s_axib_awlen
      .s_axib_awsize  (s_axib_awsize),  // input wire [2 : 0] s_axib_awsize
      .s_axib_awburst (s_axib_awburst),  // input wire [1 : 0] s_axib_awburst
      .s_axib_awvalid (s_axib_awvalid),  // input wire s_axib_awvalid
      .s_axib_wdata   (s_axib_wdata),  // input wire [255 : 0] s_axib_wdata
      .s_axib_wstrb   (s_axib_wstrb),  // input wire [31 : 0] s_axib_wstrb
      .s_axib_wlast   (s_axib_wlast),  // input wire s_axib_wlast
      .s_axib_wvalid  (s_axib_wvalid),  // input wire s_axib_wvalid
      .s_axib_bready  (s_axib_bready),  // input wire s_axib_bready
      .s_axib_arid    (s_axib_arid),  // input wire [3 : 0] s_axib_arid
      .s_axib_araddr  (s_axib_araddr),  // input wire [31 : 0] s_axib_araddr
      .s_axib_arregion(s_axib_arregion),  // input wire [3 : 0] s_axib_arregion
      .s_axib_arlen   (s_axib_arlen),  // input wire [7 : 0] s_axib_arlen
      .s_axib_arsize  (s_axib_arsize),  // input wire [2 : 0] s_axib_arsize
      .s_axib_arburst (s_axib_arburst),  // input wire [1 : 0] s_axib_arburst
      .s_axib_arvalid (s_axib_arvalid),  // input wire s_axib_arvalid
      .s_axib_rready  (s_axib_rready),  // input wire s_axib_rready
      .s_axib_awready (s_axib_awready),  // output wire s_axib_awready
      .s_axib_wready  (s_axib_wready),  // output wire s_axib_wready
      .s_axib_bid     (s_axib_bid),  // output wire [3 : 0] s_axib_bid
      .s_axib_bresp   (s_axib_bresp),  // output wire [1 : 0] s_axib_bresp
      .s_axib_bvalid  (s_axib_bvalid),  // output wire s_axib_bvalid
      .s_axib_arready (s_axib_arready),  // output wire s_axib_arready
      .s_axib_rid     (s_axib_rid),  // output wire [3 : 0] s_axib_rid
      .s_axib_rdata   (s_axib_rdata),  // output wire [255 : 0] s_axib_rdata
      .s_axib_rresp   (s_axib_rresp),  // output wire [1 : 0] s_axib_rresp
      .s_axib_rlast   (s_axib_rlast),  // output wire s_axib_rlast
      .s_axib_rvalid  (s_axib_rvalid)  // output wire s_axib_rvalid
  );

endmodule
