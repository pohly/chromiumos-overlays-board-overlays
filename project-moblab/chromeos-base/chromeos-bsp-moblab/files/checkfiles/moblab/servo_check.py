# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Servo health checks for moblab."""

from __future__ import print_function

from chromite.lib import cros_build_lib

SERVO_VID = '18d1'
SERVO_PID = '5002'


class ServoExists(object):
  """Verfies that a Servo is connected to moblab."""

  def Check(self):
    """Verify that a Servo is connected.

    Returns:
      0 if a Servo exists.
      1 if a Servo device could not be found.
    """
    cmd = ['lsusb']
    servo_id = '%s:%s' % (SERVO_VID, SERVO_PID)
    usbs = cros_build_lib.SudoRunCommand(cmd, log_output=True).output.strip()
    for usb in usbs.split('\n'):
      if servo_id in usb:
        return 0
    return 1

  def Diagnose(self, errcode):
    if 1 == errcode:
      return ('No servo devices are connected.', [])

    return ('Unknown error reached with error code: %s' % errcode, [])
