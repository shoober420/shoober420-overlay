# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A high-level decoding and seeking API for .opus files"
HOMEPAGE="https://www.opus-codec.org/"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3 autotools
        EGIT_REPO_URI="https://github.com/xiph/${PN}.git"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="doc fixed-point +float +http static-libs"

RDEPEND="media-libs/libogg
	media-libs/opus
	http? (
		dev-libs/openssl:0=
	)"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

REQUIRED_USE="^^ ( fixed-point float )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc)
		$(use_enable fixed-point)\
		$(use_enable float)
		$(use_enable http)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}
