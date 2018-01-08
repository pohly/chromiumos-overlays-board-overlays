# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Ensure essential moblab services are up and running."""

from __future__ import print_function

import moblab_actions

import os

from chromite.lib import cros_build_lib
from chromite.lib import cros_logging as logging


LOGGER = logging.getLogger(__name__)


def UpstartExists(service):
  """Test if an upstart script for |service| exists on moblab.

  Returns:
    True if the upstart script for |service| exists.
    False if it does not.
  """
  _, ext = os.path.splitext(service)
  if not ext:
    service = os.extsep.join([service, 'conf'])
  return os.path.exists(os.path.join('/etc/init', service))


def UpstartRunning(service):
  """Test if |service| is running on moblab.

  Returns:
    True if the upstart job |service| is in 'start/running' state.
    False otherwise.
  """
  cmd = ['status', service]
  output = cros_build_lib.SudoRunCommand(
      cmd, error_code_ok=True, capture_output=True).output.strip()

  if 'start/running' in output:
    return True

  return False


def ServiceRunning(service):
  """Test if |service| is running on moblab.

  Returns:
    True if |service| is running.
    False otherwise.
  """
  cmd = ['ps', 'aux']
  output = cros_build_lib.RunCommand(
      cmd, error_code_ok=True, capture_output=True).output.strip()

  for line in output.splitlines():
    if service in line:
      return True

  return False


class UpstartServiceRunning(object):
  """Helper class for verifying that moblab services are up and running."""

  SERVICES = []

  def Check(self):
    """Verfies this service is running.

    Returns:
      0 if all SERVICES is running.
      -(i+1) if SERVICE with index i is not running.
    """
    LOGGER.info('Checking services: %s', self.SERVICES)
    for i, x in enumerate(self.SERVICES):
      if not UpstartRunning(x):
        return -(i+1)

    return 0

  def Diagnose(self, errcode):
    if errcode and self.SERVICES:
      index = -1*errcode - 1
      service = self.SERVICES[index]
      return ('Essential moblab service "%s" is not running.'
              ' Please launch the service.' % service,
              [moblab_actions.LaunchUpstartServiceWrapper(service)])

    return ('Unknown error reached with error code: %s' % errcode, [])


class GsOffloaderRunning(UpstartServiceRunning):
  """Verifies that gs_offloader is running."""

  SERVICES = ['moblab-gsoffloader-init', 'moblab-gsoffloader_s-init']


class SchedulerRunning(UpstartServiceRunning):
  """Verifies that scheduler is running."""

  SERVICES = ['moblab-scheduler-init']


class DevserverRunning(UpstartServiceRunning):
  """Verifies that devserver is running."""

  SERVICES = ['moblab-devserver-init', 'moblab-devserver-cleanup-init']


class DatabaseRunning(UpstartServiceRunning):
  """Verifies that database is up."""

  SERVICES = ['moblab-database-init']


class JobAborterRunning(UpstartServiceRunning):
  """Verifies that job_aborter is up."""

  SERVICES = ['autotest-job-aborter']


class ApacheUpstartRunning(UpstartServiceRunning):
  """Verifies that apache is running."""

  SERVICES = ['moblab-apache-init']
  SERVICE_SEARCH = 'apache'

  def Check(self):
    """Verifies that apache is running on moblab.

    Returns:
      0 if apache is running.
      -1 if apache is not running.
    """
    if not ServiceRunning(self.SERVICE_SEARCH):
      return -1

    return 0


class DhcpUpstartRunning(UpstartServiceRunning):
  """Verifies that dhcp is running."""

  SERVICES = ['moblab-network-init', 'moblab-network-bridge-init']
  SERVICE_SEARCH = 'dhcpcd'

  def Check(self):
    """Verfies that dhcp is running on moblab.

    Returns:
      0 if dhcp is up.
      -1 if dhcp is down and moblab-network-init is installed on moblab.
      -2 if dhcp is down and moblab-network-bridge-init is installed on moblab.
    """
    if not ServiceRunning(self.SERVICE_SEARCH):
      # DHCP is down. We need to figure which upstart script will
      # correct the issue for this moblab.
      for i, x in enumerate(self.SERVICES):
        if UpstartExists(x):
          return -(i+1)

    return 0
