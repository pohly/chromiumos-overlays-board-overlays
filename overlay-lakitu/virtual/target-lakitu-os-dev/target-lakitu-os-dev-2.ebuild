# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="4"

DESCRIPTION="List of packages that make up the base OS image;
by default; here we build a Lakitu dev image"
HOMEPAGE="http://dev.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

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
		chromeos-base/quipper
		dev-util/libc-bench
		net-analyzer/netperf
		dev-util/perf
	)
	app-admin/sysstat
	app-arch/gzip
	app-arch/tar
	app-benchmarks/i7z
	app-editors/qemacs
	app-editors/vim
	app-misc/screen
	app-portage/portage-utils
	app-shells/bash
	app-shells/bash-completion
	chromeos-base/chromeos-dev-root
	chromeos-base/gmerge
	chromeos-base/protofiles
	dev-python/cherrypy
	dev-python/dbus-python
	dev-python/protobuf-python
	dev-util/strace
	dev-util/mem
	dev-util/strace
	net-analyzer/tcpdump
	net-misc/iperf:2
	net-misc/iputils
	net-misc/rsync
	sys-apps/coreutils
	sys-apps/diffutils
	sys-apps/dmidecode
	sys-apps/file
	sys-apps/findutils
	sys-apps/iotools
	sys-apps/portage
	sys-apps/which
	sys-block/fio
	sys-boot/syslinux
	sys-devel/gdb
	sys-fs/lvm2
	sys-fs/sshfs-fuse
	sys-process/procps
	sys-process/psmisc
	sys-process/time
"
