# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

MY_PN="github.com/docker/${PN}"

EGIT_REPO_URI="https://chromium.googlesource.com/external/${MY_PN}.git"
EGIT_COMMIT="v${PV}"
EGIT_SOURCEDIR="${S}/src/${MY_PN}"

CROS_GO_PACKAGES="${MY_PN}/credentials"

inherit cros-go git-2

DESCRIPTION="A suite of programs to use native stores to keep Docker credentials safe."
HOMEPAGE="https://github.com/docker/docker-credential-helpers"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
