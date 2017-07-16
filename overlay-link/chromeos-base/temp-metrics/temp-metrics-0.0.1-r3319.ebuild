# Copyright (C) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI="4"
CROS_WORKON_COMMIT="26c8fa9cfe8d4444e5690fb71fbda7e3ae42d93b"
CROS_WORKON_TREE="e3e5ca1b1c3f2d486d91293e930e58cb881562f4"
CROS_WORKON_PROJECT="chromiumos/platform/ec"
CROS_WORKON_LOCALNAME="../platform/ec"

inherit cros-workon

DESCRIPTION="Temporary metrics collection of sensor temperatures"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/ec-utils
	sys-apps/iotools
"

src_compile() {
	:
}

src_install() {
	insinto "/etc/init"
	doins "util/temp_metrics.conf"
}
