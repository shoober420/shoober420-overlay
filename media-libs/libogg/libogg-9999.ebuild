# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools multilib-minimal

DESCRIPTION="the Ogg media file format library"
HOMEPAGE="https://xiph.org/ogg/"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/xiph/ogg.git"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

DOCS=( AUTHORS CHANGES )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/ogg/config_types.h
)

src_prepare() {
        default
        eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name "*.la" -delete || die
}
