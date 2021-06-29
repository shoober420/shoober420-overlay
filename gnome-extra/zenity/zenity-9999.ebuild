# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2 autotools meson xdg

DESCRIPTION="Tool to display dialogs from the commandline and shell scripts"
HOMEPAGE="https://wiki.gnome.org/Projects/Zenity"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/${PN}.git"
fi

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug libnotify webkit"

# TODO: X11 dependency is automagically enabled
RDEPEND="
	>=dev-libs/glib-2.8:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3:3[X]
	x11-libs/libX11
	x11-libs/pango
	libnotify? ( >=x11-libs/libnotify-0.6.1:= )
	webkit? ( >=net-libs/webkit-gtk-2.8.1:4 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/itstool
        app-text/yelp-tools
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"

src_prepare() {
      default
      xdg_src_preapre
      gnome2_environment_reset
}

src_configure() {
	local emesonargs=(
	-Dlibnotify=false
        -Dwebkitgtk=false
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}
