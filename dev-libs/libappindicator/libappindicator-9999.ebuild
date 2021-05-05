# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit autotools ltprune multilib-minimal vala xdg-utils

DESCRIPTION="A library to allow applications to export a menu into the Unity Menu bar"
HOMEPAGE="https://launchpad.net/libappindicator"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://git.launchpad.net/ubuntu/+source/libappindicator"
fi

LICENSE="LGPL-2.1 LGPL-3"
SLOT="3"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc64 x86"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/dbus-glib-0.98[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.26:2[${MULTILIB_USEDEP}]
	>=dev-libs/libdbusmenu-0.6.2[gtk3,${MULTILIB_USEDEP}]
	>=dev-libs/libindicator-12.10.0:3[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.2:3[${MULTILIB_USEDEP},introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1:= )
"
DEPEND="${RDEPEND}
	introspection? ( $(vala_depend) )
	dev-util/gtk-doc-am
	virtual/pkgconfig
"

src_prepare() {
	default

	xdg_environment_reset
	export MAKEOPTS+=" -j1" #638782

	eautoreconf

}

multilib_src_configure() {
	if multilib_is_native_abi; then
		local -x VALAC VALA_API_GEN VAPIGEN_VAPIDIR PKG_CONFIG_PATH
		use introspection && vala_src_prepare && export VALA_API_GEN="${VAPIGEN}"
	fi

	ECONF_SOURCE="${S}" \
	econf \
		--disable-static \
		--with-gtk=2 \
		$(multilib_native_use_enable introspection)
}

multilib_src_install() {
	emake -j1 DESTDIR="${D}" install
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
