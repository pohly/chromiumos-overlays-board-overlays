# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Packages for Termina dev images"
HOMEPAGE="http://dev.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+profile"

# The dependencies here are meant to capture "all the packages
# developers want to use for development, test, or debug".  This
# category is meant to include all developer use cases, including
# software test and debug, performance tuning, hardware validation,
# and debugging failures running autotest.
#
# To protect developer images from changes in other ebuilds you
# should include any package with a user constituency, regardless of
# whether that package is included in the base Chromium OS image or
# any other ebuild.
#
# Don't include packages that are indirect dependencies: only
# include a package if a file *in that package* is expected to be
# useful.

RDEPEND="
	profile? (
		app-benchmarks/punybench
		dev-util/libc-bench
		net-analyzer/netperf
		dev-util/perf
	)
	app-admin/sysstat
	app-arch/gzip
	app-editors/qemacs
	app-editors/vim
	app-misc/screen
	app-shells/bash
	chromeos-base/chromeos-dev-root
	dev-python/cherrypy
	dev-python/dbus-python
	dev-util/mem
	dev-util/strace
	net-analyzer/tcpdump
	net-misc/curl
	net-misc/iperf:2
	net-misc/iputils
	net-misc/rsync
	net-misc/wget
	sys-apps/coreutils
	sys-apps/diffutils
	sys-apps/file
	sys-apps/findutils
	sys-block/fio
	sys-devel/gdb
	sys-fs/sshfs-fuse
	sys-process/procps
	sys-process/psmisc
	sys-process/time
"
