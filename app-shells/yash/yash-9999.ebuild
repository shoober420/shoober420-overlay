# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PLOCALES="en ja"

inherit flag-o-matic l10n toolchain-funcs

DESCRIPTION="Yash is a POSIX-compliant command line shell"
HOMEPAGE="https://yash.osdn.jp/"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/magicant/${PN}.git"
else
        MY_PV=${PV/_rc/-rc}
        SRC_URI="mirror://sourceforge.jp/${PN}/74064/${P}.tar.xz"
        KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls test"
RESTRICT="!test? ( test )"

RDEPEND="app-text/asciidoc
         sys-libs/ncurses:=
         nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )
	test? ( sys-apps/ed )"

src_configure() {
	append-cflags -std=c99

	sh ./configure \
		--prefix="${EPREFIX}"/usr \
		--exec-prefix="${EPREFIX}" \
		$(use_enable nls) \
		CC=$(tc-getCC) \
		LINGUAS="$(l10n_get_locales | sed "s/en/en@quot en@boldquot/")" \
		|| die
}
