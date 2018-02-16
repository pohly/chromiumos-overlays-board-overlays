# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# Configures logging of network connections from iptables.

iptables -t mangle -A POSTROUTING -o eth0 -p tcp -m tcp --syn -j CONNMARK --set-mark 1 -w
iptables -t mangle -A POSTROUTING -o eth0 -p tcp -m tcp --syn -j LOG -w --log-level debug
iptables -t mangle -A POSTROUTING -o eth0 -p udp -j LOG -w --log-level debug
iptables -t mangle -A POSTROUTING -o eth0 -p icmp -j LOG -w --log-level debug
iptables -t mangle -A POSTROUTING -o eth0 -p tcp -m connmark --mark 1 -m tcp --tcp-flags FIN FIN -j LOG -w --log-level debug
iptables -t mangle -A POSTROUTING -o eth0 -p tcp -m connmark --mark 1 -m tcp --tcp-flags RST RST -j LOG -w --log-level debug
