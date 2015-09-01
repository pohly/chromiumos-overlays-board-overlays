# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""DUT health checks for moblab."""

from __future__ import print_function

import netifaces

import common

from chromite.lib import cros_build_lib


class DutExists(object):
  """Verifies that a DUT is connected to moblab."""

  def Check(self):
    """Verify that at least one DUT is connected.

    Returns:
      0 if at least one DUT exists on moblab's test subnet.
      -1 if the moblab test subnet cannot be found.
      -2 if no DUTs can be found.
    """
    # First, find the network interface the test subnet is connected to.
    def FindInterface():
      for iface in netifaces.interfaces():
        addrs = netifaces.ifaddresses(iface).get(netifaces.AF_INET)
        if not addrs:
          continue
        for addr in addrs:
          if common.MOBLAB_SUBNET_ADDR == addr.get('addr'):
            return addr['addr']

    subnet_iface = FindInterface()

    if not subnet_iface:
      return -1

    # Send ICMP ECHO_REQUESTs to DUTs.
    cmd = ['fping', '-c', '1', '-g', '192.168.231.100', '192.168.231.120']
    cros_build_lib.SudoRunCommand(cmd, error_code_ok=True)

    # Check ARP cache to determine which, if any, DUTs exist.
    duts = []
    cmd = ['arp']
    arpcache = cros_build_lib.SudoRunCommand(
        cmd, log_output=True).output.strip()
    for dut in arpcache.split('\n'):
      if subnet_iface in dut and 'incomplete' not in dut:
        duts.append(dut)

    if not duts:
      return -2

    return 0

  def Diagnose(self, errcode):
    if -1 == errcode:
      return ('Moblab test subnet interface could not be found.', [])

    elif -2 == errcode:
      return ('No DUTs were detected. Please plug in a device for test.', [])

    return ('Unknown error reached with error code: %s' % errcode, [])
