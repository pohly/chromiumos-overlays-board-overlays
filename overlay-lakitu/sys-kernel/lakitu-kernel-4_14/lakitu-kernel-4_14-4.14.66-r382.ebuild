# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="f1983cf41a523613927ec6ef31b0384eac642e58"
CROS_WORKON_TREE="4ae4d42a9e1dc888983e609e16d383c0d44b8acf"
CROS_WORKON_PROJECT="chromiumos/third_party/kernel"
CROS_WORKON_LOCALNAME="kernel/v4.14"

CHROMEOS_KERNEL_CONFIG="${FILESDIR}/base.config"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit cros-workon cros-kernel2 osreleased

STRIP_MASK+=" /usr/src/${P}/build/vmlinux"
STRIP_MASK+=" *.ko"

DESCRIPTION="Chromium OS Linux Kernel 4.14"
HOMEPAGE="https://www.chromium.org/chromium-os/chromiumos-design-docs/chromium-os-kernel"
KEYWORDS="*"

src_configure() {
	# Provide a custom key configuration file, because otherwise the kernel
	# would auto-generate one.
	mkdir -p "$(cros-workon_get_build_dir)/certs"
	cp -f "${FILESDIR}/x509.genkey" \
		"$(cros-workon_get_build_dir)/certs/x509.genkey" || die

	cros-kernel2_src_configure
}

src_install() {
	cros-kernel2_src_install

	# VCSID variable is unconditionally set by the cros-workon eclass, and
	# is in the form of "<ebuild_revision>-<sha1>".
	do_osrelease_field "KERNEL_COMMIT_ID" "${VCSID##*-}"
}

# Change the following (commented out) number to the next prime number
# when you change base.config.  This workaround will force the
# ChromeOS CQ to uprev sys-kernel/lakitu-kernel-4_14 ebuild and pick up the
# configuration changes.  In absence of this workaround the config changes
# would not be picked up unless there was a code change in kernel source tree.
#
# NOTE: There's nothing magic keeping this number prime but you just need to
# make _any_ change to this file.  ...so why not keep it prime?
#
# The coolest prime number is: 43
