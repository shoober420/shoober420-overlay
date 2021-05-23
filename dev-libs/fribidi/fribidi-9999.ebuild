# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson multilib-minimal toolchain-funcs xdg

DESCRIPTION="A free implementation of the unicode bidirectional algorithm"
HOMEPAGE="https://fribidi.org/"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
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

        xdg_src_prepare
}

multilib_src_configure() {
	      local mesonargs=(
		            -Ddocs=false
                -Dtests=false
                -Ddeprecated=false
	)
	      meson_src_configure
}

multilib_src_compile() {
         meson_src_compile
}

multilib_src_install() {
         meson_src_install
}
