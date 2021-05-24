# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools gnome2 multilib-minimal

DESCRIPTION="Library for Neighbor Discovery Protocol"
HOMEPAGE="http://libndp.org"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/jpirko/${PN}.git"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

src_prepare() {
        default
        eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	gnome2_src_configure \
		--disable-static \
		--enable-logging
}

multilib_src_install() {
	gnome2_src_install
}
