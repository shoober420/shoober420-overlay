# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper xdg-utils

RTCW=1.51c

DESCRIPTION="Return to Castle Wolfenstein with ioquake3 improvements"
HOMEPAGE="https://github.com/iortcw/iortcw/"
SRC_URI="https://github.com/iortcw/iortcw/releases/download/${RTCW}/patch-data-${PV}.zip"

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
	cd "${WORKDIR}/main"
	insinto /usr/lib64/rtcw/main
	doins *
}
