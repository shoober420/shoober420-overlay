# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop multilib

DESCRIPTION="A simple terminal emulator"
HOMEPAGE="https://github.com/91861/wayst"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/91861/${PN}.git"
else
	MY_PV=${PV/_rc/-rc}
	SRC_URI=""https://github.com/91861/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	>=sys-libs/ncurses-6.0:0=
	media-libs/fontconfig
	dev-libs/wayland
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	
  default
  
}

src_install() { dobin wayst; }

pkg_postinst() {
	if ! [[ "${REPLACING_VERSIONS}" ]]; then
		elog "Please ensure a usable font is installed, like"
		elog "    media-fonts/corefonts"
		elog "    media-fonts/dejavu"
		elog "    media-fonts/urw-fonts"
                elog"     media-fonts/ibm-plex"
	fi
}
