# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://disenchant.net/git/tyrquake.git"
fi

DESCRIPTION="Faithful Quake 1 source port"
HOMEPAGE="https://disenchant.net/tyrquake"
LICENSE="GPL-2"
SLOT="0"
IUSE="sdl2"

DEPEND="
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
#	cd Quake || die
	emake
}

src_install() {
#	einstalldocs
	dobin bin/tyr-glquake
	dobin bin/tyr-quake
	dobin bin/tyr-qwcl
	dobin bin/tyr-qwsv
	dobin bin/tyr-glqwcl
}
