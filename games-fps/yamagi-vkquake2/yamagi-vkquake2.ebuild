# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs wrapper

DESCRIPTION="Quake 2 engine focused on single player"
HOMEPAGE="https://www.yamagi.org/quake2/"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/yquake2/ref_vk.git"
fi

S="${WORKDIR}/${PN}-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+client vulkan"
REQUIRED_USE="
	|| ( client )
	client? ( || ( vulkan ) )
"

RDEPEND="
	client? (
		media-libs/libsdl2
	)
"
DEPEND="${RDEPEND}
	client? ( vulkan? ( dev-util/vulkan-headers ) )
"
src_compile() {
	if use client && use vulkan; then
		emake -C "${WORKDIR}"/${PN}-${PV}
	fi
}

src_install() {
		if use vulkan; then
			dobin "${WORKDIR}"/${PN}-${PV}/release/ref_vk.so
		fi
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog
		elog "In order to play, you should do one of the following things:"
		elog " - install games-fps/quake2-data or games-fps/quake2-demodata;"
		elog " - manually copy game data files into ~/.yq2/ or"
		elog "   ${EROOT}/usr/share/quake2/."
		elog "Read ${EROOT}/usr/share/doc/${PF}/README.md* for more information."
		elog
	fi
}
