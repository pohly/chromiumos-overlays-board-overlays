# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# Configures logging of execve syscalls.

auditctl -a always,exit -F arch=b64 -S execve
auditctl -a always,exit -F arch=b32 -S execve

dont_exclude EXECVE
dont_exclude SYSCALL
