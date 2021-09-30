# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

UTP="v469b"
UTPP="469b"

DESCRIPTION="Unreal Tournament 99 community patch"
HOMEPAGE="www.oldunreal.com"
SRC_URI="https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/${UTP}/OldUnreal-UTPatch${UTPP}-Linux.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
PROPERTIES="interactive"

RDEPEND="virtual/opengl
	media-libs/libsdl2"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	# install data patch
	cd "${WORKDIR}"
	insinto /usr/share/games/ut99
	doins -r *
}
