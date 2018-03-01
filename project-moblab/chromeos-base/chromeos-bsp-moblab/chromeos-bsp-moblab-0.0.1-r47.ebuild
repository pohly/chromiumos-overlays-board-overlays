# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="cee18074be3128cd800d8a84833cbe55c654d903"
CROS_WORKON_TREE="caddca4996a6e9ef448385b13a2eb7686ce9a692"
CROS_WORKON_PROJECT="chromiumos/overlays/board-overlays"
CROS_WORKON_LOCALNAME="../overlays/"
CROS_WORKON_SUBTREE="project-moblab/chromeos-base/chromeos-bsp-moblab/files"

inherit user cros-workon

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies or portage actions"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+lxc"

# These packages are meant to set up the Chromium OS Basic environment to
# properly handle the services required by the lab infrastructure.
# TODO(pprabhu, crbug.com/775373) Move virt-what to common VM overlay once that
# is ready.
RDEPEND="
	chromeos-base/shill
	app-crypt/gnupg
	app-emulation/virt-what
	lxc? ( app-emulation/lxc )
	chromeos-base/chromeos-init
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
	sys-apps/moblab-site-utils
"

DEPEND=""

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
	insopts -m600
	echo "moblab ALL = NOPASSWD: ALL" | newins - moblab-sudo-all
	echo "apache ALL = NOPASSWD: /sbin/reboot" | newins - apache-reboot
	echo "apache ALL = NOPASSWD: /sbin/restart" | newins - apache-restart
	echo "apache ALL = NOPASSWD: /sbin/start" | newins - apache-start
	echo "apache ALL = NOPASSWD: /sbin/stop" | newins - apache-stop
	echo "apache ALL = NOPASSWD: /usr/sbin/apache2" | newins - apache-apache2
	echo "apache ALL = NOPASSWD: /usr/bin/update_engine_client" | newins - apache-update_client

	insinto /root
	newins "${FILESDIR}/bash_profile" .bash_profile

	# Copy the moblab checkfiles for the Mob* Monitor.
	insinto "/etc/mobmonitor/checkfiles/moblab/"
	doins -r "${FILESDIR}/checkfiles/moblab/"*
}
