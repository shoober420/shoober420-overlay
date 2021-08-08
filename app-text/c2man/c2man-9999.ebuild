# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

### you need to run "sh Configure" in the source directory to generate a new "Makefile" and "config.sh" after certain GCC updates

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Extracts C source code comments into manual documentation"
HOMEPAGE="https://github.com/fribidi/c2man"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/fribidi/${PN}.git"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND=""
DEPEND=""
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default
        cp ${FILESDIR}/Makefile ${WORKDIR}/${PN}-${PV}
        cp ${FILESDIR}/config.sh ${WORKDIR}/${PN}-${PV}
}

src_compile() {
       emake
}

src_install() {
       dobin c2man
}
