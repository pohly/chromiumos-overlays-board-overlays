# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit pam user

DESCRIPTION="ChromeOS specific system setup"
HOMEPAGE="http://src.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="pam"

DEPEND=">=sys-apps/baselayout-2
	"
RDEPEND="${DEPEND}
	app-shells/bash
	net-misc/openssh
	sys-apps/mawk
	sys-libs/lakitu-custom-locales
	sys-libs/timezone-data
	"

S="${WORKDIR}"

# The user that all user-facing processes will run as.
SHARED_USER_NAME="chronos"
SHARED_USER_ID="1000"

# Adds a "daemon"-type user/group pair.
add_daemon_user() {
	local username="$1"
	local uid="$2"
	enewuser "${username}" "${uid}"
	enewgroup "${username}" "${uid}"
}

pkg_setup() {
	# The sys-libs/timezone-data package installs a default /etc/localtime
	# file automatically, so scrub that if it's a regular file.
	local etc_tz="${ROOT}etc/localtime"
	[[ -L ${etc_tz} ]] || rm -f "${etc_tz}"

	# Standard system users/groups. Allow them to get default IDs.
	add_daemon_user "root"
	add_daemon_user "bin"
	add_daemon_user "daemon"
	enewgroup "sys"
	add_daemon_user "adm"
	enewgroup "tty"
	enewgroup "disk"
	add_daemon_user "lp"
	enewgroup "mem"
	enewgroup "kmem"
	enewgroup "wheel"
	enewgroup "floppy"
	add_daemon_user "news"
	add_daemon_user "uucp"
	enewgroup "console"
	enewgroup "audio"
	enewgroup "cdrom"
	enewgroup "tape"
	enewgroup "video"
	enewgroup "cdrw"
	enewgroup "usb"
	enewgroup "users"
	add_daemon_user "portage"
	enewgroup "utmp"
	enewgroup "nogroup"
	add_daemon_user "nobody"
	enewgroup "uinput"
}

pkg_preinst() {
	# Create users and groups that are used by system daemons at runtime.
	# Users and groups that are also needed at build time should be
	# created in pkg_setup instead.
	add_daemon_user "input"  # For /dev/input/event access
	enewgroup "i2c"          # For I2C device node access.
	enewgroup "serial"       # For owning access to serial devices.
}

src_install() {
	insinto /etc
	doins "${FILESDIR}"/issue
	doins "${FILESDIR}"/locale.conf

	insinto /etc/sysctl.d
	doins "${FILESDIR}"/00-sysctl.conf

	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/udev-rules/*.rules

	dodir /bin /usr/bin

	# Symlink /etc/localtime to something on the stateful
	# partition. At runtime, the system will take care of
	# initializing the path in /var.
	dosym /var/lib/timezone/localtime /etc/localtime

	# We use mawk in the target boards, not gawk.
	dosym mawk /usr/bin/awk

	dosym bash /bin/sh

	# Ensure /etc/shadow exists in the target with correct perms.
	# http://bugs.gentoo.org/260993
	touch "${D}/etc/shadow" || die
	chmod 0600 "${D}/etc/shadow" || die

	# Avoid the wrapper and just link to the only editor we have.
	dodir /usr/libexec
	dosym /usr/bin/vim /usr/libexec/editor
	dosym /bin/more /usr/libexec/pager

	# Install our custom ssh config settings.
	insinto /etc/ssh
	doins "${FILESDIR}"/ssh{,d}_config
	fperms 600 /etc/ssh/sshd_config

	if ! use pam ; then
		sed -i -e '/^UsePAM/d' "${D}"/etc/ssh/sshd_config || die
	fi

	# Some daemons and utilities access the mounts through /etc/mtab.
	dosym /proc/mounts /etc/mtab
}

pkg_postinst() {
	enewgroup "${SHARED_USER_NAME}" "${SHARED_USER_ID}"
	add_daemon_user "${SHARED_USER_NAME}" "${SHARED_USER_ID}"

	# Add a chronos-access group to provide non-chronos users,
	# mostly system daemons running as a non-chronos user, group permissions
	# to access files/directories owned by chronos.
	local system_access_user="chronos-access"
	local system_access_id="1001"
	add_daemon_user "${system_access_user}" "${system_access_id}"

	# Some default directories. These are created here rather than at
	# install because some of them may already exist and have mounts.
	for x in /dev /home /run \
		/mnt/stateful_partition /proc /root /sys /var/lock; do
		[ -d "${ROOT}/$x" ] && continue
		install -d --mode=0755 --owner=root --group=root "${ROOT}/$x"
	done
}
