# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Repair actions for moblab health checks."""

from __future__ import print_function

import common

import os
import re

from chromite.lib import cros_build_lib


#
# Disk actions.
#
def MountUsbWrapper(device):
  """Wrapper for mounting USB devices.

  Args:
    device: The name of USB device we wish to mount.
  """
  def MountUsb():
    """Mount the USB device."""
    # Unmount |device| as it may already be mounted in the wrong location.
    cmd = ['umount', device]
    cros_build_lib.SudoRunCommand(cmd, error_code_ok=True)

    # Mount |device| in the correct location.
    cmd = ['mount', device, common.MOBLAB_MOUNTPOINT, '-o',
           'exec,dev,nosuid']
    cros_build_lib.SudoRunCommand(cmd)

  return MountUsb


def ClearOldDbRecords(date):
  """Delete older database records.

  Args:
    date: Must be in the format 'yyyy-mm-dd'. We keep records that are
      newer than the given date.
  """
  cmd = ['/usr/local/autotest/contrib/db_cleanup.py', date]
  cros_build_lib.SudoRunCommand(cmd)


def ClearLogs():
  """Deletes old log files."""
  logdir = '/var/log'
  oldlog = r'^.*\.[0-9]+$'

  files_to_remove = []

  for curdir, _, files in os.walk(logdir):
    for f in files:
      if re.match(oldlog, f):
        files_to_remove.append(os.path.join(curdir, f))

  if files_to_remove:
    cmd = ['rm'] + files_to_remove
    cros_build_lib.SudoRunCommand(cmd)


#
# Upstart service actions.
#
def LaunchUpstartServiceWrapper(service):
  """Wrapper for bringing up an upstart job.

  Args:
    service: The name of service we are trying to start.
  """
  def LaunchUpstartService():
    """Launch the upstart service."""
    cmd = ['start', service]
    cros_build_lib.SudoRunCommand(cmd)

  return LaunchUpstartService
