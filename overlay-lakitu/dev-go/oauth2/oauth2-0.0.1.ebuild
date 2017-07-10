# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# Disable cros-workon auto-uprev since this is an external package.
# Must manage commit/tree hashes manually.
CROS_WORKON_BLACKLIST="1"
CROS_WORKON_COMMIT="8914e5017ca260f2a3a1575b1e6868874050d95e"
CROS_WORKON_TREE="d6c822ccb32588bc9c7473a9a5844c9e20b5f5fc"
CROS_WORKON_REPO="https://go.googlesource.com"
CROS_WORKON_PROJECT="oauth2"
CROS_WORKON_DESTDIR="${S}/src/golang.org/x/oauth2"

CROS_GO_PACKAGES=(
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"golang.org/x/oauth2/internal"
	"golang.org/x/oauth2/jws"
	"golang.org/x/oauth2/jwt"
)

inherit cros-workon cros-go

DESCRIPTION="Go OAuth2"
HOMEPAGE="https://golang.org/x/oauth2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip test"

RDEPEND=""

# golang.org/x/oauth2/google package depends on GCE metadata service to fetch
# the application default credentials.
DEPEND="${RDEPEND}
	dev-go/gocloud"
