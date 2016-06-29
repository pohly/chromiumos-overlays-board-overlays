# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit user

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies or portage actions"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+lxc"

# These packages are meant to set up the Chromium OS Basic environment to
# properly handle the services required by the lab infrastructure.
RDEPEND="
	chromeos-base/shill
	app-crypt/gnupg
	lxc? ( app-emulation/lxc )
	chromeos-base/chromeos-init
	chromeos-base/update_engine[delta_generator]
	chromeos-base/openssh-server-init
	chromeos-base/jabra-vold
	net-analyzer/fping
	net-ftp/tftp-hpa
	lxc? ( net-misc/bridge-utils )
	net-misc/dhcp
	net-misc/rsync
	sys-apps/file
"

# Chromium OS Autotest Server and Devserver Deps.
RDEPEND="${RDEPEND}
	chromeos-base/autotest-server
	chromeos-base/devserver
	chromeos-base/mobmonitor
	chromeos-base/whining
"

# Dependencies for Android Testing on MobLab.
RDEPEND="${RDEPEND}
	chromeos-base/chromeos-adb-env
"

DEPEND=""

S=${WORKDIR}

pkg_setup() {
	enewgroup moblab
	enewuser moblab
}

src_install() {
	insinto /etc/init
	doins "${FILESDIR}"/init/*.conf

	if use lxc; then
		doins "${FILESDIR}/moblab-network-bridge-init.conf"
		doins "${FILESDIR}/moblab-base-container-init.conf"
	else
		doins "${FILESDIR}/moblab-network-init.conf"
	fi

	insinto /etc/apache2/modules.d
	doins "${FILESDIR}/moblab-apache-settings.conf"

	insinto /etc/dhcp
	doins "${FILESDIR}/dhcpd-moblab.conf"

	# Create the mount point for external storage.
	dodir "/mnt/moblab"

	# Restrict sudo access.
	insinto /etc/sudoers.d
	echo "moblab ALL = NOPASSWD: /sbin/start" > moblab-start
	echo "moblab ALL = NOPASSWD: /sbin/stop" > moblab-stop
	echo "moblab ALL = NOPASSWD: /sbin/status" > moblab-status
	echo "moblab ALL = NOPASSWD: /sbin/restart" > moblab-restart
	echo "moblab ALL = NOPASSWD: /bin/mount" > moblab-mount
	echo "moblab ALL = NOPASSWD: /usr/bin/dut-control" > moblab-dut-control
	echo "moblab ALL = NOPASSWD: /usr/bin/screen" > moblab-screen
	echo "moblab ALL = NOPASSWD: /usr/sbin/flashrom" > moblab-flashrom
	echo "moblab ALL = NOPASSWD: /usr/bin/vi" > moblab-vi
	echo "moblab ALL = NOPASSWD: /usr/bin/servod" > moblab-servod
	echo "moblab ALL = NOPASSWD: /usr/bin/adb" > moblab-adb
	echo "moblab ALL = NOPASSWD: /usr/bin/fastboot" > moblab-fastboot
	echo "moblab ALL = NOPASSWD: /sbin/reboot" > moblab-reboot
	echo "moblab ALL = NOPASSWD: /sbin/shutdown" > moblab-shutdown
	echo "apache ALL = NOPASSWD: /sbin/reboot" > apache-reboot
	echo "apache ALL = NOPASSWD: /sbin/restart" > apache-restart
	insopts -m600
	doins moblab-start moblab-stop moblab-status moblab-restart moblab-mount
	doins moblab-dut-control moblab-screen moblab-flashrom moblab-vi
	doins moblab-servod moblab-adb moblab-fastboot moblab-reboot
	doins moblab-shutdown
	doins apache-reboot
	doins apache-restart

	insinto /root
	newins "${FILESDIR}/bash_profile" .bash_profile

	# Copy the moblab checkfiles for the Mob* Monitor.
	insinto "/etc/mobmonitor/checkfiles/moblab/"
	doins -r "${FILESDIR}/checkfiles/moblab/"*
}
