# Copyright (C) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI="4"
CROS_WORKON_COMMIT="7836cdd6e6ce3ab11d49add01a91a59aa03057de"
CROS_WORKON_TREE="fb70eec4bf8b66a11517dcf21d44a57daa3d51f0"
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
