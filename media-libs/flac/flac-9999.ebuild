# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="free lossless audio encoder and decoder"
HOMEPAGE="https://xiph.org/flac/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xiph/${PN}.git"
else
	MY_PV=${PV/_rc/-rc}
	SRC_URI="https://github.com/xiph/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="BSD FDL-1.2 GPL-2 LGPL-2.1"
SLOT="0"
IUSE="+cxx debug ogg cpu_flags_ppc_altivec cpu_flags_ppc_vsx cpu_flags_x86_sse static-libs"

RDEPEND="ogg? ( >=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	abi_x86_32? ( dev-lang/nasm )
"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
	!elibc_uclibc? ( sys-devel/gettext )
"

src_prepare() {
  default
  
  if [[ ${PV} == 9999* ]]; then
		if [[ -e /usr/share/gettext/config.rpath ]]; then
			cp /usr/share/gettext/config.rpath . || die
		else
			touch config.rpath || die # This is from upstream autogen.sh
		fi
		eautoreconf
	fi
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-doxygen-docs
		--disable-examples
		--disable-xmms-plugin
		$([[ ${CHOST} == *-darwin* ]] && echo "--disable-asm-optimizations")
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable cpu_flags_ppc_vsx vsx)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable cxx cpplibs)
		$(use_enable debug)
		$(use_enable ogg)
		$(use_enable static-libs static)

		# cross-compile fix (bug #521446)
		# no effect if ogg support is disabled
		--with-ogg
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	if [[ ${UID} != 0 ]]; then
		emake -j1 check
	else
		ewarn "Tests will fail if ran as root, skipping."
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
