# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GNOME_ORG_MODULE="NetworkManager"

inherit meson multilib-minimal multilib-build

DESCRIPTION="Legacy NetworkManager glib and util libraries"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://gitlab.freedesktop.org/NetworkManager/NetworkManager.git"
        EGIT_BRANCH="nm-1-18"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="gnutls +nss"
REQUIRED_USE="|| ( nss gnutls )"
RESTRICT="test"

DEPEND="
	>=sys-apps/dbus-1.2[${MULTILIB_USEDEP}]
	>=dev-libs/dbus-glib-0.100[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.40:2[${MULTILIB_USEDEP}]
	net-libs/libndp[${MULTILIB_USEDEP}]
	sys-apps/util-linux[${MULTILIB_USEDEP}]
	>=virtual/libudev-175:=[${MULTILIB_USEDEP}]
	nss? ( >=dev-libs/nss-3.11:=[${MULTILIB_USEDEP}] )
	!nss? ( gnutls? (
		dev-libs/libgcrypt:0=[${MULTILIB_USEDEP}]
		>=net-libs/gnutls-2.12:=[${MULTILIB_USEDEP}] ) )
"

RDEPEND="
	${DEPEND}
	!<net-misc/networkmanager-1.19
"

BDEPEND="
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"

multilib_src_configure() {
	local emesonargs=(
		-Dsystemdsystemunitdir=no
		-Dudev_dir=no
		-Ddbus_conf_dir="/etc/dbus-1/system.d"

		-Dsession_tracking_consolekit=false
		-Dsession_tracking=no
		-Dsuspend_resume=auto
		-Dpolkit=false
		-Dpolkit_agent=false
		-Dselinux=false
		-Dsystemd_journal=false
		-Dlibaudit=no
                -Dmodify_system=true
                

		-Dwext=false
		-Dwifi=false
		-Diwd=false
		-Dppp=false
		-Dmodem_manager=false
		-Dofono=false
		-Dconcheck=false
		-Dteamdctl=false
		-Dovs=false
		-Dlibnm_glib=true
		-Dnmcli=false
		-Dnmtui=false
		-Dbluez5_dun=false
		-Debpf=true

		-Dresolvconf=no
		-Dnetconfig=no

		-Ddhclient=no
		-Ddhcpcanon=no
		-Ddhcpcd=no

		-Dintrospection=$(if multilib_is_native_abi; then echo true; else echo false; fi)
                -Dvapi=$(if multilib_is_use_enable; then echo true; else echo false; fi)
		-Dtests=no
		-Dmore_asserts=no
		-Dmore_logging=false
		-Dvalgrind=no
		-Dlibpsl=false
		-Djson_validation=false
#		-Dcrypto=$(usex nss nss gnutls)
		-Dqt=false
	)

	meson_src_configure
}

multilib_src_compile() {
	local targets=(
		libnm-util/libnm-util.so.2.7.0
		libnm-glib/libnm-glib.so.4.9.0
		libnm-glib/libnm-glib-vpn.so.1.2.0
	)

	meson_src_compile "${targets[@]}"
}

multilib_src_install() {
	dolib.so libnm-{glib,util}/libnm-*.so*[0-9]
}

multilib_src_install_all() {
	:
}
