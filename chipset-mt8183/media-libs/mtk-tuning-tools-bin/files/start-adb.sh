#!/bin/sh

echo "device" > /sys/kernel/debug/usb/11201000.usb/mode
mkdir /sys/kernel/config/usb_gadget/g1
echo "0x0e8d" > /sys/kernel/config/usb_gadget/g1/idVendor
echo "0x201c" > /sys/kernel/config/usb_gadget/g1/idProduct
mkdir /sys/kernel/config/usb_gadget/g1/strings/0x409
echo "0123456789ABCDEF" > /sys/kernel/config/usb_gadget/g1/strings/0x409/serialnumber
echo "Mediatek Inc." > /sys/kernel/config/usb_gadget/g1/strings/0x409/manufacturer
echo "Adb gadget" > /sys/kernel/config/usb_gadget/g1/strings/0x409/product
mkdir /sys/kernel/config/usb_gadget/g1/functions/ffs.adb
mkdir /sys/kernel/config/usb_gadget/g1/configs/c.1
mkdir /sys/kernel/config/usb_gadget/g1/configs/c.1/strings/0x409
echo "adb" > /sys/kernel/config/usb_gadget/g1/configs/c.1/strings/0x409/configuration
ln -s /sys/kernel/config/usb_gadget/g1/functions/ffs.adb /sys/kernel/config/usb_gadget/g1/configs/c.1
mkdir /dev/usb-ffs
mkdir /dev/usb-ffs/adb
mount -o uid=2000,gid=2000 -t functionfs adb /dev/usb-ffs/adb
/usr/bin/adbd &
echo "sleep 2 second"
sleep 2
echo "11201000.usb" > /sys/kernel/config/usb_gadget/g1/UDC
mount -o remount,rw /
