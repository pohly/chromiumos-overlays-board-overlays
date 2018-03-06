#!/bin/sh
logger -t pci-rescan "wifi NIC disappeared from PCI"
metrics_client -e Platform.WiFiDisapppearedFromPCI 1 2
