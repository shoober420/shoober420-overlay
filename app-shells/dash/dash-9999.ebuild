# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic autotools toolchain-funcs

DESCRIPTION="Debian Almquist Shell"
HOMEPAGE="http://gondor.apana.org.au/~herbert/dash/"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/${PN}/${PN}.git"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="libedit static"

BDEPEND="virtual/pkgconfig"
RDEPEND="!static? ( libedit? ( dev-libs/libedit ) )"
DEPEND="${RDEPEND}
	libedit? ( static? ( dev-libs/libedit[static-libs] ) )"

src_prepare() {
	default
        eautoreconf

	# Fix the invalid sort
	sed -i -e 's/LC_COLLATE=C/LC_ALL=C/g' src/mkbuiltins
}

src_configure() {
	if [[ ${CHOST} == *-solaris* ]] ; then
		# don't redefine stat, open, dirent, etc. on Solaris
		export ac_cv_func_stat64=yes
		export ac_cv_func_open64=yes

		# if your headers strictly adhere to POSIX, you'll need this too
		[[ ${CHOST##*solaris2.} -le 10 ]] && append-cppflags -DNAME_MAX=255
	fi
	if [[ ${CHOST} == powerpc-*-darwin* ]] ; then
		sed -i -e 's/= stpncpy(s, \([^,]\+\), \([0-9]\+\))/+= snprintf(s, \2, "%s", \1)/' \
			src/jobs.c || die
	fi
	append-cppflags -DJOBS=$(usex libedit 1 0)
	use static && append-ldflags -static
	# Do not pass --enable-glob due to #443552.
	local myeconfargs=(
		CC_FOR_BUILD="$(tc-getBUILD_CC)"
		--bindir="${EPREFIX}"/bin
		--enable-fnmatch
		$(use_with libedit)
	)
	econf "${myeconfargs[@]}"
}
