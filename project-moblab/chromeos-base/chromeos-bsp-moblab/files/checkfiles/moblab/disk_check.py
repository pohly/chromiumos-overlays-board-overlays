# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Disk monitoring health checks for moblab."""

from __future__ import print_function

import copy

import moblab_actions
import common

from chromite.lib import cros_build_lib
from chromite.mobmonitor.system import systeminfo


class DiskDevices(object):
  """Verifies that disks on moblab are set up correctly."""

  DISK_INFO_VALID_SEC = 5

  def __init__(self):
    self.diskinfo = systeminfo.GetDisk(self.DISK_INFO_VALID_SEC)
    self.useable_usbs = []

  def CheckStateful(self):
    """Helper check function for verifying the stateful partition.

    Returns:
      0 if a sufficient stateful partition is exists.
      -1 if no devices are found to be mounted at STATEFUL_MOUNTPOINT.
      -2 if the stateful partition is too small.
    """
    diskpart = None
    for part in self.diskinfo.DiskPartitions():
      if part.mountpoint == common.STATEFUL_MOUNTPOINT:
        diskpart = part

    if not diskpart:
      return -1

    diskusage = self.diskinfo.DiskUsage(diskpart.mountpoint)
    if diskusage.total < common.DISK_SIZE_BYTES:
      return -2

    return 0

  def CheckUsb(self):
    """Helper check function for verifying an adequate USB drive exists.

    Returns:
      0 if a sufficient USB drive is exists.
      -3 if no USB devices are found on the system.
      -4 if no USB device is found to be of the appropriate size.
      -5 if no USB device is found to be appropriately labelled.
      -6 if no USB device is found to be formatted correctly.
      -7 if no USB device is found to be mounted correctly.
    """
    # Get a list of all usb block devices.
    usbs = [db for db in self.diskinfo.BlockDevices()
            if any(x.startswith('usb') for x in db.ids)]

    if not usbs:
      return -3

    # Get all well-sized usb block devices.
    usbs = [usb for usb in usbs if usb.size >= common.DISK_SIZE_BYTES]

    if not usbs:
      return -4

    # Get all well-labelled usb block devices.
    self.useable_usbs = copy.copy(usbs)
    usbs = [usb for usb in usbs
            if any(x == common.MOBLAB_LABEL for x in usb.labels)]

    if not usbs:
      return -5

    # Get all usbs formatted with the correct filesystem.
    self.useable_usbs = copy.copy(usbs)
    usbs = []
    for usb in self.useable_usbs:
      cmd = ['file', '-L', '-s', usb.device]
      output = cros_build_lib.SudoRunCommand(
          cmd, error_code_ok=True, capture_output=True).output.strip()
      if common.MOBLAB_FILESYSTEM in output:
        usbs.append(usb)

    if not usbs:
      return -6

    # Get a list of mounts on this system and check if we have a usb
    # mounted in the correctly.
    self.useable_usbs = copy.copy(usbs)
    mounts = self.diskinfo.DiskPartitions()
    usbs = [usb for usb in usbs
            if any(x.devicename == usb.device
                   and x.filesystem == common.MOBLAB_FILESYSTEM
                   for x in mounts)]

    if not usbs:
      return -7

    # Looks like an adequate usb device exists!
    return 0

  def Check(self):
    """Verifies that disk devices are setup correctly on this moblab.

    Appropriate storage space may be satisfied by one of the following
    conditions:

      (1) A partition exists that is:
            (i)   mounted at /mnt/stateful_partition
            (ii)  >32GB in size

      (2) A USB drive exists that is:
            (i)   mounted at /mnt/moblab
            (ii)  labelled MOBLAB-STORAGE
            (iii) >32GB in size

    Returns:
      0 if this moblab has appropriate disk space.
    """
    stateful_check = self.CheckStateful()
    usb_check = self.CheckUsb()

    if any(not x for x in [stateful_check, usb_check]):
      return 0

    if -3 == usb_check:
      return stateful_check

    return usb_check

  def Diagnose(self, errcode):
    if -1 == errcode:
      return ('Critical error. No stateful partition was detected.', [])

    elif -2 == errcode or -3 == errcode:
      return ('Moblab internal storage is too small. Please insert'
              ' a USB drive that is at least 32GB in size.', [])

    elif -4 == errcode:
      return ('All detected USB drives are too small. Please insert'
              ' a USB drive that is at least 32GB in size.', [])

    elif -5 == errcode:
      return ('USB drive is not correctly labelled.'
              ' Please review the setup instructions and label'
              ' your USB drive.',
              [])

    elif -6 == errcode:
      return ('USB drive is not formatted correctly.'
              ' Please review the setup instructions and format'
              ' your USB drive',
              [])

    elif -7 == errcode:
      usb = self.useable_usbs[0]
      return ('USB drive is not mounted correctly.',
              [moblab_actions.MountUsbWrapper(usb.device)])

    return ('Unknown error reached with error code: %s' % errcode, [])


class DiskSpace(object):
  """Verifies that this moblab has enough remaining disk space."""

  DISK_INFO_VALID_SEC = 5

  def __init__(self):
    self.diskinfo = systeminfo.GetDisk(self.DISK_INFO_VALID_SEC)

  def Check(self):
    """Verifies that moblab has enough free disk space.

    Returns:
      0 if moblab has a sufficient amount of remaining disk space.
      -1 if the moblab has <DISK_FREE_THRESHOLD_PERCENT free disk space
        on either the moblab or stateful partition.
    """
    partitions = [common.MOBLAB_MOUNTPOINT, common.STATEFUL_MOUNTPOINT]
    for part in partitions:
      diskusage = self.diskinfo.DiskUsage(part)
      free = 1 - diskusage.percent_used / 100
      if free < common.DISK_FREE_THRESHOLD_PERCENT:
        return -1

    return 0

  def Diagnose(self, errcode):
    if -1 == errcode:
      return ('Moblab has less than %s percent free disk space. Please'
              ' free space to ensure proper functioning of your'
              ' moblab.' % int(common.DISK_FREE_THRESHOLD_PERCENT * 100),
              [moblab_actions.ClearOldDbRecords, moblab_actions.ClearLogs])

    return ('Unknown error reached with error code: %s' % errcode, [])
