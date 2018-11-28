#!/bin/sh
for path in /etc/bluetooth; do
	for file in $(find "/build/nami${path}" -type f -regex '[^ ]*'); do
		echo $(md5sum "${file}")
	done
done
