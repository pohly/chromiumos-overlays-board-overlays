# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="0a4f6bff3006e942278d8f1f57b58727cf6d3fb4"
CROS_WORKON_TREE="e38914770832da60b19aee230ae274d1fac1c62b"
inherit cros-constants

CROS_WORKON_PROJECT="chromiumos/overlays/board-overlays"
CROS_WORKON_LOCALNAME="../overlays/"
CROS_WORKON_SUBTREE="overlay-sarien/chromeos-base/chromeos-config-bsp-sarien/files"

inherit cros-unibuild cros-workon

DESCRIPTION="Chrome OS Model configuration package for sarien"
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD-Google"
SLOT="0/${PF}"
KEYWORDS="* amd64 x86"

src_install() {
	install_model_files
}
