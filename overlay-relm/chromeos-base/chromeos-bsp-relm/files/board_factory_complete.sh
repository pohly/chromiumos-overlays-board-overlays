#!/bin/bash
#
# Copyright (c) 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This script makes shopfloor call to relm_shopfloor to inform shopfloor
# server that this machine has finished all factory flow.

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
  echo "!!!!!  $1  !!!!!" >"${TTY}"
  sleep 365d
  exit 1

}

MLB_SN=$(vpd -g mlb_serial_number)
if [ "${MLB_SN}" = "" ]; then
  die_with_error_message "mlb serial number is not in ro vpd"
else
  echo "MLB_SN = ${MLB_SN}"
fi

SN=$(vpd -g serial_number)
if [ "${SN}" = "" ]; then
  die_with_error_message "serial number is not in ro vpd"
else
  echo "SN = ${SN}"
fi

HWID=$(crossystem hwid)
if [ "${HWID}" = "" ]; then
  die_with_error_message "HWID is not in crossystem"
else
  echo "HWID = ${HWID}"
fi

UBIND=$(vpd -i RW_VPD -g ubind_attribute)
if [ "${UBIND}" = "" ]; then
  die_with_error_message "registration code is not in rw vpd"
else
  echo "UBIND = ${UBIND}"
fi

GBIND=$(vpd -i RW_VPD -g gbind_attribute)
if [ "${GBIND}" = "" ]; then
  die_with_error_message "group code is not in rw vpd"
else
  echo "GBIND = ${GBIND}"
fi

if [ -e /sys/class/net/mlan0/address ]; then
  WL_MAC=$(cat /sys/class/net/mlan0/address | sed 's/://g')
else
  WL_MAC=$(cat /sys/class/net/wlan0/address | sed 's/://g')
fi

if [ "${WL_MAC}" = "" ]; then
  die_with_error_message "MAC address not found"
else
  echo "WL_MAC = ${WL_MAC}"
fi

BT_MAC=$(cat /sys/class/bluetooth/hci0/address | sed 's/://g')
if [ "${BT_MAC}" = "" ]; then
  die_with_error_message "cannot get bluetooth macid"
else
  echo "BT_MAC = ${BT_MAC}"
fi

BIOS=`crossystem fwid`
if [ "${BIOS}" = "" ]; then
  die_with_error_message "cannot get BIOS"
else
  echo "BIOS = ${BIOS}"
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
        <param><value><string>${BT_MAC}</string></value></param>
        <param><value><string>${BIOS}</string></value></param>
    </params>
</methodCall>
EOF

test_lsb_dir="/mnt/stateful_partition/dev_image/etc"
test_lsb_file="${test_lsb_dir}/lsb-factory"
if [ ! -e ${test_lsb_file} ]; then
  echo "Created file: ${test_lsb_file}"
  mkdir -p -m 0600 ${test_lsb_dir}
  touch ${test_lsb_file}
  chmod 0600 ${test_lsb_file}
fi

SHOPFLOORSERVER_URL=$(grep -E "FACTORY_SHOPFLOOR" ${test_lsb_file} |
                    grep -Eo "http.+" || true)
echo "Calling shopfloor server(FinishFQA)..."
sleep 3
echo "SHOPFLOOR= ${SHOPFLOORSERVER_URL}"
sleep 3
RESPONSE=$(wget -q --header='Content-Type: text/xml' \
           --post-file="${POST_FILE}" -O - "${SHOPFLOORSERVER_URL}")
WGET_RC=$?
echo "RESPONSE= ${RESPONSE}"
sleep 3

if [ "${WGET_RC}" != "0" ]; then
  die_with_error_message "Can't connect to server ${SHOPFLOORSERVER_URL}"
fi

echo "${RESPONSE}" | grep "fault"

if [ "$?" = "0" ]; then
  die_with_error_message "Shopfloor call(FinishFQA) failed with response ${RESPONSE}"
  exit 1
fi

#sleep 3
# This is for 45 station again
#POST_FILE="/tmp/shopfloor_call_45.xml"
#cat > "${POST_FILE}" << EOF
#<?xml version='1.0'?>
#<methodCall>
#    <methodName>FinishFA2</methodName>
#    <params>
#        <param><value><string>${MLB_SN}</string></value></param>
#        <param><value><string>${SN}</string></value></param>
#        <param><value><string>${HWID}</string></value></param>
#        <param><value><string>${UBIND}</string></value></param>
#        <param><value><string>${GBIND}</string></value></param>
#        <param><value><string>${WL_MAC}</string></value></param>
#        <param><value><string>${BT_MAC}</string></value></param>
#        <param><value><string>${BIOS}</string></value></param>
#    </params>
#</methodCall>
#EOF

#echo "Calling shopfloor server(FinishFA2)..."
#sleep 3

#RESPONSE=$(wget -q --header='Content-Type: text/xml' \
#           --post-file="${POST_FILE}" -O - "${SHOPFLOORSERVER_URL}")
#WGET_RC=$?
#echo "RESPONSE= ${RESPONSE}"
#sleep 3

#if [ "${WGET_RC}" != "0" ]; then
#  die_with_error_message "Can't connect to server ${SHOPFLOORSERVER_URL}"
#fi

#echo "${RESPONSE}" | grep "fault"
#if [ "$?" = "0" ]; then
#  die_with_error_message "Shopfloor call(FinishFA2) failed with response ${RESPONSE}"
#  exit 1
#fi

ply-image --clear 0x000000 "${IMG_PATH}/shopfloor_call_done.png"
echo "OK2SHIP"
