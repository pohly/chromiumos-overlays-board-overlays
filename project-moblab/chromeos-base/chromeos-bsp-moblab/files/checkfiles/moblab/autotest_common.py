#!/usr/bin/python
#
# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""A helper module to set up sys.path so that autotest_lib.* can be located."""

# pylint: disable=F0401

import os
import re
import sys

import common   # pylint:disable=W0611


def InCrOSDevice():
  """Returns True if running on a Chrome OS device."""
  if not os.path.exists('/etc/lsb-release'):
    return False
  with open('/etc/lsb-release') as f:
    lsb_release = f.read()
  return re.match(r'^CHROMEOS_RELEASE', lsb_release, re.MULTILINE) is not None


def import_autotest():
  if InCrOSDevice():
    autotest_dir = '/usr/local/autotest'
  else:
    CROS_WORKON_SRCROOT = os.environ['CROS_WORKON_SRCROOT']
    autotest_dir = os.path.join(
          CROS_WORKON_SRCROOT, 'src', 'third_party', 'autotest', 'files')

  if os.path.isdir(autotest_dir):
    oldpath = sys.path[:]
    sys.path.insert(0, os.path.join(autotest_dir, 'client'))
    import setup_modules
    sys.path.pop(0)
    setup_modules.setup(base_path=autotest_dir, root_module_name='autotest_lib')
    try:
      from autotest_lib.site_utils import cloud_console_client
      from autotest_lib.client.common_lib import global_config
      return True
    except ImportError:
      #The autotest is not ready yet
      sys.path = oldpath
    return False

import_autotest()
