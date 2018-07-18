#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Measure SDM845 clocks using /dev/mem.

Can be used as a command-line tool or via 'import testclock' in python.
"""

from __future__ import print_function

import sys
import mem
import code

_BANNER = """Welcome to testclock interactive mode (featuring python!)

Available clocks:
"""

GCC_BASE = 0x100000
GCC_DEBUG_POST_DIV = GCC_BASE + 0x62000
GCC_DEBUG_CBCR = GCC_BASE + 0x62004
GCC_DEBUG_OFFSET = GCC_BASE + 0x62008
GCC_DEBUG_CTL = GCC_BASE + 0x62024
GCC_DEBUG_STATUS = GCC_BASE + 0x62028
GCC_XO_DIV4_CBCR = GCC_BASE + 0x43008


class MuxSetting(object):
  """Measurement mux settings used to measure a clock.

  Measures a clock's frequency using the ring oscillator via /dev/mem. Some
  muxes need to be moved around and sometimes some dividers need to be
  configured to get the proper frequency.
  """
  def __init__(self, name, prim_mux_sel, prim_mux_div_val, non_gcc_base,
               dbg_cc_mux_sel, mux_sel_mask, mux_sel_shift, post_div_mask,
               post_div_shift, post_div_val, mux_offset, post_div_offset,
               cbcr_offset, misc_div_val=None):
    self.name = name
    self.prim_mux_sel = prim_mux_sel
    self.prim_mux_div_val = prim_mux_div_val
    self.non_gcc_base = non_gcc_base
    self.dbg_cc_mux_sel = dbg_cc_mux_sel
    self.mux_sel_mask = mux_sel_mask
    self.mux_sel_shift = mux_sel_shift
    self.post_div_mask = post_div_mask
    self.post_div_shift = post_div_shift
    self.post_div_val = post_div_val
    self.mux_offset = mux_offset
    self.post_div_offset = post_div_offset
    self.cbcr_offset = cbcr_offset
    self.misc_div_val = misc_div_val

  def _run_measurement(self, ticks):
    # Stop counters and set the XO4 counter start value
    mem.w(GCC_DEBUG_CTL, ticks)

    val = mem.r(GCC_DEBUG_STATUS)

    # Wait for timer to become ready
    while (val & (1 << 25)) != 0:
      val = mem.r(GCC_DEBUG_STATUS)

    # Run measurement and wait for completion
    mem.w(GCC_DEBUG_CTL, (1 << 20) | ticks)

    val = mem.r(GCC_DEBUG_STATUS)

    while (val & (1 << 25)) == 0:
      val = mem.r(GCC_DEBUG_STATUS)

    # Return measured ticks
    val = mem.r(GCC_DEBUG_STATUS)
    val &= 0xffffff
    # Stop the counters
    mem.w(GCC_DEBUG_CTL, ticks)

    return val

  def _clk_debug_mux_measure_rate(self):
    # Enable CXO/4 and RINGOSC branch
    val = mem.r(GCC_XO_DIV4_CBCR)
    val |= 1
    mem.w(GCC_XO_DIV4_CBCR, val)

    # The ring oscillator counter will not reset if the measured clock
    # is not running.  To detect this, run a short measurement before
    # the full measurement.  If the raw results of the two are the same
    # then the clock must be off.

    # Run a short measurement. (~1 ms)
    raw_count_short = self._run_measurement(0x1000)

    # Run a full measurement. (~14 ms)
    raw_count_full = self._run_measurement(0x10000)

    val &= ~1
    mem.w(GCC_XO_DIV4_CBCR, val)

    # Return 0 if the clock is off
    if raw_count_full == raw_count_short:
      return 0

    # Compute rate in Hz
    raw_count_full = ((raw_count_full * 10) + 15) * 4800000
    raw_count_full = raw_count_full / ((0x10000 * 10) + 35)

    return raw_count_full

  def measure(self):
    """Measure clock frequency in Hz."""
    if self.non_gcc_base:
      # Update the recursive debug mux
      val = mem.r(self.mux_offset)
      val &= ~(self.mux_sel_mask << self.mux_sel_shift)
      val |= (self.dbg_cc_mux_sel & self.mux_sel_mask) << self.mux_sel_shift
      mem.w(self.mux_offset, val)

      val = mem.r(self.post_div_offset)
      val &= ~(self.post_div_mask << self.post_div_shift)
      post_div = (self.post_div_val - 1) & self.post_div_mask
      post_div <<= self.post_div_shift
      val |= post_div
      mem.w(self.post_div_offset, val)

      # Not all recursive muxes have a DEBUG clock
      if self.cbcr_offset:
        val = mem.r(self.cbcr_offset)
        val |= 1
        mem.w(self.cbcr_offset, val)

    # Update the debug sel for GCC
    val = mem.r(GCC_DEBUG_OFFSET)
    val &= ~0x3ff
    val |= self.prim_mux_sel & 0x3ff
    mem.w(GCC_DEBUG_OFFSET, val)

    # Set the GCC mux's post divider bits
    val = mem.r(GCC_DEBUG_POST_DIV)
    val &= ~0xf
    val |= (self.prim_mux_div_val - 1) & 0xF
    mem.w(GCC_DEBUG_POST_DIV, val)

    # Turn on the GCC_DEBUG_CBCR
    val = mem.r(GCC_DEBUG_CBCR)
    val |= 1
    mem.w(GCC_DEBUG_CBCR, val)

    val = self._clk_debug_mux_measure_rate()
    if self.non_gcc_base:
      val *= self.post_div_val
    val *= self.prim_mux_div_val

    # Accommodate for any pre-set dividers
    if self.misc_div_val:
      val *= self.misc_div_val

    return val

  def __repr__(self):
    return self.name

  def __str__(self):
    return "%s %s" % (self.name, self.measure())


clocks = [
    MuxSetting("cam_cc_bps_ahb_clk", 0x46, 4, True, 0xE, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_bps_areg_clk", 0x46, 4, True, 0xD, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_bps_axi_clk", 0x46, 4, True, 0xC, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_bps_clk", 0x46, 4, True, 0xB, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_camnoc_atb_clk", 0x46, 4, True, 0x34, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_camnoc_axi_clk", 0x46, 4, True, 0x2D, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_cci_clk", 0x46, 4, True, 0x2A, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_cpas_ahb_clk", 0x46, 4, True, 0x2C, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_csi0phytimer_clk", 0x46, 4, True, 0x5, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_csi1phytimer_clk", 0x46, 4, True, 0x7, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_csi2phytimer_clk", 0x46, 4, True, 0x9, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_csiphy0_clk", 0x46, 4, True, 0x6, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_csiphy1_clk", 0x46, 4, True, 0x8, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_csiphy2_clk", 0x46, 4, True, 0xA, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_csiphy3_clk", 0x46, 4, True, 0x36, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_fd_core_clk", 0x46, 4, True, 0x28, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_fd_core_uar_clk", 0x46, 4, True, 0x29, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_icp_apb_clk", 0x46, 4, True, 0x32, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_icp_atb_clk", 0x46, 4, True, 0x2F, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_icp_clk", 0x46, 4, True, 0x26, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_icp_cti_clk", 0x46, 4, True, 0x30, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_icp_ts_clk", 0x46, 4, True, 0x31, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ife_0_axi_clk", 0x46, 4, True, 0x1B, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ife_0_clk", 0x46, 4, True, 0x17, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ife_0_cphy_rx_clk", 0x46, 4, True, 0x1A, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ife_0_csid_clk", 0x46, 4, True, 0x19, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ife_0_dsp_clk", 0x46, 4, True, 0x18, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ife_1_axi_clk", 0x46, 4, True, 0x21, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ife_1_clk", 0x46, 4, True, 0x1D, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ife_1_cphy_rx_clk", 0x46, 4, True, 0x20, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ife_1_csid_clk", 0x46, 4, True, 0x1F, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ife_1_dsp_clk", 0x46, 4, True, 0x1E, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ife_lite_clk", 0x46, 4, True, 0x22, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ife_lite_cphy_rx_clk", 0x46, 4, True, 0x24, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ife_lite_csid_clk", 0x46, 4, True, 0x23, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ipe_0_ahb_clk", 0x46, 4, True, 0x12, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ipe_0_areg_clk", 0x46, 4, True, 0x11, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ipe_0_axi_clk", 0x46, 4, True, 0x10, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ipe_0_clk", 0x46, 4, True, 0xF, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ipe_1_ahb_clk", 0x46, 4, True, 0x16, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ipe_1_areg_clk", 0x46, 4, True, 0x15, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ipe_1_axi_clk", 0x46, 4, True, 0x14, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_ipe_1_clk", 0x46, 4, True, 0x13, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_jpeg_clk", 0x46, 4, True, 0x25, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_lrme_clk", 0x46, 4, True, 0x2B, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_mclk0_clk", 0x46, 4, True, 0x1, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_mclk1_clk", 0x46, 4, True, 0x2, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_mclk2_clk", 0x46, 4, True, 0x3, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_mclk3_clk", 0x46, 4, True, 0x4, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_soc_ahb_clk", 0x46, 4, True, 0x2E, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("cam_cc_sys_tmr_clk", 0x46, 4, True, 0x33, 0xFF, 0,
               0x3, 0, 1, 0xad0c000, 0xad0c004, 0xad0c008),
    MuxSetting("disp_cc_mdss_ahb_clk", 0x47, 4, True, 0x13, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_axi_clk", 0x47, 4, True, 0x14, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_byte0_clk", 0x47, 4, True, 0x7, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_byte0_intf_clk", 0x47, 4, True, 0x8, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_byte1_clk", 0x47, 4, True, 0x9, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_byte1_intf_clk", 0x47, 4, True, 0xA, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_dp_aux_clk", 0x47, 4, True, 0x12, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_dp_crypto_clk", 0x47, 4, True, 0xF, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_dp_link_clk", 0x47, 4, True, 0xD, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_dp_link_intf_clk", 0x47, 4, True, 0xE, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_dp_pixel1_clk", 0x47, 4, True, 0x11, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_dp_pixel_clk", 0x47, 4, True, 0x10, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_esc0_clk", 0x47, 4, True, 0xB, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_esc1_clk", 0x47, 4, True, 0xC, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_mdp_clk", 0x47, 4, True, 0x3, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_mdp_lut_clk", 0x47, 4, True, 0x5, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_pclk0_clk", 0x47, 4, True, 0x1, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_pclk1_clk", 0x47, 4, True, 0x2, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_qdss_at_clk", 0x47, 4, True, 0x15, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_qdss_tsctr_div8_clk", 0x47, 4, True, 0x16, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_rot_clk", 0x47, 4, True, 0x4, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_rscc_ahb_clk", 0x47, 4, True, 0x17, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_rscc_vsync_clk", 0x47, 4, True, 0x18, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("disp_cc_mdss_vsync_clk", 0x47, 4, True, 0x6, 0xFF, 0,
               0x3, 0, 1, 0xaf06000, 0xaf06008, 0xaf0600C),
    MuxSetting("gcc_usb30_prim_master_clk", 0x5F, 4, False, 0x5F, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("measure_only_snoc_clk", 0x7, 4, False, 0x7, 0x3FFF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("measure_only_cnoc_clk", 0x15, 4, False, 0x7, 0x3FFF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("measure_only_bimc_clk", 0xc2, 4, False, 0x7, 0x3FFF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("measure_only_ipa_2x_clk", 0x128, 4, False, 0x7, 0x3FFF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_aggre_noc_pcie_tbu_clk", 0x2D, 4, False, 0x2D, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_aggre_ufs_card_axi_clk", 0x11E, 4, False, 0x11E, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_aggre_ufs_phy_axi_clk", 0x11D, 4, False, 0x11D, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_aggre_usb3_prim_axi_clk", 0x11B, 4, False, 0x11B, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_aggre_usb3_sec_axi_clk", 0x11C, 4, False, 0x11C, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_apc_vs_clk", 0x113, 4, False, 0x113, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_boot_rom_ahb_clk", 0x94, 4, False, 0x94, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_camera_ahb_clk", 0x3A, 4, False, 0x3A, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_camera_axi_clk", 0x40, 4, False, 0x40, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_camera_xo_clk", 0x43, 4, False, 0x43, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ce1_ahb_clk", 0xA9, 4, False, 0xA9, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ce1_axi_clk", 0xA8, 4, False, 0xA8, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ce1_clk", 0xA7, 4, False, 0xA7, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_cfg_noc_usb3_prim_axi_clk", 0x1D, 4, False, 0x1D, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_cfg_noc_usb3_sec_axi_clk", 0x1E, 4, False, 0x1E, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_cpuss_ahb_clk", 0xCE, 4, False, 0xCE, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_cpuss_dvm_bus_clk", 0xD3, 4, False, 0xD3, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_cpuss_gnoc_clk", 0xCF, 4, False, 0xCF, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_cpuss_rbcpr_clk", 0xD0, 4, False, 0xD0, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ddrss_gpu_axi_clk", 0xBB, 4, False, 0xBB, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_disp_ahb_clk", 0x3B, 4, False, 0x3B, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_disp_axi_clk", 0x41, 4, False, 0x41, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_disp_gpll0_clk_src", 0x4C, 4, False, 0x4C, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_disp_gpll0_div_clk_src", 0x4D, 4, False, 0x4D, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_disp_xo_clk", 0x44, 4, False, 0x44, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_gp1_clk", 0xDE, 4, False, 0xDE, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_gp2_clk", 0xDF, 4, False, 0xDF, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_gp3_clk", 0xE0, 4, False, 0xE0, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_gpu_cfg_ahb_clk", 0x142, 4, False, 0x142, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_gpu_gpll0_clk_src", 0x148, 4, False, 0x148, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_gpu_gpll0_div_clk_src", 0x149, 4, False, 0x149, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_gpu_memnoc_gfx_clk", 0x145, 4, False, 0x145, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_gpu_snoc_dvm_gfx_clk", 0x147, 4, False, 0x147, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_gpu_vs_clk", 0x112, 4, False, 0x112, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_mss_axis2_clk", 0x12F, 4, False, 0x12F, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_mss_cfg_ahb_clk", 0x12D, 4, False, 0x12D, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_mss_gpll0_div_clk_src", 0x133, 4, False, 0x133, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_mss_mfab_axis_clk", 0x12E, 4, False, 0x12E, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_mss_q6_memnoc_axi_clk", 0x135, 4, False, 0x135, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_mss_snoc_axi_clk", 0x134, 4, False, 0x134, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_mss_vs_clk", 0x111, 4, False, 0x111, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_0_aux_clk", 0xE5, 4, False, 0xE5, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_0_cfg_ahb_clk", 0xE4, 4, False, 0xE4, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_0_mstr_axi_clk", 0xE3, 4, False, 0xE3, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_0_pipe_clk", 0xE6, 4, False, 0xE6, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_0_slv_axi_clk", 0xE2, 4, False, 0xE2, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_0_slv_q2a_axi_clk", 0xE1, 4, False, 0xE1, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_1_aux_clk", 0xEC, 4, False, 0xEC, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_1_cfg_ahb_clk", 0xEB, 4, False, 0xEB, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_1_mstr_axi_clk", 0xEA, 4, False, 0xEA, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_1_pipe_clk", 0xED, 4, False, 0xED, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_1_slv_axi_clk", 0xE9, 4, False, 0xE9, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_1_slv_q2a_axi_clk", 0xE8, 4, False, 0xE8, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_phy_aux_clk", 0xEF, 4, False, 0xEF, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pcie_phy_refgen_clk", 0x160, 4, False, 0x160, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pdm2_clk", 0x8E, 4, False, 0x8E, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pdm_ahb_clk", 0x8C, 4, False, 0x8C, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_pdm_xo4_clk", 0x8D, 4, False, 0x8D, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_prng_ahb_clk", 0x8F, 4, False, 0x8F, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qmip_camera_ahb_clk", 0x3D, 4, False, 0x3D, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qmip_disp_ahb_clk", 0x3E, 4, False, 0x3E, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qmip_video_ahb_clk", 0x3C, 4, False, 0x3C, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap0_core_2x_clk", 0x77, 4, False, 0x77, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap0_core_clk", 0x76, 4, False, 0x76, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap0_s0_clk", 0x78, 4, False, 0x78, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap0_s1_clk", 0x79, 4, False, 0x79, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap0_s2_clk", 0x7A, 4, False, 0x7A, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap0_s3_clk", 0x7B, 4, False, 0x7B, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap0_s4_clk", 0x7C, 4, False, 0x7C, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap0_s5_clk", 0x7D, 4, False, 0x7D, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap0_s6_clk", 0x7E, 4, False, 0x7E, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap0_s7_clk", 0x7F, 4, False, 0x7F, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap1_core_2x_clk", 0x80, 4, False, 0x80, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap1_core_clk", 0x81, 4, False, 0x81, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap1_s0_clk", 0x84, 4, False, 0x84, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap1_s1_clk", 0x85, 4, False, 0x85, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap1_s2_clk", 0x86, 4, False, 0x86, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap1_s3_clk", 0x87, 4, False, 0x87, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap1_s4_clk", 0x88, 4, False, 0x88, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap1_s5_clk", 0x89, 4, False, 0x89, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap1_s6_clk", 0x8A, 4, False, 0x8A, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap1_s7_clk", 0x8B, 4, False, 0x8B, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap_0_m_ahb_clk", 0x74, 4, False, 0x74, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap_0_s_ahb_clk", 0x75, 4, False, 0x75, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap_1_m_ahb_clk", 0x82, 4, False, 0x82, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_qupv3_wrap_1_s_ahb_clk", 0x83, 4, False, 0x83, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_sdcc2_ahb_clk", 0x71, 4, False, 0x71, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_sdcc2_apps_clk", 0x70, 4, False, 0x70, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_sdcc4_ahb_clk", 0x73, 4, False, 0x73, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_sdcc4_apps_clk", 0x72, 4, False, 0x72, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_sys_noc_cpuss_ahb_clk", 0xC, 4, False, 0xC, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_tsif_ahb_clk", 0x90, 4, False, 0x90, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_tsif_inactivity_timers_clk", 0x92, 4, False, 0x92, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_tsif_ref_clk", 0x91, 4, False, 0x91, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_card_ahb_clk", 0xF1, 4, False, 0xF1, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_card_axi_clk", 0xF0, 4, False, 0xF0, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_card_ice_core_clk", 0xF7, 4, False, 0xF7, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_card_phy_aux_clk", 0xF8, 4, False, 0xF8, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_card_rx_symbol_0_clk", 0xF3, 4, False, 0xF3, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_card_rx_symbol_1_clk", 0xF9, 4, False, 0xF9, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_card_tx_symbol_0_clk", 0xF2, 4, False, 0xF2, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_card_unipro_core_clk", 0xF6, 4, False, 0xF6, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_phy_ahb_clk", 0xFC, 4, False, 0xFC, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_phy_axi_clk", 0xFB, 4, False, 0xFB, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_phy_ice_core_clk", 0x102, 4, False, 0x102, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_phy_phy_aux_clk", 0x103, 4, False, 0x103, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_phy_rx_symbol_0_clk", 0xFE, 4, False, 0xFE, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_phy_rx_symbol_1_clk", 0x104, 4, False, 0x104, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_phy_tx_symbol_0_clk", 0xFD, 4, False, 0xFD, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_ufs_phy_unipro_core_clk", 0x101, 4, False, 0x101, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_usb30_prim_master_clk", 0x5F, 4, False, 0x5F, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_usb30_prim_mock_utmi_clk", 0x61, 4, False, 0x61, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_usb30_prim_sleep_clk", 0x60, 4, False, 0x60, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_usb30_sec_master_clk", 0x65, 4, False, 0x65, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_usb30_sec_mock_utmi_clk", 0x67, 4, False, 0x67, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_usb30_sec_sleep_clk", 0x66, 4, False, 0x66, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_usb3_prim_phy_aux_clk", 0x62, 4, False, 0x62, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_usb3_prim_phy_com_aux_clk", 0x63, 4, False, 0x63, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_usb3_prim_phy_pipe_clk", 0x64, 4, False, 0x64, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_usb3_sec_phy_aux_clk", 0x68, 4, False, 0x68, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_usb3_sec_phy_com_aux_clk", 0x69, 4, False, 0x69, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_usb3_sec_phy_pipe_clk", 0x6A, 4, False, 0x6A, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_usb_phy_cfg_ahb2phy_clk", 0x6F, 4, False, 0x6F, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_vdda_vs_clk", 0x10E, 4, False, 0x10E, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_vddcx_vs_clk", 0x10C, 4, False, 0x10C, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_vddmx_vs_clk", 0x10D, 4, False, 0x10D, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_video_ahb_clk", 0x39, 4, False, 0x39, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_video_axi_clk", 0x3F, 4, False, 0x3F, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_video_xo_clk", 0x42, 4, False, 0x42, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_vs_ctrl_ahb_clk", 0x110, 4, False, 0x110, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_vs_ctrl_clk", 0x10F, 4, False, 0x10F, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_sdcc1_ahb_clk", 0x15C, 4, False, 0x42, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_sdcc1_apps_clk", 0x15B, 4, False, 0x42, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gcc_sdcc1_ice_core_clk", 0x15D, 4, False, 0x42, 0x3FF, 0,
               0xF, 0, 4, 0x162008, 0x162000, 0x162004),
    MuxSetting("gpu_cc_acd_cxo_clk", 0x144, 4, True, 0x1F, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_crc_ahb_clk", 0x144, 4, True, 0x12, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_cx_apb_clk", 0x144, 4, True, 0x15, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_cx_gfx3d_clk", 0x144, 4, True, 0x1A, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_cx_gfx3d_slv_clk", 0x144, 4, True, 0x1B, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_cx_gmu_clk", 0x144, 4, True, 0x19, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_cx_qdss_at_clk", 0x144, 4, True, 0x13, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_cx_qdss_trig_clk", 0x144, 4, True, 0x18, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_cx_qdss_tsctr_clk", 0x144, 4, True, 0x14, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_cx_snoc_dvm_clk", 0x144, 4, True, 0x16, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_cxo_aon_clk", 0x144, 4, True, 0xB, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_cxo_clk", 0x144, 4, True, 0xA, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_gx_gfx3d_clk", 0x144, 4, True, 0xC, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_gx_gmu_clk", 0x144, 4, True, 0x10, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_gx_qdss_tsctr_clk", 0x144, 4, True, 0xE, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_gx_vsense_clk", 0x144, 4, True, 0xD, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_rbcpr_ahb_clk", 0x144, 4, True, 0x1D, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_rbcpr_clk", 0x144, 4, True, 0x1C, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("gpu_cc_sleep_clk", 0x144, 4, True, 0x17, 0xFF, 0,
               0x3, 0, 1, 0x5091568, 0x50910FC, 0x5091100),
    MuxSetting("video_cc_apb_clk", 0x48, 4, True, 0x8, 0x3F, 0,
               0x7, 0, 1, 0xab00a4c, 0xab00a50, 0xab00a58),
    MuxSetting("video_cc_at_clk", 0x48, 4, True, 0xB, 0x3F, 0,
               0x7, 0, 1, 0xab00a4c, 0xab00a50, 0xab00a58),
    MuxSetting("video_cc_qdss_trig_clk", 0x48, 4, True, 0x7, 0x3F, 0,
               0x7, 0, 1, 0xab00a4c, 0xab00a50, 0xab00a58),
    MuxSetting("video_cc_qdss_tsctr_div8_clk", 0x48, 4, True, 0xA, 0x3F, 0,
               0x7, 0, 1, 0xab00a4c, 0xab00a50, 0xab00a58),
    MuxSetting("video_cc_vcodec0_axi_clk", 0x48, 4, True, 0x5, 0x3F, 0,
               0x7, 0, 1, 0xab00a4c, 0xab00a50, 0xab00a58),
    MuxSetting("video_cc_vcodec0_core_clk", 0x48, 4, True, 0x2, 0x3F, 0,
               0x7, 0, 1, 0xab00a4c, 0xab00a50, 0xab00a58),
    MuxSetting("video_cc_vcodec1_axi_clk", 0x48, 4, True, 0x6, 0x3F, 0,
               0x7, 0, 1, 0xab00a4c, 0xab00a50, 0xab00a58),
    MuxSetting("video_cc_vcodec1_core_clk", 0x48, 4, True, 0x3, 0x3F, 0,
               0x7, 0, 1, 0xab00a4c, 0xab00a50, 0xab00a58),
    MuxSetting("video_cc_venus_ahb_clk", 0x48, 4, True, 0x9, 0x3F, 0,
               0x7, 0, 1, 0xab00a4c, 0xab00a50, 0xab00a58),
    MuxSetting("video_cc_venus_ctl_axi_clk", 0x48, 4, True, 0x4, 0x3F, 0,
               0x7, 0, 1, 0xab00a4c, 0xab00a50, 0xab00a58),
    MuxSetting("video_cc_venus_ctl_core_clk", 0x48, 4, True, 0x1, 0x3F, 0,
               0x7, 0, 1, 0xab00a4c, 0xab00a50, 0xab00a58),
    MuxSetting("l3_clk", 0xD6, 4, True, 0x46, 0x7F, 4,
               0xf, 11, 1, 0x17970018, 0x17970018, None, 16),
    MuxSetting("pwrcl_clk", 0xD6, 4, True, 0x44, 0x7F, 4,
               0xf, 11, 1, 0x17970018, 0x17970018, None, 16),
    MuxSetting("perfcl_clk", 0xD6, 4, True, 0x45, 0x7F, 4,
               0xf, 11, 1, 0x17970018, 0x17970018, None, 16),
]


def _list_clocks():
  """Return a list of clocks as a string.

  Returns:
    A string that can be printed to the user.
  """
  return '\n'.join([' ' + c.name for c in clocks])


def main(args=None):
  for c in clocks:
    globals()[c.name] = c

  if args is None:
    args = sys.argv[1:]

  if not args:
    # Try to pretend that they ran python -i to just use us interactively.
    return code.interact(banner=_BANNER + _list_clocks(), local=globals())

  funcs = {cl.name: cl.measure for cl in clocks}
  try:
    # Parse args and get back something we can use to call the function.
    for arg in args:
      if arg == "-h" or arg == "--help":
        print("Available clocks\n" + _list_clocks())
      elif arg in funcs:
        print(funcs[arg]())
      else:
        print("Unknown clk '", arg, "'", sep="")
        return 1
  except Exception as e:
    # For now really simple error handling...
    print(str(e))
    return 1

  return 0


if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
