# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Heartbeat health checks for moblab."""

from __future__ import print_function

import datetime
import os
from chromite.lib import cros_logging as logging

LOGGER = logging.getLogger(__name__)

_MIN_HEARTBEAT_RATE=10

import autotest_common

# Needs the following import for unittests.
try:
  from autotest_lib.site_utils import cloud_console_client
  from autotest_lib.client.common_lib import global_config
except ImportError:
  LOGGER.info('Autotest is not ready at loading.')

# Abstract how the cache file is configured.
def _GetHeartbeatCacheFile():
  return global_config.global_config.get_config_value(
        'CROS', 'heartbeat_cache_file', default='/mnt/moblab/.HEARTBEAT')

# Abstract how the rate is configured.
def _GetHeartbeatRate():
  return global_config.global_config.get_config_value(
        'CROS', 'heartbeat_rate_seconds', type=int, default=-1)

def _GetLastHeartbeatTimeFromFile():
  """Reads from the last heartbeat timestamp from cache file.

  @returns A datetime object.
  """
  cache_file = _GetHeartbeatCacheFile()
  if os.path.isfile(cache_file):
    try:
      f = open(cache_file, 'r')
      try:
        time_stamp = f.read()
        if time_stamp:
          return datetime.datetime.fromtimestamp(float(time_stamp))
      except ValueError:
        LOGGER.warning('The cache file contain bad timestamp')
      finally:
          f.close()
    except (IOError, OSError) as e:
      LOGGER.warning('Failed to open cache file to read.')

  return None


def _UpdateLastHeartbeatTime(time_stamp):
  """Update the cache file with new timestamp.

  @param time_stamp: A new timestamp as datetime.
  """
  cache_file = _GetHeartbeatCacheFile()
  try:
    f = open(cache_file, 'w')
    try:
      f.write(time_stamp.strftime('%s'))
    finally:
      f.close()
  except (IOError, OSError) as e:
    LOGGER.warning('Failed to open cache file to write.')


def _NeedHeartbeat(now, last, rate):
  """Rule for sending out hearbeat.

  @param now: The now datetime object.
  @param last: The datetime when last heartbeat is sent.
  @param rate: The rate in seconds the heartbeat should be sent.

  @returns True if heartbeat should be sent; otherwise, False.
  """
  if rate <= 0:
    return False
  return not last or (now - last).total_seconds() > rate


class Heartbeat(object):
  """Ensures that a heartbeat is sent out on time."""

  def Check(self):
    """Ensures that moblab sends out heartbeat on tmie.

    Returns:
      0 if heartbeat is out on time.
      -1 if cloud pubsub notificaiton is not enabled.
      -2 if a heartbeat could not be sent out on time.
      -3 if there is internal server error.
    """
    LOGGER.info('Start to check heartbeat')
    # Mobmonitor could run before the autotest setup is finished.
    # The /usr/local/autotest on moblab might not be created yet.
    try:
      from autotest_lib.site_utils import cloud_console_client
      from autotest_lib.client.common_lib import global_config
    except ImportError:
      LOGGER.info('Try to import autotest.')
      # The autotest is not ready yet
      if not autotest_common.import_autotest():
        LOGGER.warning('Autotest is not ready.')
      else:
        LOGGER.info('Autotest is ready now.')
      return -3

    heartbeat_rate = _GetHeartbeatRate()
    if heartbeat_rate <= _MIN_HEARTBEAT_RATE:
      LOGGER.info(
            'Skip heartbeat because rate is not set or set too small.')
      return 0

    if not cloud_console_client.is_cloud_notification_enabled():
      LOGGER.warning('Could not send heartbeat because pubub is not enabled.')
      return -1

    now = datetime.datetime.now()
    last_heartbeat = _GetLastHeartbeatTimeFromFile()
    if _NeedHeartbeat(now, last_heartbeat, heartbeat_rate):
      console_client = cloud_console_client.PubSubBasedClient()
      if console_client.send_heartbeat():
        _UpdateLastHeartbeatTime(now)
        LOGGER.info('Heartbeat is sent and recorded the timestamp.')
      else:
        LOGGER.warning('Failed to send Heartbeat.')
        return -2
    else:
        LOGGER.info('Skip heartbeat because previous one does not expire.')

    return 0

  def Diagnose(self, errcode):
    msg_1 = ('Heartbeat could not be sent because pubsub is not enabled. Make'
             'sure your moblab is set up appropriately. For more information '
             'please see https://www.chromium.org/chromium-os/testing/'
             'moblab/setup#TOC-Setting-up-the-boto-key-for-partners')

    msg_2 = ('Heartbeat could not be sent out on times. Make sure your moblab'
           ' is set up appropriately. For more information'
           ' please see https://www.chromium.org/chromium-os/testing/'
           'moblab/setup#TOC-Setting-up-the-boto-key-for-partners')

    msg_3 = ('Internal software installation error.')

    if -1 == errcode:
      return msg_1
    elif -2 == errcode:
      return msg_2
    elif -3 == errcode:
      return msg_3

    return ('Unknown error reached with error code: %s' % errcode, [])
