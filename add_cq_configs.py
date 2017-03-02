#!/usr/bin/env python2
# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Update COMMIT-QUEUE.ini in overlay and baseboard subdirectories.

See www.chromium.org/chromium-os/build/bypassing-tests-on-a-per-project-basis
for context.
"""

import glob
import os
import sys

_TEMPLATE = """# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Per-project Commit Queue settings.
# Documentation: http://goo.gl/5J7oND

[GENERAL]

# Board-specific pre-cq
pre-cq-configs: %s-pre-cq"""

def main(argv=()):
  for d in glob.glob('overlay-*'):
    ini_file = os.path.join(d, 'COMMIT-QUEUE.ini')
    if os.path.exists(ini_file):
      print 'Config exists, skipping %s' % d
      continue
    if 'variant' in d:
      b = d[len('overlay-variant-'):]
    else:
      b = d[len('overlay-'):]
    if '-' in b:
      print ('Too many "-" characters to determine correct config for %s,'
             ' consider adding config manually.' % d)
      continue
    with open(ini_file, 'w') as f:
      f.write(_TEMPLATE % b)
    print 'Added config %s to directory %s' % (b, d)

  for d in glob.glob('baseboard-*'):
    ini_file = os.path.join(d, 'COMMIT-QUEUE.ini')
    if os.path.exists(ini_file):
      print 'Config exists, skipping %s' % d
      continue
    b = d[len('baseboard-'):]
    with open(ini_file, 'w') as f:
      f.write(_TEMPLATE % b)
    print 'Added config %s to directory %s' % (b, d)


if __name__ == '__main__':
  sys.exit(main())
