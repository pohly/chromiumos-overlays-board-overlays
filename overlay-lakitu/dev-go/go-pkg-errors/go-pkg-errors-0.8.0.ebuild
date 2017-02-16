# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

MY_PN="github.com/pkg/errors"

EGIT_REPO_URI="https://chromium.googlesource.com/external/${MY_PN}.git"
EGIT_COMMIT="v${PV}"
EGIT_SOURCEDIR="${S}/src/${MY_PN}"

CROS_GO_PACKAGES="${MY_PN}"

DESCRIPTION="Package errors provides simple error handling primitives for golang."
HOMEPAGE="https://github.com/pkg/errors"

inherit cros-go git-2

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
