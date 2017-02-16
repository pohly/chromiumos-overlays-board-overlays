# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

MY_PN="github.com/google/subcommands"

EGIT_REPO_URI="https://chromium.googlesource.com/external/${MY_PN}.git"
# TODO(mikewu): change this to version number when the package make a release.
EGIT_COMMIT="ce3d4cfc062faac7115d44e5befec8b5a08c3faa"
EGIT_SOURCEDIR="${S}/src/${MY_PN}"

CROS_GO_PACKAGES="${MY_PN}"

DESCRIPTION="A Go package for a singlecommand to have many subcommands."
HOMEPAGE="https://github.com/google/subcommands"

inherit cros-go git-2

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
