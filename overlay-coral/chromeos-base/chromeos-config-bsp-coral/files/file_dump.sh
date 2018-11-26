#!/bin/sh
for path in /etc/cras /usr/share/alsa/ucm /etc/dptf /etc/bluetooth /usr/share/power_manager; do
	for file in $(find "/build/coral${path}" -type f -regex '[^ ]*'); do
		echo $(md5sum "${file}")
	done
done
