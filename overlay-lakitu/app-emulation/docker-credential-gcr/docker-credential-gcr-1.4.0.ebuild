# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

MY_PN="github.com/GoogleCloudPlatform/${PN}"

EGIT_REPO_URI="https://chromium.googlesource.com/external/${MY_PN}.git"
# TODO(mikewu): change it to version number when the next release is available.
EGIT_COMMIT="COS-2017-05-12"
EGIT_SOURCEDIR="${S}/src/${MY_PN}"

CROS_GO_BINARIES="${MY_PN}"

DESCRIPTION="Google Container Registry's Docker credential helper"
HOMEPAGE="https://github.com/GoogleCloudPlatform/docker-credential-gcr"

inherit cros-go eutils git-2

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

# Note that docker-credential-gcr depends on the head of dev-go/go-subcommands.
# Please update dev-go/go-subcommands when upgrading docker-credential-gcr.
DEPEND="app-emulation/docker
	~app-emulation/docker-credential-helpers-0.5.0
	>=dev-lang/go-1.7:=
	~dev-go/go-pkg-errors-0.8.0
	dev-go/go-subcommands
	dev-go/net
	dev-go/oauth2
"
RDEPEND="${DEPEND}"
