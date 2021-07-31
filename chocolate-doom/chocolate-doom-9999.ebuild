# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )

inherit autotools prefix python-any-r1 xdg

DESCRIPTION="A Doom source port that is minimalist and historically accurate"
HOMEPAGE="https://www.chocolate-doom.org"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
fi

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion doc libsamplerate +midi png vorbis"

DEPEND="
	media-libs/libsdl2[video]
	media-libs/sdl2-mixer[midi?,vorbis?]
	media-libs/sdl2-net
	libsamplerate? ( media-libs/libsamplerate )
	png? ( media-libs/libpng:= )"
RDEPEND="${DEPEND}"
BDEPEND="
	bash-completion? ( ${PYTHON_DEPS} )
	doc? ( ${PYTHON_DEPS} )"

S="${WORKDIR}/${PN}-${PV}"

#PATCHES=(
#	"${FILESDIR}/chocolate-doom-3.0.1-overhaul-manpages-add-parameters.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-further-manpage-substitutions-and-fixes.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-bash-completion-run-docgen-with-z-argument.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-install-AppStream-metadata-into-the-proper-location.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-Update-AppStream-XML-files-to-current-0.11-standards.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-bash-completion-Build-from-actual-shell-script-templ.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-configure-add-AM_PROG_AR-macro.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-bash-completion-always-install-into-datadir-bash-com.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-Update-to-latest-AppStream-formerly-AppData-standard.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-use-reverse-DNS-naming-for-installing-.desktop-files.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-Remove-redundant-demoextend-definition.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-Introduce-configure-options-for-bash-completion-doc-.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-Add-support-for-usr-share-doom-IWAD-search-path.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-Update-documentation-about-usr-share-doom-IWAD-locat.patch"
#	"${FILESDIR}/chocolate-doom-3.0.1-Fix-Python-check.patch"
#)

DOCS=(
	"AUTHORS"
	"ChangeLog"
	"NEWS.md"
	"NOT-BUGS.md"
	"PHILOSOPHY.md"
	"README.md"
	"README.Music.md"
	"README.Strife.md"
)

src_prepare() {
	default

	hprefixify src/d_iwad.c

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable bash-completion) \
		$(use_enable doc) \
		--disable-fonts \
		--disable-icons \
		$(use_with libsamplerate) \
		$(use_with png libpng)
}

src_install() {
	emake DESTDIR="${D}" install

	# Remove redundant documentation files
	rm -r "${ED}/usr/share/doc/"* || die

#	einstalldocs
}
