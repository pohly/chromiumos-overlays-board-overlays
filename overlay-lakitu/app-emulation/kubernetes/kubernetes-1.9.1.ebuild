# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit systemd

DESCRIPTION="Kubernetes package for node"
HOMEPAGE="https://github.com/GoogleCloudPlatform/kubernetes"
SRC_URI="https://storage.googleapis.com/kubernetes-release/release/v${PV}/kubernetes-server-linux-amd64.tar.gz -> kubernetes-server-linux-amd64-${PV}.tar.gz"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

S=${WORKDIR}

RDEPEND="
	app-arch/gzip
	>=net-misc/socat-1.7.3.0
	app-admin/logrotate
"

src_install() {
	dobin kubernetes/server/bin/kubelet
	dobin kubernetes/server/bin/kubectl

	systemd_dounit "${FILESDIR}"/kubelet.service
	insinto /etc/default
	newins "${FILESDIR}"/default kubelet
}
