#!/bin/bash
#
# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This script makes shopfloor call to enguarde_shopfloor to inform shopfloor
# server that this machine has finished all factory flow.
. "/opt/google/memento_updater/find_omaha.sh"

TTY="/dev/tty1"
IMG_PATH="/usr/share/factory/images"

# Change color in tty1 by ANSI escape sequence code
colorize() {
  local code="$1"
  case "${code}" in
    "red" )
      code="1;31"
      ;;
    "green" )
      code="1;32"
      ;;
    "yellow" )
      code="1;33"
      ;;
  esac
  printf "\033[%sm" "${code}" >"${TTY}"
}

die_with_error_message() {
  echo "$1"
  colorize "red"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >"${TTY}"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >"${TTY}"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >"${TTY}"
  echo "!!  $1  !!" >"${TTY}"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >"${TTY}"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >"${TTY}"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >"${TTY}"
  sleep 365d
  exit 1

}

MLB_SN=$(vpd -g mlb_serial_number)
if [ "${MLB_SN}" = "" ]; then
  die_with_error_message "mlb serial number is not in ro vpd"
fi

SN=$(vpd -g serial_number)
if [ "${SN}" = "" ]; then
  die_with_error_message "serial number is not in ro vpd"
fi

HWID=$(crossystem hwid)
if [ "${HWID}" = "" ]; then
  die_with_error_message "HWID is not in crossystem"
fi

UBIND=$(vpd -i RW_VPD -g ubind_attribute)
if [ "${UBIND}" = "" ]; then
  die_with_error_message "registration code is not in rw vpd"
fi

GBIND=$(vpd -i RW_VPD -g gbind_attribute)
if [ "${GBIND}" = "" ]; then
  die_with_error_message "group code is not in rw vpd"
fi

if [ -e /sys/class/net/mlan0/address ]; then
  WL_MAC=$(cat /sys/class/net/mlan0/address | sed 's/://g')
else
  WL_MAC=$(cat /sys/class/net/wlan0/address | sed 's/://g')
fi
if [ "${WL_MAC}" = "" ]; then
  die_with_error_message "MAC address not found"
fi

ply-image --clear 0x000000 "${IMG_PATH}/connect_ethernet.png"

until (ifconfig eth0 | grep -q 'inet') ; do
  sleep 2;
done

ply-image --clear 0x000000 "${IMG_PATH}/call_shopfloor.png"

# This is for D2 station
POST_FILE="/tmp/shopfloor_call.xml"
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

test_lsb_dir="/mnt/stateful_partition/dev_image/etc"
test_lsb_file="${test_lsb_dir}/lsb-factory"

if [ -e ${test_lsb_file} ]; then
  SHOPFLOORSERVER_URL="$(findLSBValue FACTORY_SHOPFLOOR)"
else
  die_with_error_message "Can't find ${test_lsb_file}."
fi

echo "Calling shopfloor server(FinishFQA)..."
echo "SHOPFLOOR= ${SHOPFLOORSERVER_URL}"
RESPONSE=$(wget -q --header='Content-Type: text/xml' \
           --post-file="${POST_FILE}" -O - "${SHOPFLOORSERVER_URL}")
WGET_RC=$?
echo "RESPONSE= ${RESPONSE}"
if [ "${WGET_RC}" != "0" ]; then
  die_with_error_message "Can't connect to server ${SHOPFLOORSERVER_URL}"
fi
echo "${RESPONSE}" | grep "fault"
if [ "$?" = "0" ]; then
  die_with_error_message "Shopfloor call(FinishFQA) failed with response ${RESPONSE}"
  exit 1
fi

sleep 3
# This is for 45 station again
POST_FILE="/tmp/shopfloor_call_45.xml"
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
echo "Calling shopfloor server(FinishFA2)..."
RESPONSE=$(wget -q --header='Content-Type: text/xml' \
           --post-file="${POST_FILE}" -O - "${SHOPFLOORSERVER_URL}")
WGET_RC=$?
echo "RESPONSE= ${RESPONSE}"
if [ "${WGET_RC}" != "0" ]; then
  die_with_error_message "Can't connect to server ${SHOPFLOORSERVER_URL}"
fi
echo "${RESPONSE}" | grep "fault"
if [ "$?" = "0" ]; then
  die_with_error_message "Shopfloor call(FinishFA2) failed with response ${RESPONSE}"
  exit 1
fi

ply-image --clear 0x000000 "${IMG_PATH}/shopfloor_call_done.png"
echo "OK2SHIP"
