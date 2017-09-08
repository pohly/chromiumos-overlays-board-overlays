#!/bin/sh
# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This script is meant to be run as an OCI runtime config hook. See docs
# at https://github.com/opencontainers/runtime-spec/blob/master/config.md#posix-platform-hooks
# Most importantly, the state of the container must be passed to the script
# on stdin as described in the OCI runtime spec.
#
# This will set up a veth pair suitable for a single container in a VM.
# Outbound traffic is NAT'd. Inbound traffic may be routed to the container
# automatically unless it belongs to an established connection (i.e. ssh)
# to the VM.

set -eu

CHILD_PID=$(awk '/"pid": / { match($0, /[0-9]+/); print substr($0, RSTART, RLENGTH) }')

HOST_DEVICE="veth_${CHILD_PID}"
CONTAINER_DEVICE="container_${CHILD_PID}"
HOST_IP=10.1.1.1
CONTAINER_IP=10.1.1.2
NETMASK=30
BROADCAST_IP=10.1.1.3

# Create a veth pair and configure the host side.
ip link add "${HOST_DEVICE}" type veth peer name "${CONTAINER_DEVICE}"
ip link set "${HOST_DEVICE}" up
ip addr add "${HOST_IP}/${NETMASK}" \
  broadcast "${BROADCAST_IP}" dev "${HOST_DEVICE}"

# Forward "unclaimed" packets to the container to allow inbound connections.
iptables -t nat -N dnat_container -w
iptables -t nat -A dnat_container -j DNAT --to-destination ${CONTAINER_IP} -w
iptables -t nat -N try_container -w
iptables -t nat -A try_container -i eth0 -j dnat_container -w
iptables -t nat -A PREROUTING -m socket --nowildcard -j ACCEPT -w
iptables -t nat -A PREROUTING -p tcp -j try_container -w
iptables -t nat -A PREROUTING -p udp -j try_container -w

iptables -A FORWARD -i "${HOST_DEVICE}" -o eth0 \
    -m state --state RELATED,ESTABLISHED -j ACCEPT -w
iptables -A FORWARD -i "${HOST_DEVICE}" -o eth0 -j ACCEPT -w
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -w

sysctl net.ipv4.ip_forward=1

# Move the container veth into the network namespace, and configure the
# interface.
ip link set "${CONTAINER_DEVICE}" netns "${CHILD_PID}" name container0 up
nsenter -t "${CHILD_PID}" --net -- \
  ip addr add "${CONTAINER_IP}/${NETMASK}" \
  broadcast "${BROADCAST_IP}" dev container0
nsenter -t "${CHILD_PID}" --net -- \
  ip route add default via "${HOST_IP}" dev container0
nsenter -t "${CHILD_PID}" --net -- \
  ip link set lo up
