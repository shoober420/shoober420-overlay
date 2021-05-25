# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2 meson multilib-minimal xdg

DESCRIPTION="GObject bindings for libudev"
HOMEPAGE="https://wiki.gnome.org/Projects/libgudev"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/${PN}.git"
fi

LICENSE="LGPL-2.1+"
SLOT="0/0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"
IUSE="introspection static-libs"

DEPEND="
	>=dev-libs/glib-2.38.0:2[${MULTILIB_USEDEP},static-libs?]
	>=virtual/libudev-199:=[${MULTILIB_USEDEP},static-libs(-)?]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )
"
RDEPEND="${DEPEND}
	!sys-fs/eudev[gudev(-)]
	!sys-fs/udev[gudev(-)]
	!sys-apps/systemd[gudev(-)]
"
BDEPEND="
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.18
	virtual/pkgconfig
"

src_prepare() {
        default
        xdg_src_preapre
}

multilib_src_configure() {
	local emesonargs=(
		-Dintrospection="$(multilib_native_usex introspection enabled disabled)"
		-Dtests=disabled
                -Dgtk-doc=disabled
	)
        meson_src_configure
}

multilib_src_install() {
	meson_src_install
}
