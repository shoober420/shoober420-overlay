# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libidn.asc
inherit autotools multilib-minimal toolchain-funcs verify-sig

DESCRIPTION="An implementation of the IDNA2008 specifications (RFCs 5890, 5891, 5892, 5893)"
HOMEPAGE="https://www.gnu.org/software/libidn/#libidn2 https://gitlab.com/libidn/libidn2"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://gitlab.com/libidn/${PN}.git"
fi

LICENSE="GPL-2+ LGPL-3+"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="
	dev-libs/libunistring:=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	sys-apps/help2man
        dev-util/gengetopt
	verify-sig? ( app-crypt/openpgp-keys-libidn )
"

src_prepare() {
	default

	if [[ ${CHOST} == *-darwin* ]] ; then
		# Darwin ar chokes when TMPDIR doesn't exist (as done for some
		# reason in the Makefile)
		sed -i -e '/^TMPDIR = /d' Makefile.in || die
		export TMPDIR="${T}"
	fi

	multilib_copy_sources
        ./bootstrap || die
}

multilib_src_configure() {
	local myeconfargs=(
		CC_FOR_BUILD="$(tc-getBUILD_CC)"
		$(use_enable static-libs static)
		--disable-doc
		--disable-gcc-warnings
		--disable-gtk-doc
              )
        ECONF_SOURCE="${S}" econf "${libconf[@]}" "${myeconfargs[@]}"
}

multilib_src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
