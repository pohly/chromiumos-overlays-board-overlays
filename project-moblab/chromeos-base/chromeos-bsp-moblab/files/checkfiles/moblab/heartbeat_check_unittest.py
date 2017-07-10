#!/usr/bin/env python2
# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Unit test for heartbeat_check.py"""

from __future__ import print_function

import datetime
import mox
import os
import tempfile
import unittest

import heartbeat_check
from autotest_lib.site_utils import cloud_console_client

class HeartbeatModuleTest(mox.MoxTestBase):
  """Unit test for heartbeat module."""

  def testGetLastHeartbeatTimeFromFile_NoFile(self):
    """Tests read timestamp when the  cahce file does not exists."""
    self.mox.StubOutWithMock(os.path, 'isfile')
    self.mox.StubOutWithMock(heartbeat_check, '_GetHeartbeatCacheFile')
    heartbeat_check._GetHeartbeatCacheFile().AndReturn('/tmp/.HEARTBEAT')
    os.path.isfile('/tmp/.HEARTBEAT').AndReturn(False)
    self.mox.ReplayAll()
    self.assertIsNone(heartbeat_check._GetLastHeartbeatTimeFromFile())
    self.mox.VerifyAll()

  def testHeartbeatCacheReadWrite(self):
    """Tests normal read/write from and to the cache file."""
    cache_file = tempfile.NamedTemporaryFile()
    self.mox.StubOutWithMock(heartbeat_check, '_GetHeartbeatCacheFile')
    heartbeat_check._GetHeartbeatCacheFile().MultipleTimes().AndReturn(
        cache_file.name)
    self.mox.ReplayAll()
    now = datetime.datetime.now()
    heartbeat_check._UpdateLastHeartbeatTime(now)
    dt  = heartbeat_check._GetLastHeartbeatTimeFromFile()
    self.assertTrue(abs((now -dt).total_seconds()) < 1)
    self.mox.VerifyAll()
    cache_file.close()

  def testNeedHeartbeatRule(self):
    """Tests the logic if a new heartbeat is needed."""
    now = datetime.datetime.now()
    dt1 = now + datetime.timedelta(seconds=-50)
    dt2 = now + datetime.timedelta(seconds=-70)

    self.assertFalse(heartbeat_check._NeedHeartbeat(now, None, 0))
    self.assertTrue(heartbeat_check._NeedHeartbeat(now, None, 60))
    self.assertFalse(heartbeat_check._NeedHeartbeat(now, dt1, 60))
    self.assertTrue(heartbeat_check._NeedHeartbeat(now, dt2, 60))


class HeartbeatTest(mox.MoxTestBase):
  """Unit test for Heartbeat class."""

  def testCheckWhenHeartbeatNotEnabled(self):
    """Check should returns 0 if heartbeat rate is set to 0."""
    heartbeat = heartbeat_check.Heartbeat()
    self.mox.StubOutWithMock(heartbeat_check, '_GetHeartbeatRate')
    heartbeat_check._GetHeartbeatRate().AndReturn(0)
    self.mox.ReplayAll()
    self.assertEquals(0, heartbeat.Check())
    self.mox.VerifyAll()

  def testCheckWhenHeartbeatPubsubNotEnabled(self):
    """Check should returns -1 if pusub is not enabled."""
    heartbeat = heartbeat_check.Heartbeat()
    self.mox.StubOutWithMock(heartbeat_check, '_GetHeartbeatRate')
    heartbeat_check._GetHeartbeatRate().AndReturn(60)
    self.mox.StubOutWithMock(cloud_console_client,
        'is_cloud_notification_enabled')
    cloud_console_client.is_cloud_notification_enabled().AndReturn(False)
    self.mox.ReplayAll()
    self.assertEquals(-1, heartbeat.Check())
    self.mox.VerifyAll()

  def testCheckWhenHeartbeatSkip(self):
    """Check should returns 0 if previous heartbeat not expire yet."""
    heartbeat = heartbeat_check.Heartbeat()
    self.mox.StubOutWithMock(heartbeat_check, '_GetHeartbeatRate')
    heartbeat_check._GetHeartbeatRate().AndReturn(60)
    self.mox.StubOutWithMock(cloud_console_client,
        'is_cloud_notification_enabled')
    cloud_console_client.is_cloud_notification_enabled().AndReturn(True)
    self.mox.StubOutWithMock(heartbeat_check,
        '_GetLastHeartbeatTimeFromFile')
    sometime = datetime.datetime.now()
    heartbeat_check._GetLastHeartbeatTimeFromFile().AndReturn(sometime)
    self.mox.StubOutWithMock(heartbeat_check, '_NeedHeartbeat')
    heartbeat_check._NeedHeartbeat(
            mox.IsA(datetime.datetime), sometime, 60).AndReturn(False)
    self.mox.ReplayAll()
    self.assertEquals(0, heartbeat.Check())
    self.mox.VerifyAll()


  def testCheckWhenHeartbeatFailedToSend(self):
    """Check should returns 0 if previous heartbeat not expire yet."""
    heartbeat = heartbeat_check.Heartbeat()
    self.mox.StubOutWithMock(heartbeat_check, '_GetHeartbeatRate')
    heartbeat_check._GetHeartbeatRate().AndReturn(60)
    self.mox.StubOutWithMock(cloud_console_client,
        'is_cloud_notification_enabled')
    cloud_console_client.is_cloud_notification_enabled().AndReturn(True)
    self.mox.StubOutWithMock(heartbeat_check,
        '_GetLastHeartbeatTimeFromFile')
    sometime = datetime.datetime.now()
    heartbeat_check._GetLastHeartbeatTimeFromFile().AndReturn(sometime)
    self.mox.StubOutWithMock(heartbeat_check, '_NeedHeartbeat')
    heartbeat_check._NeedHeartbeat(
            mox.IsA(datetime.datetime), sometime, 60).AndReturn(True)
    console_client = self.mox.CreateMock(
            cloud_console_client.PubSubBasedClient)
    self.mox.StubOutWithMock(cloud_console_client, 'PubSubBasedClient')
    cloud_console_client.PubSubBasedClient().AndReturn(console_client)
    console_client.send_heartbeat().AndReturn(False)
    self.mox.ReplayAll()
    self.assertEquals(-2, heartbeat.Check())
    self.mox.VerifyAll()

  def testCheckWhenHeartbeatIsSent(self):
    """Check should returns 0 if previous heartbeat not expire yet."""
    heartbeat = heartbeat_check.Heartbeat()
    self.mox.StubOutWithMock(heartbeat_check, '_GetHeartbeatRate')
    heartbeat_check._GetHeartbeatRate().AndReturn(60)
    self.mox.StubOutWithMock(cloud_console_client,
        'is_cloud_notification_enabled')
    cloud_console_client.is_cloud_notification_enabled().AndReturn(True)
    self.mox.StubOutWithMock(heartbeat_check,
        '_GetLastHeartbeatTimeFromFile')
    sometime = datetime.datetime.now()
    heartbeat_check._GetLastHeartbeatTimeFromFile().AndReturn(sometime)
    self.mox.StubOutWithMock(heartbeat_check, '_NeedHeartbeat')
    heartbeat_check._NeedHeartbeat(
            mox.IsA(datetime.datetime), sometime, 60).AndReturn(True)
    console_client = self.mox.CreateMock(
            cloud_console_client.PubSubBasedClient)
    self.mox.StubOutWithMock(cloud_console_client, 'PubSubBasedClient')
    cloud_console_client.PubSubBasedClient().AndReturn(console_client)
    console_client.send_heartbeat().AndReturn(True)
    self.mox.StubOutWithMock(heartbeat_check,
        '_UpdateLastHeartbeatTime')
    heartbeat_check._UpdateLastHeartbeatTime(mox.IsA(datetime.datetime))
    self.mox.ReplayAll()
    self.assertEquals(0, heartbeat.Check())
    self.mox.VerifyAll()


if __name__ == '__main__':
  unittest.main()
