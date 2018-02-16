# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

DESCRIPTION="Stackdriver Agent Services for Logging and Monitoring"
SRC_URI=""

inherit systemd

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/systemd
"

S="${WORKDIR}"

src_install() {
	# fluentd config used by stackdriver logging agent
	insinto /etc/stackdriver/logging.config.d
	doins "${FILESDIR}"/logging_configs/*.conf

	# collectd config used by stackdriver monitoring agent
	insinto /etc/stackdriver/monitoring.config.d
	doins "${FILESDIR}"/monitoring_configs/collectd.conf

	# Envionment variables used by all stackdriver agent services
	insinto /etc/stackdriver
	doins "${FILESDIR}"/env_vars

	systemd_dounit "${FILESDIR}"/stackdriver-docker-network.service
	systemd_dounit "${FILESDIR}"/stackdriver-metadata.service
	systemd_dounit "${FILESDIR}"/stackdriver-monitoring.service
	systemd_dounit "${FILESDIR}"/stackdriver-logging.service
}
