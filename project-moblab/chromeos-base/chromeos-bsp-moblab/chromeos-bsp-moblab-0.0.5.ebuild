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
	net-analyzer/fping
	net-ftp/tftp-hpa
	lxc? ( net-misc/bridge-utils )
	net-misc/dhcp
	net-misc/rsync
	sys-apps/file
	dev-python/pyyaml
"

# Chromium OS Autotest Server and Devserver Deps.
RDEPEND="${RDEPEND}
	chromeos-base/autotest-server
	chromeos-base/devserver
	chromeos-base/mobmonitor
	chromeos-base/whining
"

DEPEND=""

S=${WORKDIR}

pkg_preinst() {
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

	insinto /autotest
	doins "${FILESDIR}/ssp_deploy_shadow_config.json"

	insinto /etc/sudoers.d
	echo "moblab ALL = NOPASSWD: ALL" > moblab-sudo-all
	echo "apache ALL = NOPASSWD: /sbin/reboot" > apache-reboot
	echo "apache ALL = NOPASSWD: /sbin/restart" > apache-restart
	echo "apache ALL = NOPASSWD: /sbin/start" > apache-start
	echo "apache ALL = NOPASSWD: /sbin/stop" > apache-stop
	echo "apache ALL = NOPASSWD: /usr/sbin/apache2" > apache-apache2
	echo "apache ALL = NOPASSWD: /usr/bin/update_engine_client" > apache-update_client
	insopts -m600
	doins moblab-sudo-all
	doins apache-reboot
	doins apache-restart
	doins apache-start
	doins apache-stop
	doins apache-apache2
	doins apache-update_client

	insinto /root
	newins "${FILESDIR}/bash_profile" .bash_profile

	# Copy the moblab checkfiles for the Mob* Monitor.
	insinto "/etc/mobmonitor/checkfiles/moblab/"
	doins -r "${FILESDIR}/checkfiles/moblab/"*
}
