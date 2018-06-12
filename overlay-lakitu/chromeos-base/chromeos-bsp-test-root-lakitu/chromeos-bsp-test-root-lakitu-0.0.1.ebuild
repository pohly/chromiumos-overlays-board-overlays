# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Ideally chromeos-bsp-test-root-<board> should be a meta-package that pulls in
# other packages, but we don't have a lot of dependencies to pull in at the
# moment so we are just using it as a brown bag of things. When we have more,
# we'll split it.

EAPI=6

inherit eutils systemd

DESCRIPTION="Board specific packages/files to be installed on rootfs in test images"
HOMEPAGE=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

# chromeos-base/chromeos-base: it installs /etc/ssh/sshd_config.
DEPEND="
	chromeos-base/chromeos-base
"

# devserver: we rely on devserver on test images for AU tests.
RDEPEND="${DEPEND}
	chromeos-base/devserver
	!sys-apps/spiny-testconfig
"

S="${WORKDIR}"

src_install() {
	# Install default args for device policy manager monitor mode. In case of
	# test build, we make it use staging backend and decrease the polling
	# interval.
	insinto /etc/default
	newins "${FILESDIR}"/etc.default.device_policy_manager device_policy_manager

	# Change default AUSERVER used on test images to a non-existant one.
	systemd_dounit "${FILESDIR}"/auserver-override.service
	systemd_enable_service sysinit.target auserver-override.service
}

pkg_postinst() {
	elog "Setting PermitRootLogin to without-password"
	sed -i -e 's/PermitRootLogin no/PermitRootLogin without-password/' \
		${ROOT}/etc/ssh/sshd_config || die
}
