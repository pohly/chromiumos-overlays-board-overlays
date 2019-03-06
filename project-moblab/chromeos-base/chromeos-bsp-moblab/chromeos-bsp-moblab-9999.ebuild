# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_BLACKLIST=1
CROS_WORKON_PROJECT="chromiumos/overlays/board-overlays"
CROS_WORKON_LOCALNAME="../overlays/"
CROS_WORKON_SUBTREE="project-moblab/chromeos-base/chromeos-bsp-moblab/files"

inherit user cros-workon

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies or portage actions"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"

IUSE="-moblab-install-base-container"

# These packages are meant to set up the Chromium OS Basic environment to
# properly handle the services required by the lab infrastructure.
# TODO(pprabhu, crbug.com/775373) Move virt-what to common VM overlay once that
# is ready.
RDEPEND="
	app-crypt/gnupg
	app-emulation/lxc
	app-emulation/virt-what
	chromeos-base/chromeos-init
	chromeos-base/openssh-server-init
	chromeos-base/shill
	dev-python/python-dateutil
	dev-python/pyyaml
	net-analyzer/fping
	net-firewall/iptables
	net-ftp/tftp-hpa
	net-misc/bridge-utils
	net-misc/dhcp
	net-misc/rsync
	sys-apps/ethtool
	sys-apps/file
	sys-fs/e2fsprogs
	net-dns/bind-tools
	net-analyzer/speedtest-cli
	dev-python/cachetools
"

# Chromium OS Autotest Server and Devserver Deps.
RDEPEND="${RDEPEND}
	chromeos-base/autotest-server
	chromeos-base/devserver
	chromeos-base/whining
	sys-apps/moblab
	moblab-install-base-container? ( chromeos-base/install-base-container )
"

DEPEND=""


pkg_preinst() {
	enewgroup moblab
	enewuser moblab
}

src_install() {

	insinto /etc/apache2/modules.d
	doins "${FILESDIR}/moblab-apache-settings.conf"

	insinto /etc/dhcp
	doins "${FILESDIR}/dhcpd-moblab.conf"

	# Create the mount point for external storage.
	dodir "/mnt/moblab"
	# Create the mount point for settings usb storage
	dodir "/mnt/moblab-settings"

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
	echo "apache ALL = NOPASSWD: /usr/sbin/vpd" | newins - apache-vpd

	insinto /root
	newins "${FILESDIR}/bash_profile" .bash_profile

	insinto /etc/init
	doins "${FILESDIR}/cgroups.override"

	insinto /etc/moblab/mysql
	insopts -m644
	doins "${FILESDIR}/mysql_defaults_extra.cnf"
}
