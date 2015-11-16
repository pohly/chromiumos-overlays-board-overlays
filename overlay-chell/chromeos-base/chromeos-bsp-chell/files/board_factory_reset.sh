#!/bin/bash
#
# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This script makes shopfloor call to kip_shopfloor to inform shopfloor
# server that this machine has finished all factory flow.

. "/opt/google/memento_updater/find_omaha.sh"

DISPLAY_MESSAGE="/usr/local/factory/sh/display_wipe_message.sh"
INFORM_SHOPFLOOR="/usr/local/factory/sh/inform_shopfloor.sh"

TTY="/dev/tty1"

if [ "$(findLSBValue FACTORY_COMPLETE)" != "true" ]; then
    exit
fi

SHOPFLOOR_URL="$(findLSBValue FACTORY_SHOPFLOOR)"

die_with_error_message() {
  "${DISPLAY_MESSAGE}" "inform_shopfloor_failed"
  echo "$@" > "${TTY}"
  exit 1
}

MLB_SN="$(vpd -g mlb_serial_number)"
if [ "${MLB_SN}" = "" ]; then
  die_with_error_message "mlb serial number is not in ro vpd"
fi

SN="$(vpd -g serial_number)"
if [ "${SN}" = "" ]; then
  die_with_error_message "serial number is not in ro vpd"
fi

HWID="$(crossystem hwid)"
if [ "${HWID}" = "" ]; then
  die_with_error_message "HWID is not in crossystem"
fi

UBIND="$(vpd -i RW_VPD -g ubind_attribute)"
if [ "${UBIND}" = "" ]; then
  die_with_error_message "registration code is not in rw vpd"
fi

GBIND="$(vpd -i RW_VPD -g gbind_attribute)"
if [ "${GBIND}" = "" ]; then
  die_with_error_message "group code is not in rw vpd"
fi

if [ -e /sys/class/net/mlan0/address ]; then
  WL_MAC="$(cat /sys/class/net/mlan0/address | sed 's/://g')"
else
  WL_MAC="$(cat /sys/class/net/wlan0/address | sed 's/://g')"
fi
if [ "${WL_MAC}" = "" ]; then
  die_with_error_message "MAC address not found"
fi

# This is for D2 station
POST_FILE="$(mktemp)"
cat > "${POST_FILE}" << EOF
<?xml version='1.0'?>
<methodCall>
    <methodName>FinishFQA</methodName>
    <params>
        <param><value><string>${MLB_SN}</string></value></param>
        <param><value><string>${SN}</string></value></param>
        <param><value><string>${WL_MAC}</string></value></param>
    </params>
</methodCall>
EOF

"${INFORM_SHOPFLOOR}" "${SHOPFLOOR_URL}" "${POST_FILE}"

# This is for 45 station again
cat > "${POST_FILE}" << EOF
<?xml version='1.0'?>
<methodCall>
    <methodName>FinishFA2</methodName>
    <params>
        <param><value><string>${MLB_SN}</string></value></param>
        <param><value><string>${SN}</string></value></param>
        <param><value><string>${HWID}</string></value></param>
        <param><value><string>${UBIND}</string></value></param>
        <param><value><string>${GBIND}</string></value></param>
        <param><value><string>${WL_MAC}</string></value></param>
    </params>
</methodCall>
EOF

"${INFORM_SHOPFLOOR}" "${SHOPFLOOR_URL}" "${POST_FILE}"
