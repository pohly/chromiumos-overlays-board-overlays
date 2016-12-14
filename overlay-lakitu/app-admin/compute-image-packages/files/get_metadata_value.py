#!/usr/bin/python
# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""A helper script to read a metadata key.

Prints out the instance metadata if present, or project metadata otherwise. This
makes use of the Metadata Watcher library from the Compute Image Packages:
https://github.com/wonderfly/compute-image-packages#metadata-watcher.

Run `get_metadata_value -h` for usage.

Note that this script only reads instance/project Custom Metadata, i.e., the
'attributes/' field of the full metadata payload:
https://cloud.google.com/compute/docs/storing-retrieving-metadata#custom. Trying
to use it to get other fields such as 'disks/' will result in a failure.

Return codes: 0 if successfully retrieved the metadata, and non-0 otherwise.
"""

from __future__ import print_function

import argparse
import errno
import logging
import sys

from google_compute_engine.compat import urlerror
from google_compute_engine import metadata_watcher


def GetMetadata(watcher, key):
  """Reads a metadata key.

  Args:
    watcher: A metadata_watcher object.
    key: The key of metadata to read.

  Returns:
    Value of the metadata key, or None if not found.
  """
  try:
    instance_data = watcher.GetMetadata('instance/attributes/%s' % key,
                                        recursive=False)
  except urlerror.HTTPError:
    instance_data = None

  if instance_data:
    return instance_data

  try:
    return watcher.GetMetadata('project/attributes/%s' % key, recursive=False)
  except urlerror.HTTPError:
    return None


def main(argv):
  parser = argparse.ArgumentParser(description=__doc__)
  parser.add_argument('key', help='The metadata key to query')
  args = parser.parse_args(argv)

  watcher = metadata_watcher.MetadataWatcher()
  value = GetMetadata(watcher, args.key)
  if value is not None:
    print(value)
  else:
    logging.warning('Metadata key was not found: %s' % args.key)
    sys.exit(errno.EINVAL)


if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
