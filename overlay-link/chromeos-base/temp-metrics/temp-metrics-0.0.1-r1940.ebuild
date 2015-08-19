# Copyright (C) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI="4"
CROS_WORKON_COMMIT="8c633e5af603687d178047930dc502c7deefe0ae"
CROS_WORKON_TREE="18ef227d5d2f8ae071ceb819ae4beb9383956eef"
CROS_WORKON_PROJECT="chromiumos/platform/ec"
CROS_WORKON_LOCALNAME="../platform/ec"

inherit cros-workon

DESCRIPTION="Temporary metrics collection of sensor temperatures"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

RDEPEND="sys-apps/iotools"  # for wrmsr

src_compile() {
	:
}

src_install() {
	insinto "/etc/init"
	doins "util/temp_metrics.conf"
}
