# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib-minimal

MY_P="SDL2_ttf-${PV}"
DESCRIPTION="library that allows you to use TrueType fonts in SDL applications"
HOMEPAGE="http://www.libsdl.org/projects/SDL_ttf/"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/libsdl-org/SDL_ttf.git"
fi

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ~ppc64 sparc x86"
IUSE="static-libs X"

RDEPEND="X? ( >=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}] )
	>=media-libs/libsdl2-2.0.1-r1[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${PV}"

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_with X x)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt
	find "${ED}" -name '*.la' -delete || die

	dosym /usr/lib/libSDL2_ttf-2.0.so.0 /usr/lib/libSDL_ttf-2.0.so
        dosym /usr/lib64/libSDL2_ttf-2.0.so.0 /usr/lib64/libSDL_ttf-2.0.so
	dosym /usr/lib/libSDL2_ttf-2.0.so.0 /usr/lib/libSDL_ttf-2.0.so.0
	dosym /usr/lib64/libSDL2_ttf-2.0.so.0 /usr/lib64/libSDL_ttf-2.0.so.0
}
