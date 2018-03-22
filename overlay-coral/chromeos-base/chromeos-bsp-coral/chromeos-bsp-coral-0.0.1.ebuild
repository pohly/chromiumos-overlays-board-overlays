# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid
inherit cros-model cros-unibuild

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="chromeos-base/chromeos-bsp-baseboard-coral"
DEPEND="
	${RDEPEND}
	chromeos-base/chromeos-config
"

src_install() {
	doappid "{5A3AB642-2A67-470A-8F37-37E737A53CFC}" "CHROMEBOOK"

	cros-model_src_install

	unibuild_install_audio_files

	local common_model_dir=${D}${CROS_MODELS_DIR}/${CROS_COMMON_MODEL}

	# Install Bluetooth ID override.
	for dir in "${D}${CROS_MODELS_DIR}"/*; do
		local model="${dir##*/}"
		insinto "/etc/bluetooth/models"
		newins "${D}${CROS_MODELS_DIR}/${model}/bluetooth/main.conf" "${model}.conf"
	done

	# TODO(pberny/shapiroc): PowerD config is done differently from other configs.
	#                        it should not have a separate folder for common
	#                        settings, since that defies the purpose of doing
	#                        inheritance on the model config!

	# Install board-specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	# Since these are by definition shared by all models supported by board,
	# we insist that
	#   a) they must be in the common root model shared by all models.
	#      By convention it must be called "common".
	doins "${common_model_dir}/powerd"/*

	# Install model-specific config files for power_manager.
	for dir in "${D}${CROS_MODELS_DIR}"/*; do
		local model="${dir##*/}"

		if [[ "${CROS_COMMON_MODEL}" != "${model}" ]]; then
			local power_dir="${D}${CROS_MODELS_DIR}/${model}/powerd"
			einfo "${power_dir}"
			if [[ -d "${power_dir}" ]]; then
				insinto "/usr/share/power_manager/model_specific/${model}"
				# Can't have just an empty folder, need at least one file in there!
				doins -r "${power_dir}"/*
			else
				einfo "${model}: no powerd files"
			fi
		fi
	done

	# Install DPTF datavaults
	for dir in "${D}${CROS_MODELS_DIR}"/*; do
		local model="${dir##*/}"
		insinto "/etc/dptf/${model}"
		doins "${D}${CROS_MODELS_DIR}/${model}/thermal/dptf.dv"
	done

	# Install into image so the private overlay can use it too
	insinto "${CROS_MODELS_DIR}"
	doins "${FILESDIR}"/createInheritanceList.py
	chmod a+x "${D}${CROS_MODELS_DIR}/createInheritanceList.py"
}
