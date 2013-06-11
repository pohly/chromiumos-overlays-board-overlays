# Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of NVIDIA CORPORATION nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

EAPI=4

inherit tegra-bct eutils

DESCRIPTION="Puppy BCT file"
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD-3"
SLOT="0"
KEYWORDS="arm"
IUSE="bootflash-spi bootflash-emmc dalmore"
REQUIRED_USE="
	bootflash-spi? ( !bootflash-emmc )
	bootflash-emmc? ( !bootflash-spi )
"
PROVIDE="virtual/tegra-bct"

S=${WORKDIR}

src_configure() {
	local board=$(usex dalmore dalmore venice)

	if use bootflash-emmc; then
		TEGRA_BCT_FLASH_CONFIG="${board}/emmc.cfg"
	elif use bootflash-spi; then
		TEGRA_BCT_FLASH_CONFIG="${board}/spi.cfg"
	fi

	TEGRA_BCT_SDRAM_CONFIG="${board}/sdram.cfg"

	TEGRA_BCT_CHIP_FAMILY="t114"

	tegra-bct_src_configure
}
