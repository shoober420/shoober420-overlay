# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info autotools

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/driver/${PN}.git"
fi

DESCRIPTION="X.org input driver based on libinput"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-libs/libinput-1.7.0"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

SLOT="0"

DOCS=( "README.md" )

src_prepare() {
   default
   eautoreconf
}

src_install() {
    default
}

pkg_pretend() {
	CONFIG_CHECK="~TIMERFD"
	check_extra_config
}
