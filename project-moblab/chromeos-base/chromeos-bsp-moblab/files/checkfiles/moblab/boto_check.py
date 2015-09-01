# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Boto file health checks for devserver."""

from __future__ import print_function

import netifaces
import os
import re

import common

from chromite.lib import cros_build_lib


def GetIp():
  for iface in netifaces.interfaces():
    if 'eth' not in iface:
      continue
    addrs = netifaces.ifaddresses(iface).get(netifaces.AF_INET)
    if not addrs:
      continue
    for addr in addrs:
      if common.MOBLAB_SUBNET_ADDR != addr.get('addr'):
        return addr['addr']

  return 'localhost'


class BotoFile(object):
  """Verifies that a Boto key exists."""

  def Check(self):
    """Verifies that moblab has a Boto for proper gs_offloader functioning.

    Returns:
      0 if a Boto key exists.
      -1 if a Boto key does not exist.
    """
    if not os.path.exists('/home/moblab/.boto'):
      return -1

    return 0

  def Diagnose(self, errcode):
    if -1 == errcode:
      return ('Boto key is missing. Please upload a valid key'
              ' at the following address:'
              ' http://%s/moblab_setup/' % GetIp(),
              [])

    return ('Unknown error reached with error code: %s' % errcode, [])
