`include "fpga.svh"

module ethernet_subsys (

    /* Clocks and Reset */
    input clk_125mhz_in,
    input rst_125mhz_in,

    /* Physical Connecitons */
    input        qsfp0_161mhz_refclk_in_p,
    input        qsfp0_161mhz_refclk_in_n,
    input  [3:0] qsfp0_gt_rx_p,
    input  [3:0] qsfp0_gt_rx_n,
    output [3:0] qsfp0_gt_tx_p,
    output [3:0] qsfp0_gt_tx_n,

    input        qsfp1_161mhz_refclk_in_p,
    input        qsfp1_161mhz_refclk_in_n,
    input  [3:0] qsfp1_gt_rx_p,
    input  [3:0] qsfp1_gt_rx_n,
    output [3:0] qsfp1_gt_tx_p,
    output [3:0] qsfp1_gt_tx_n,

    /* Reference Clocking Out */
    output clk_161mhz_out,

    /* AXI-Stream Datapath */

    input [`AXIS_ETH_DATA_WIDTH-1:0] s_qsfp0_axis_tdata,   // To QSFP0
    input [`AXIS_ETH_KEEP_WIDTH-1:0] s_qsfp0_axis_tkeep,
    input                            s_qsfp0_axis_tvalid,
    input                            s_qsfp0_axis_tready,
    input                            s_qsfp0_axis_tlast,
    input [                16+1-1:0] s_qsfp0_axis_tuser,

    output [`AXIS_ETH_DATA_WIDTH-1:0] m_qsfp0_axis_tdata,   // From QSFP0 
    output [`AXIS_ETH_KEEP_WIDTH-1:0] m_qsfp0_axis_tkeep,
    output                            m_qsfp0_axis_tvalid,
    output                            m_qsfp0_axis_tready,
    output                            m_qsfp0_axis_tlast,
    output [                16+1-1:0] m_qsfp0_axis_tuser,

    input [`AXIS_ETH_DATA_WIDTH-1:0] s_qsfp1_axis_tdata,   // To QSFP1
    input [`AXIS_ETH_KEEP_WIDTH-1:0] s_qsfp1_axis_tkeep,
    input                            s_qsfp1_axis_tvalid,
    input                            s_qsfp1_axis_tready,
    input                            s_qsfp1_axis_tlast,
    input [                16+1-1:0] s_qsfp1_axis_tuser,

    output [`AXIS_ETH_DATA_WIDTH-1:0] m_qsfp1_axis_tdata,   // From QSFP1 
    output [`AXIS_ETH_KEEP_WIDTH-1:0] m_qsfp1_axis_tkeep,
    output                            m_qsfp1_axis_tvalid,
    output                            m_qsfp1_axis_tready,
    output                            m_qsfp1_axis_tlast,
    output [                16+1-1:0] m_qsfp1_axis_tuser
);

  logic qsfp0_tx_clk_int;
  logic qsfp0_tx_rst_int;
  logic qsfp0_rx_clk_int;
  logic qsfp0_rx_rst_int;
  logic qsfp0_rx_status;
  logic qsfp1_rx_status;
  logic qsfp0_txuserclk2;

  logic qsfp1_tx_clk_int;
  logic qsfp1_tx_rst_int;
  logic qsfp1_rx_clk_int;
  logic qsfp1_rx_rst_int;
  logic qsfp1_rx_status;
  logic qsfp1_rx_status;
  logic qsfp1_txuserclk2;

  assign qsfp0_tx_clk_int = qsfp0_txuserclk2;
  assign qsfp0_rx_clk_int = qsfp0_txuserclk2;

  assign qsfp1_tx_clk_int = qsfp1_txuserclk2;
  assign qsfp1_rx_clk_int = qsfp1_txuserclk2;


  cmac_usplus_0 qsfp0_cmac_inst (
      .gt_rxp_in              (qsfp0_gt_rx_p),  // input
      .gt_rxn_in              (qsfp0_gt_rx_n),  // input
      .gt_txp_out             (qsfp0_gt_tx_p),  // output
      .gt_txn_out             (qsfp0_gt_tx_n),  // output
      .gt_txusrclk2           (qsfp0_txuserclk2),  // output
      .gt_loopback_in         (12'd0),  // input [11:0]
      .gt_rxrecclkout         (),  // output [3:0]
      .gt_powergoodout        (),  // output [3:0]
      .gt_ref_clk_out         (clk_161mhz_out),  // output
      .gtwiz_reset_tx_datapath(1'b0),  // input
      .gtwiz_reset_rx_datapath(1'b0),  // input
      .sys_reset              (rst_125mhz_in),  // input
      .gt_ref_clk_p           (qsfp0_161mhz_refclk_in_p),  // input
      .gt_ref_clk_n           (qsfp0_161mhz_refclk_in_n),  // input
      .init_clk               (clk_125mhz_in),  // input

      .rx_axis_tvalid(m_qsfp0_axis_tvalid),  // output
      .rx_axis_tdata (m_qsfp0_axis_tdata),  // output [511:0]
      .rx_axis_tlast (m_qsfp0_axis_tlast),  // output
      .rx_axis_tkeep (m_qsfp0_axis_tkeep),  // output [63:0]
      .rx_axis_tuser (m_qsfp0_axis_tuser[0]),  // output

      .rx_otn_bip8_0  (),  // output [7:0]
      .rx_otn_bip8_1  (),  // output [7:0]
      .rx_otn_bip8_2  (),  // output [7:0]
      .rx_otn_bip8_3  (),  // output [7:0]
      .rx_otn_bip8_4  (),  // output [7:0]
      .rx_otn_data_0  (),  // output [65:0]
      .rx_otn_data_1  (),  // output [65:0]
      .rx_otn_data_2  (),  // output [65:0]
      .rx_otn_data_3  (),  // output [65:0]
      .rx_otn_data_4  (),  // output [65:0]
      .rx_otn_ena     (),  // output
      .rx_otn_lane0   (),  // output
      .rx_otn_vlmarker(),  // output
      .rx_preambleout (),  // output [55:0]
      .usr_rx_reset   (qsfp0_rx_rst_int),  // output
      .gt_rxusrclk2   (),  // output

      .stat_rx_aligned               (),  // output
      .stat_rx_aligned_err           (),  // output
      .stat_rx_bad_code              (),  // output [2:0]
      .stat_rx_bad_fcs               (),  // output [2:0]
      .stat_rx_bad_preamble          (),  // output
      .stat_rx_bad_sfd               (),  // output
      .stat_rx_bip_err_0             (),  // output
      .stat_rx_bip_err_1             (),  // output
      .stat_rx_bip_err_10            (),  // output
      .stat_rx_bip_err_11            (),  // output
      .stat_rx_bip_err_12            (),  // output
      .stat_rx_bip_err_13            (),  // output
      .stat_rx_bip_err_14            (),  // output
      .stat_rx_bip_err_15            (),  // output
      .stat_rx_bip_err_16            (),  // output
      .stat_rx_bip_err_17            (),  // output
      .stat_rx_bip_err_18            (),  // output
      .stat_rx_bip_err_19            (),  // output
      .stat_rx_bip_err_2             (),  // output
      .stat_rx_bip_err_3             (),  // output
      .stat_rx_bip_err_4             (),  // output
      .stat_rx_bip_err_5             (),  // output
      .stat_rx_bip_err_6             (),  // output
      .stat_rx_bip_err_7             (),  // output
      .stat_rx_bip_err_8             (),  // output
      .stat_rx_bip_err_9             (),  // output
      .stat_rx_block_lock            (),  // output [19:0]
      .stat_rx_broadcast             (),  // output
      .stat_rx_fragment              (),  // output [2:0]
      .stat_rx_framing_err_0         (),  // output [1:0]
      .stat_rx_framing_err_1         (),  // output [1:0]
      .stat_rx_framing_err_10        (),  // output [1:0]
      .stat_rx_framing_err_11        (),  // output [1:0]
      .stat_rx_framing_err_12        (),  // output [1:0]
      .stat_rx_framing_err_13        (),  // output [1:0]
      .stat_rx_framing_err_14        (),  // output [1:0]
      .stat_rx_framing_err_15        (),  // output [1:0]
      .stat_rx_framing_err_16        (),  // output [1:0]
      .stat_rx_framing_err_17        (),  // output [1:0]
      .stat_rx_framing_err_18        (),  // output [1:0]
      .stat_rx_framing_err_19        (),  // output [1:0]
      .stat_rx_framing_err_2         (),  // output [1:0]
      .stat_rx_framing_err_3         (),  // output [1:0]
      .stat_rx_framing_err_4         (),  // output [1:0]
      .stat_rx_framing_err_5         (),  // output [1:0]
      .stat_rx_framing_err_6         (),  // output [1:0]
      .stat_rx_framing_err_7         (),  // output [1:0]
      .stat_rx_framing_err_8         (),  // output [1:0]
      .stat_rx_framing_err_9         (),  // output [1:0]
      .stat_rx_framing_err_valid_0   (),  // output
      .stat_rx_framing_err_valid_1   (),  // output
      .stat_rx_framing_err_valid_10  (),  // output
      .stat_rx_framing_err_valid_11  (),  // output
      .stat_rx_framing_err_valid_12  (),  // output
      .stat_rx_framing_err_valid_13  (),  // output
      .stat_rx_framing_err_valid_14  (),  // output
      .stat_rx_framing_err_valid_15  (),  // output
      .stat_rx_framing_err_valid_16  (),  // output
      .stat_rx_framing_err_valid_17  (),  // output
      .stat_rx_framing_err_valid_18  (),  // output
      .stat_rx_framing_err_valid_19  (),  // output
      .stat_rx_framing_err_valid_2   (),  // output
      .stat_rx_framing_err_valid_3   (),  // output
      .stat_rx_framing_err_valid_4   (),  // output
      .stat_rx_framing_err_valid_5   (),  // output
      .stat_rx_framing_err_valid_6   (),  // output
      .stat_rx_framing_err_valid_7   (),  // output
      .stat_rx_framing_err_valid_8   (),  // output
      .stat_rx_framing_err_valid_9   (),  // output
      .stat_rx_got_signal_os         (),  // output
      .stat_rx_hi_ber                (),  // output
      .stat_rx_inrangeerr            (),  // output
      .stat_rx_internal_local_fault  (),  // output
      .stat_rx_jabber                (),  // output
      .stat_rx_local_fault           (),  // output
      .stat_rx_mf_err                (),  // output [19:0]
      .stat_rx_mf_len_err            (),  // output [19:0]
      .stat_rx_mf_repeat_err         (),  // output [19:0]
      .stat_rx_misaligned            (),  // output
      .stat_rx_multicast             (),  // output
      .stat_rx_oversize              (),  // output
      .stat_rx_packet_1024_1518_bytes(),  // output
      .stat_rx_packet_128_255_bytes  (),  // output
      .stat_rx_packet_1519_1522_bytes(),  // output
      .stat_rx_packet_1523_1548_bytes(),  // output
      .stat_rx_packet_1549_2047_bytes(),  // output
      .stat_rx_packet_2048_4095_bytes(),  // output
      .stat_rx_packet_256_511_bytes  (),  // output
      .stat_rx_packet_4096_8191_bytes(),  // output
      .stat_rx_packet_512_1023_bytes (),  // output
      .stat_rx_packet_64_bytes       (),  // output
      .stat_rx_packet_65_127_bytes   (),  // output
      .stat_rx_packet_8192_9215_bytes(),  // output
      .stat_rx_packet_bad_fcs        (),  // output
      .stat_rx_packet_large          (),  // output
      .stat_rx_packet_small          (),  // output [2:0]

      .ctl_rx_enable      (1'b1),  // input
      .ctl_rx_force_resync(1'b0),  // input
      .ctl_rx_test_pattern(1'b0),  // input
      .core_rx_reset      (1'b0),  // input
      .rx_clk             (qsfp0_rx_clk_int),  // input

      .stat_rx_received_local_fault (),  // output
      .stat_rx_remote_fault         (),  // output
      .stat_rx_status               (qsfp0_rx_status),  // output
      .stat_rx_stomped_fcs          (),  // output [2:0]
      .stat_rx_synced               (),  // output [19:0]
      .stat_rx_synced_err           (),  // output [19:0]
      .stat_rx_test_pattern_mismatch(),  // output [2:0]
      .stat_rx_toolong              (),  // output
      .stat_rx_total_bytes          (),  // output [6:0]
      .stat_rx_total_good_bytes     (),  // output [13:0]
      .stat_rx_total_good_packets   (),  // output
      .stat_rx_total_packets        (),  // output [2:0]
      .stat_rx_truncated            (),  // output
      .stat_rx_undersize            (),  // output [2:0]
      .stat_rx_unicast              (),  // output
      .stat_rx_vlan                 (),  // output
      .stat_rx_pcsl_demuxed         (),  // output [19:0]
      .stat_rx_pcsl_number_0        (),  // output [4:0]
      .stat_rx_pcsl_number_1        (),  // output [4:0]
      .stat_rx_pcsl_number_10       (),  // output [4:0]
      .stat_rx_pcsl_number_11       (),  // output [4:0]
      .stat_rx_pcsl_number_12       (),  // output [4:0]
      .stat_rx_pcsl_number_13       (),  // output [4:0]
      .stat_rx_pcsl_number_14       (),  // output [4:0]
      .stat_rx_pcsl_number_15       (),  // output [4:0]
      .stat_rx_pcsl_number_16       (),  // output [4:0]
      .stat_rx_pcsl_number_17       (),  // output [4:0]
      .stat_rx_pcsl_number_18       (),  // output [4:0]
      .stat_rx_pcsl_number_19       (),  // output [4:0]
      .stat_rx_pcsl_number_2        (),  // output [4:0]
      .stat_rx_pcsl_number_3        (),  // output [4:0]
      .stat_rx_pcsl_number_4        (),  // output [4:0]
      .stat_rx_pcsl_number_5        (),  // output [4:0]
      .stat_rx_pcsl_number_6        (),  // output [4:0]
      .stat_rx_pcsl_number_7        (),  // output [4:0]
      .stat_rx_pcsl_number_8        (),  // output [4:0]
      .stat_rx_pcsl_number_9        (),  // output [4:0]

      .stat_tx_bad_fcs               (),  // output
      .stat_tx_broadcast             (),  // output
      .stat_tx_frame_error           (),  // output
      .stat_tx_local_fault           (),  // output
      .stat_tx_multicast             (),  // output
      .stat_tx_packet_1024_1518_bytes(),  // output
      .stat_tx_packet_128_255_bytes  (),  // output
      .stat_tx_packet_1519_1522_bytes(),  // output
      .stat_tx_packet_1523_1548_bytes(),  // output
      .stat_tx_packet_1549_2047_bytes(),  // output
      .stat_tx_packet_2048_4095_bytes(),  // output
      .stat_tx_packet_256_511_bytes  (),  // output
      .stat_tx_packet_4096_8191_bytes(),  // output
      .stat_tx_packet_512_1023_bytes (),  // output
      .stat_tx_packet_64_bytes       (),  // output
      .stat_tx_packet_65_127_bytes   (),  // output
      .stat_tx_packet_8192_9215_bytes(),  // output
      .stat_tx_packet_large          (),  // output
      .stat_tx_packet_small          (),  // output
      .stat_tx_total_bytes           (),  // output [5:0]
      .stat_tx_total_good_bytes      (),  // output [13:0]
      .stat_tx_total_good_packets    (),  // output
      .stat_tx_total_packets         (),  // output
      .stat_tx_unicast               (),  // output
      .stat_tx_vlan                  (),  // output

      .ctl_tx_enable      (1'b1),  // input
      .ctl_tx_test_pattern(1'b0),  // input
      .ctl_tx_send_idle   (1'b0),  // input
      .ctl_tx_send_rfi    (1'b0),  // input
      .ctl_tx_send_lfi    (1'b0),  // input
      .core_tx_reset      (1'b0),  // input

      .tx_axis_tready(s_qsfp0_axis_tready),  // output
      .tx_axis_tvalid(s_qsfp0_axis_tvalid),  // input
      .tx_axis_tdata (s_qsfp0_axis_tdata),  // input [511:0]
      .tx_axis_tlast (s_qsfp0_axis_tlast),  // input
      .tx_axis_tkeep (s_qsfp0_axis_tkeep),  // input [63:0]
      .tx_axis_tuser (s_qsfp0_axis_tuser[0]),  // input

      .tx_ovfout    (),  // output
      .tx_unfout    (),  // output
      .tx_preamblein(56'd0),  // input [55:0]
      .usr_tx_reset (qsfp0_tx_rst_int),  // output

      .core_drp_reset(1'b0),  // input
      .drp_clk       (1'b0),  // input
      .drp_addr      (10'd0),  // input [9:0]
      .drp_di        (16'd0),  // input [15:0]
      .drp_en        (1'b0),  // input
      .drp_do        (),  // output [15:0]
      .drp_rdy       (),  // output
      .drp_we        (1'b0)  // input
  );

  cmac_usplus_1 qsfp1_cmac_inst (
      .gt_rxp_in              (qsfp1_gt_rx_p),  // input
      .gt_rxn_in              (qsfp1_gt_rx_n),  // input
      .gt_txp_out             (qsfp1_gt_tx_p),  // output
      .gt_txn_out             (qsfp1_gt_tx_n),  // output
      .gt_txusrclk2           (qsfp1_txuserclk2),  // output
      .gt_loopback_in         (12'd0),  // input [11:0]
      .gt_rxrecclkout         (),  // output [3:0]
      .gt_powergoodout        (),  // output [3:0]
      .gt_ref_clk_out         (),  // output
      .gtwiz_reset_tx_datapath(1'b0),  // input
      .gtwiz_reset_rx_datapath(1'b0),  // input
      .sys_reset              (rst_125mhz_in),  // input
      .gt_ref_clk_p           (qsfp1_161mhz_refclk_in_p),  // input
      .gt_ref_clk_n           (qsfp1_161mhz_refclk_in_n),  // input
      .init_clk               (clk_125mhz_in),  // input

      .rx_axis_tvalid(m_qsfp1_axis_tvalid),  // output
      .rx_axis_tdata (m_qsfp1_axis_tdata),  // output [511:0]
      .rx_axis_tlast (m_qsfp1_axis_tlast),  // output
      .rx_axis_tkeep (m_qsfp1_axis_tkeep),  // output [63:0]
      .rx_axis_tuser (m_qsfp1_axis_tuser[0]),  // output

      .rx_otn_bip8_0  (),  // output [7:0]
      .rx_otn_bip8_1  (),  // output [7:0]
      .rx_otn_bip8_2  (),  // output [7:0]
      .rx_otn_bip8_3  (),  // output [7:0]
      .rx_otn_bip8_4  (),  // output [7:0]
      .rx_otn_data_0  (),  // output [65:0]
      .rx_otn_data_1  (),  // output [65:0]
      .rx_otn_data_2  (),  // output [65:0]
      .rx_otn_data_3  (),  // output [65:0]
      .rx_otn_data_4  (),  // output [65:0]
      .rx_otn_ena     (),  // output
      .rx_otn_lane0   (),  // output
      .rx_otn_vlmarker(),  // output
      .rx_preambleout (),  // output [55:0]
      .usr_rx_reset   (qsfp1_rx_rst_int),  // output
      .gt_rxusrclk2   (),  // output

      .stat_rx_aligned               (),  // output
      .stat_rx_aligned_err           (),  // output
      .stat_rx_bad_code              (),  // output [2:0]
      .stat_rx_bad_fcs               (),  // output [2:0]
      .stat_rx_bad_preamble          (),  // output
      .stat_rx_bad_sfd               (),  // output
      .stat_rx_bip_err_0             (),  // output
      .stat_rx_bip_err_1             (),  // output
      .stat_rx_bip_err_10            (),  // output
      .stat_rx_bip_err_11            (),  // output
      .stat_rx_bip_err_12            (),  // output
      .stat_rx_bip_err_13            (),  // output
      .stat_rx_bip_err_14            (),  // output
      .stat_rx_bip_err_15            (),  // output
      .stat_rx_bip_err_16            (),  // output
      .stat_rx_bip_err_17            (),  // output
      .stat_rx_bip_err_18            (),  // output
      .stat_rx_bip_err_19            (),  // output
      .stat_rx_bip_err_2             (),  // output
      .stat_rx_bip_err_3             (),  // output
      .stat_rx_bip_err_4             (),  // output
      .stat_rx_bip_err_5             (),  // output
      .stat_rx_bip_err_6             (),  // output
      .stat_rx_bip_err_7             (),  // output
      .stat_rx_bip_err_8             (),  // output
      .stat_rx_bip_err_9             (),  // output
      .stat_rx_block_lock            (),  // output [19:0]
      .stat_rx_broadcast             (),  // output
      .stat_rx_fragment              (),  // output [2:0]
      .stat_rx_framing_err_0         (),  // output [1:0]
      .stat_rx_framing_err_1         (),  // output [1:0]
      .stat_rx_framing_err_10        (),  // output [1:0]
      .stat_rx_framing_err_11        (),  // output [1:0]
      .stat_rx_framing_err_12        (),  // output [1:0]
      .stat_rx_framing_err_13        (),  // output [1:0]
      .stat_rx_framing_err_14        (),  // output [1:0]
      .stat_rx_framing_err_15        (),  // output [1:0]
      .stat_rx_framing_err_16        (),  // output [1:0]
      .stat_rx_framing_err_17        (),  // output [1:0]
      .stat_rx_framing_err_18        (),  // output [1:0]
      .stat_rx_framing_err_19        (),  // output [1:0]
      .stat_rx_framing_err_2         (),  // output [1:0]
      .stat_rx_framing_err_3         (),  // output [1:0]
      .stat_rx_framing_err_4         (),  // output [1:0]
      .stat_rx_framing_err_5         (),  // output [1:0]
      .stat_rx_framing_err_6         (),  // output [1:0]
      .stat_rx_framing_err_7         (),  // output [1:0]
      .stat_rx_framing_err_8         (),  // output [1:0]
      .stat_rx_framing_err_9         (),  // output [1:0]
      .stat_rx_framing_err_valid_0   (),  // output
      .stat_rx_framing_err_valid_1   (),  // output
      .stat_rx_framing_err_valid_10  (),  // output
      .stat_rx_framing_err_valid_11  (),  // output
      .stat_rx_framing_err_valid_12  (),  // output
      .stat_rx_framing_err_valid_13  (),  // output
      .stat_rx_framing_err_valid_14  (),  // output
      .stat_rx_framing_err_valid_15  (),  // output
      .stat_rx_framing_err_valid_16  (),  // output
      .stat_rx_framing_err_valid_17  (),  // output
      .stat_rx_framing_err_valid_18  (),  // output
      .stat_rx_framing_err_valid_19  (),  // output
      .stat_rx_framing_err_valid_2   (),  // output
      .stat_rx_framing_err_valid_3   (),  // output
      .stat_rx_framing_err_valid_4   (),  // output
      .stat_rx_framing_err_valid_5   (),  // output
      .stat_rx_framing_err_valid_6   (),  // output
      .stat_rx_framing_err_valid_7   (),  // output
      .stat_rx_framing_err_valid_8   (),  // output
      .stat_rx_framing_err_valid_9   (),  // output
      .stat_rx_got_signal_os         (),  // output
      .stat_rx_hi_ber                (),  // output
      .stat_rx_inrangeerr            (),  // output
      .stat_rx_internal_local_fault  (),  // output
      .stat_rx_jabber                (),  // output
      .stat_rx_local_fault           (),  // output
      .stat_rx_mf_err                (),  // output [19:0]
      .stat_rx_mf_len_err            (),  // output [19:0]
      .stat_rx_mf_repeat_err         (),  // output [19:0]
      .stat_rx_misaligned            (),  // output
      .stat_rx_multicast             (),  // output
      .stat_rx_oversize              (),  // output
      .stat_rx_packet_1024_1518_bytes(),  // output
      .stat_rx_packet_128_255_bytes  (),  // output
      .stat_rx_packet_1519_1522_bytes(),  // output
      .stat_rx_packet_1523_1548_bytes(),  // output
      .stat_rx_packet_1549_2047_bytes(),  // output
      .stat_rx_packet_2048_4095_bytes(),  // output
      .stat_rx_packet_256_511_bytes  (),  // output
      .stat_rx_packet_4096_8191_bytes(),  // output
      .stat_rx_packet_512_1023_bytes (),  // output
      .stat_rx_packet_64_bytes       (),  // output
      .stat_rx_packet_65_127_bytes   (),  // output
      .stat_rx_packet_8192_9215_bytes(),  // output
      .stat_rx_packet_bad_fcs        (),  // output
      .stat_rx_packet_large          (),  // output
      .stat_rx_packet_small          (),  // output [2:0]

      .ctl_rx_enable      (1'b1),  // input
      .ctl_rx_force_resync(1'b0),  // input
      .ctl_rx_test_pattern(1'b0),  // input
      .core_rx_reset      (1'b0),  // input
      .rx_clk             (qsfp1_rx_clk_int),  // input

      .stat_rx_received_local_fault (),  // output
      .stat_rx_remote_fault         (),  // output
      .stat_rx_status               (qsfp1_rx_status),  // output
      .stat_rx_stomped_fcs          (),  // output [2:0]
      .stat_rx_synced               (),  // output [19:0]
      .stat_rx_synced_err           (),  // output [19:0]
      .stat_rx_test_pattern_mismatch(),  // output [2:0]
      .stat_rx_toolong              (),  // output
      .stat_rx_total_bytes          (),  // output [6:0]
      .stat_rx_total_good_bytes     (),  // output [13:0]
      .stat_rx_total_good_packets   (),  // output
      .stat_rx_total_packets        (),  // output [2:0]
      .stat_rx_truncated            (),  // output
      .stat_rx_undersize            (),  // output [2:0]
      .stat_rx_unicast              (),  // output
      .stat_rx_vlan                 (),  // output
      .stat_rx_pcsl_demuxed         (),  // output [19:0]
      .stat_rx_pcsl_number_0        (),  // output [4:0]
      .stat_rx_pcsl_number_1        (),  // output [4:0]
      .stat_rx_pcsl_number_10       (),  // output [4:0]
      .stat_rx_pcsl_number_11       (),  // output [4:0]
      .stat_rx_pcsl_number_12       (),  // output [4:0]
      .stat_rx_pcsl_number_13       (),  // output [4:0]
      .stat_rx_pcsl_number_14       (),  // output [4:0]
      .stat_rx_pcsl_number_15       (),  // output [4:0]
      .stat_rx_pcsl_number_16       (),  // output [4:0]
      .stat_rx_pcsl_number_17       (),  // output [4:0]
      .stat_rx_pcsl_number_18       (),  // output [4:0]
      .stat_rx_pcsl_number_19       (),  // output [4:0]
      .stat_rx_pcsl_number_2        (),  // output [4:0]
      .stat_rx_pcsl_number_3        (),  // output [4:0]
      .stat_rx_pcsl_number_4        (),  // output [4:0]
      .stat_rx_pcsl_number_5        (),  // output [4:0]
      .stat_rx_pcsl_number_6        (),  // output [4:0]
      .stat_rx_pcsl_number_7        (),  // output [4:0]
      .stat_rx_pcsl_number_8        (),  // output [4:0]
      .stat_rx_pcsl_number_9        (),  // output [4:0]

      .stat_tx_bad_fcs               (),  // output
      .stat_tx_broadcast             (),  // output
      .stat_tx_frame_error           (),  // output
      .stat_tx_local_fault           (),  // output
      .stat_tx_multicast             (),  // output
      .stat_tx_packet_1024_1518_bytes(),  // output
      .stat_tx_packet_128_255_bytes  (),  // output
      .stat_tx_packet_1519_1522_bytes(),  // output
      .stat_tx_packet_1523_1548_bytes(),  // output
      .stat_tx_packet_1549_2047_bytes(),  // output
      .stat_tx_packet_2048_4095_bytes(),  // output
      .stat_tx_packet_256_511_bytes  (),  // output
      .stat_tx_packet_4096_8191_bytes(),  // output
      .stat_tx_packet_512_1023_bytes (),  // output
      .stat_tx_packet_64_bytes       (),  // output
      .stat_tx_packet_65_127_bytes   (),  // output
      .stat_tx_packet_8192_9215_bytes(),  // output
      .stat_tx_packet_large          (),  // output
      .stat_tx_packet_small          (),  // output
      .stat_tx_total_bytes           (),  // output [5:0]
      .stat_tx_total_good_bytes      (),  // output [13:0]
      .stat_tx_total_good_packets    (),  // output
      .stat_tx_total_packets         (),  // output
      .stat_tx_unicast               (),  // output
      .stat_tx_vlan                  (),  // output

      .ctl_tx_enable      (1'b1),  // input
      .ctl_tx_test_pattern(1'b0),  // input
      .ctl_tx_send_idle   (1'b0),  // input
      .ctl_tx_send_rfi    (1'b0),  // input
      .ctl_tx_send_lfi    (1'b0),  // input
      .core_tx_reset      (1'b0),  // input

      .tx_axis_tready(s_qsfp1_axis_tready),  // output
      .tx_axis_tvalid(s_qsfp1_axis_tvalid),  // input
      .tx_axis_tdata (s_qsfp1_axis_tdata),  // input [511:0]
      .tx_axis_tlast (s_qsfp1_axis_tlast),  // input
      .tx_axis_tkeep (s_qsfp1_axis_tkeep),  // input [63:0]
      .tx_axis_tuser (s_qsfp1_axis_tuser[0]),  // input

      .tx_ovfout    (),  // output
      .tx_unfout    (),  // output
      .tx_preamblein(56'd0),  // input [55:0]
      .usr_tx_reset (qsfp1_tx_rst_int),  // output

      .core_drp_reset(1'b0),  // input
      .drp_clk       (1'b0),  // input
      .drp_addr      (10'd0),  // input [9:0]
      .drp_di        (16'd0),  // input [15:0]
      .drp_en        (1'b0),  // input
      .drp_do        (),  // output [15:0]
      .drp_rdy       (),  // output
      .drp_we        (1'b0)  // input
  );


endmodule
