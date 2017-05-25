# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit user udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies or portage actions"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

# Direct runtime dependencies.
RDEPEND="${RDEPEND}
	dev-vcs/git
	dev-vcs/repo
	net-dns/dnsmasq
	dev-python/dbus-python
"

# Pull in dependencies for cbuildbot, buildbot.
RDEPEND="${RDEPEND}
	chromeos-base/buildbot-deps
	chromeos-base/cbuildbot-deps
"

DEPEND=""

S=${WORKDIR}

pkg_preinst() {
	enewgroup mobbuild
	enewuser mobbuild
}

src_install(){
	# mobbuild user setup.
	insinto /etc/sudoers.d
	echo "mobbuild ALL=NOPASSWD: ALL" > mobbuild-all
	insopts -m600
	doins mobbuild-all
	insinto /etc/init
	doins "${FILESDIR}/init/mobbuild-homedir-init.conf"

	insinto /root
	doins "${FILESDIR}/README.default_build_dir"
	doins "${FILESDIR}/README.default_creds_dir"

	# Build directory setup.
	mkdir -m 0755 -p "${ED}/b"
	udev_dorules "${FILESDIR}/65-mobbuild-build-disk-attached.rules"

	# Marker abstract upstart job.
	# All mobbuild jobs should start after the mobbuild-init-begin job.
	insinto /etc/init
	doins "${FILESDIR}/init/mobbuild-init-begin.conf"

	# Local mobbuild build environment setup.
	insinto /etc/init
	doins "${FILESDIR}/init/mobbuild-build-disk-init.conf"
	doins "${FILESDIR}/init/mobbuild-local-buildtools-init.conf"

	# When used from anywhere except inside one of the buildbot directories, we
	# want the user to launch a local build.
	dobin "${FILESDIR}/cbuildbot"

	# Buildbot environment setup.
	# Credentials setup.
	udev_dorules "${FILESDIR}/65-mobbuild-creds-disk-attached.rules"
	insinto /etc/init
	doins "${FILESDIR}/init/mobbuild-creds-disk-init.conf"

	# Buildbot setup.
	insinto /etc/init
	doins "${FILESDIR}/init/mobbuild-depot-tools-init.conf"
	doins "${FILESDIR}/init/mobbuild-buildbot-init.conf"

	# Support adding local DNS entries.
    dosbin "${FILESDIR}/add-local-dns"
	insinto /etc/init
    doins "${FILESDIR}/init/mobbuild-local-dns-init.conf"
    doins "${FILESDIR}/init/mobbuild-dnsmasq.conf"

	# Finally, start buildbot as an upstart job.
	doins "${FILESDIR}/init/mobbuild-buildbot.conf"
}
