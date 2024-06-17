# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib-minimal autotools #preserve-libs

MY_PV=${PV/_rc/-rc}
MY_P=${PN}-${MY_PV}

DESCRIPTION="a portable, high level programming interface to various calling conventions"
HOMEPAGE="https://sourceware.org/libffi/"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
fi

LICENSE="MIT"
SLOT="0/7" # SONAME=libffi.so.8
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug exec-static-trampoline pax_kernel static-libs test"

RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND=""
BDEPEND="test? ( dev-util/dejagnu )"

DOCS="ChangeLog* README.md"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.1-o-tmpfile-eacces.patch #529044
#	"${FILESDIR}"/${PN}-3.3_rc0-ppc-macos-go.patch
#	"${FILESDIR}"/${PN}-3.3-power7.patch
#	"${FILESDIR}"/${PN}-3.3-power7-memcpy.patch
#	"${FILESDIR}"/${PN}-3.3-power7-memcpy-2.patch
#	"${FILESDIR}"/${PN}-3.3-ppc-int128.patch
#	"${FILESDIR}"/${PN}-3.3-ppc-vector-offset.patch
#	"${FILESDIR}"/${PN}-3.3-compiler-vendor-quote.patch
)

#S=${WORKDIR}/${PN}-${PV}

ECONF_SOURCE=${S}

src_prepare() {
	default
	if [[ ${CHOST} == arm64-*-darwin* ]] ; then
		# ensure we use aarch64 asm, not x86 on arm64
		sed -i -e 's/aarch64\*-\*-\*/arm64*-*-*|&/' \
			configure configure.host || die
	fi
        
        eautoreconf
}

multilib_src_configure() {
	use userland_BSD && export HOST="${CHOST}"
	# --includedir= path maintains a few properties:
	# 1. have stable name across libffi versions: some packages like
	#    dev-lang/ghc or kde-frameworks/networkmanager-qt embed
	#    ${includedir} at build-time. Don't require those to be
	#    rebuilt unless SONAME changes. bug #695788
	#
	#    We use /usr/.../${PN} (instead of former /usr/.../${P}).
	#
	# 2. have ${ABI}-specific location as ffi.h is target-dependent.
	#
	#    We use /usr/$(get_libdir)/... to have ABI identifier.
	econf \
		--includedir="${EPREFIX}"/usr/$(get_libdir)/${PN}/include \
		--disable-multi-os-directory \
		$(use_enable exec-static-trampoline exec-static-tramp) \
		$(use_enable static-libs static) \
		$(use_enable pax_kernel pax_emutramp) \
		$(use_enable debug)
}

multilib_src_install_all() {
	find "${ED}" -name "*.la" -delete || die
	einstalldocs
}

#pkg_preinst() {
#	preserve_old_lib /usr/$(get_libdir)/libffi.so.7
#	preserve_old_lib /usr/$(get_libdir)/libffi.so.6
#}

#pkg_postinst() {                                                                                                                                                                                
#        preserve_old_lib_notify /usr/$(get_libdir)/libffi.so.7
#	preserve_old_lib_notify /usr/$(get_libdir)/libffi.so.6                                                                                                                                       
#}
