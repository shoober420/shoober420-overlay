# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ALSA ucm configuration files"
HOMEPAGE="https://alsa-project.org/wiki/Main_Page"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/alsa-project/${PN}.git"
fi

LICENSE="BSD"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

RDEPEND="!<media-libs/alsa-lib-1.2.1"
DEPEND="${RDEPEND}"

#PATCHES=( "${FILESDIR}/${PN}-1.2.5-hda-Intel-the-lookups-are-supported-from-syntax-4.patch" ) # bug #793410

src_install() {
	insinto /usr/share/alsa
	doins -r ucm{,2}
}
