# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual for librealtek-sdk packages (source or prebuilt binaries)"
SRC_URI=""

SLOT="0"
KEYWORDS="-* amd64 x86"

RDEPEND="
	media-libs/librealtek-sdk-bin
"
DEPEND="${RDEPEND}"
