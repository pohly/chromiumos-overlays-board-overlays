# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="4"

DESCRIPTION="Customization for the Lakitu Image"
HOMEPAGE="http://dev.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="bootchart +crash_reporting +pam readahead systemd watchdog apparmor"

LAKITU_RDEPEND="
	bootchart? ( app-benchmarks/bootchart )
	crash_reporting? ( chromeos-base/crash-reporter )
	pam? (
		virtual/chromeos-auth-config
		sys-auth/pam_pwdfile
	)
	watchdog? ( sys-apps/daisydog )
	app-admin/compute-image-packages
	app-admin/sudo
	app-admin/toolbox
	app-arch/tar
	app-editors/vim
	app-emulation/cloud-init
	app-emulation/docker
	app-emulation/kubernetes
	app-shells/bash
	chromeos-base/chromeos-init-systemd
	chromeos-base/chromeos-installer
	chromeos-base/cloud-filesystem-init
	chromeos-base/cloud-network-init
	chromeos-base/cloud-udev-config
	chromeos-base/ima-policy
	chromeos-base/openssh-server-init
	chromeos-base/terminfo-extra
	chromeos-base/tty
	chromeos-base/update_engine
	dev-lang/python
	net-analyzer/netcat
	net-firewall/ebtables
	net-fs/autofs
	net-misc/bridge-utils
	net-misc/wget
	apparmor? (
		sys-apps/apparmor
		sec-policy/apparmor-profiles
	)
	sys-apps/dbus
	sys-apps/ethtool
	>=sys-apps/iproute2-3.19.0
	sys-apps/less
	sys-apps/mosys
	sys-apps/pv
	sys-fs/e2fsprogs
	virtual/chromeos-bsp
	virtual/chromeos-firewall
	virtual/implicit-system
	virtual/linux-sources
	virtual/modutils
	virtual/udev
"

RDEPEND="${LAKITU_RDEPEND}
"

DEPEND="
	${LAKITU_RDEPEND}
	sys-boot/syslinux
"
