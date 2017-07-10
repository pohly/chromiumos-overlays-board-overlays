# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# Monitor socket families, exclude AF_UNSPEC(0), AF_LOCAL(1), AF_INET(2),
# AF_INET6(10), AF_NETLINK(16) and AF_PACKET(17).
auditctl -a exit,always -F arch=b64 -S socket -F success=1 -F a0!=0 -F a0!=1 -F a0!=2 -F a0!=10 -F a0!=16 -F a0!=17 -k funky_socket

dont_exclude SYSCALL
