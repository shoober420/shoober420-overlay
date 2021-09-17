# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-mod

DESCRIPTION="Realtek 8812AU USB WiFi module for Linux kernel"
HOMEPAGE="https://github.com/aircrack-ng/rtl8812au"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/aircrack-ng/rtl8812au.git"
fi

LICENSE="GPL-2"
KEYWORDS="~amd64"

DEPEND="virtual/linux-sources
	app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/${PN}-${PV}"

MODULE_NAMES="88XXau(net/wireless)"
BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERN_DIR=${KV_DIR} KSRC=${KV_DIR} KERN_VER=${KV_FULL} O=${KV_OUT_DIR} V=1 KBUILD_VERBOSE=1"
}

src_compile(){
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
}

pkg_postinst() {
	linux-mod_pkg_postinst
}
