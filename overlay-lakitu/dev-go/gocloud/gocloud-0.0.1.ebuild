# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# Disable cros-workon auto-uprev since this is an external package.
# Must manage commit/tree hashes manually.
CROS_WORKON_BLACKLIST="1"
CROS_WORKON_COMMIT="e34a32f9b0ecbc0784865fb2d47f3818c09521d4"
CROS_WORKON_TREE="e33ba2ad9b482e265abfd202941f6328c852759f"
CROS_WORKON_REPO="https://code.googlesource.com"
CROS_WORKON_PROJECT="gocloud"
CROS_WORKON_DESTDIR="${S}/src/google.golang.org/cloud"

CROS_GO_PACKAGES=(
	"google.golang.org/cloud/compute/metadata"
	"google.golang.org/cloud/internal"
)

inherit cros-workon cros-go

DESCRIPTION="Go packages for Google Cloud Platform services"
HOMEPAGE="https://code.googlesource.com/gocloud"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip test"

DEPEND=""
RDEPEND=""
