# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=SDL2_net-${PV}
inherit multilib-minimal

DESCRIPTION="Simple Direct Media Layer Network Support Library"
HOMEPAGE="https://www.libsdl.org/projects/SDL_net/index.html"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/libsdl-org/SDL_net.git"
fi

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86"
IUSE="static-libs"

RDEPEND=">=media-libs/libsdl2-2.0.1-r1[${MULTILIB_USEDEP}]"
DEPEND=${RDEPEND}

S="${WORKDIR}/${PN}-${PV}"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-gui \
		$(use_enable static-libs static)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt
	find "${ED}" -name '*.la' -delete || die
}
