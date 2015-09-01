# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Network monitoring health checks for moblab."""

from __future__ import print_function

import netifaces

from chromite.lib import cros_build_lib


class InternetAccess(object):
  """Verifies that moblab can connect to the internet."""

  DNS = ['4.2.2.2', '4.2.2.3', '4.2.2.4', '8.8.4.4', '8.8.8.8']
  PING_WAIT_SEC = '3'
  PING_COUNT = '3'

  def Check(self):
    """Verify that this moblab device has internet access.

    We test internet access by trying to connect to a handful
    of public DNS addresses that would be unlikely be down,
    or even to be down all at the same time.

    Returns:
      0 if this moblab device successfully connects to at least
        one of DNS.
      -1 if moblab cannot connect to any of DNS.
    """
    for dns in self.DNS:
      cmd = ['ping', '-W', self.PING_WAIT_SEC, '-c', self.PING_COUNT, dns]
      result = cros_build_lib.RunCommand(cmd, error_code_ok=True)

      if not result.returncode:
        return 0

    return -1

  def Diagnose(self, errcode):
    if -1 == errcode:
      return ('Moblab is having trouble connecting to the internet.'
              ' Please double-check your physical connections.',
              [])

    return ('Unknown error reached with error code: %s' % errcode, [])


class UsbEthernet(object):
  """Verifies that moblab has a USB ethernet device connected."""

  def Check(self):
    """Verify that a USB ethernet device is present.

    Returns:
      0 if a USB ethernet device exists.
      -1 if no USB ethernet device is detected.
    """
    # External ethernet will be either eth0 or eth1. If a usb ethernet
    # device is detected, we should have more than one eth* interface.
    eth_ifaces = []
    for iface in netifaces.interfaces():
      if 'eth' in iface:
        eth_ifaces.append(iface)

    if len(eth_ifaces) > 1:
      return 0

    return -1

  def Diagnose(self, errcode):
    if -1 == errcode:
      return ('No USB ethernet device detected. This may indicate that'
              ' no DUT (or some other important device) is not connected.',
              [])

    return ('Unknown error reached with error code: %s' % errcode, [])
