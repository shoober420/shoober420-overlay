# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Novum/vkQuake.git"
fi

DESCRIPTION="Modern, cross-platform Quake 1 engine based on FitzQuake"
HOMEPAGE="https://github.com/Novum/vkQuake"
LICENSE="GPL-2"
SLOT="0"
IUSE="sdl2"

DEPEND="
	dev-util/vulkan-headers
	media-libs/vulkan-loader
	media-libs/libvorbis
	media-libs/libogg
	media-libs/libmad
	virtual/opengl
	virtual/glu
	sdl2? ( media-libs/libsdl2 )
	!sdl2? ( media-libs/libsdl )
"
RDEPEND="${DEPEND}"

src_compile() {
	cd Quake || die
	emake
}

src_install() {
#	einstalldocs
	dobin Quake/vkquake
}
