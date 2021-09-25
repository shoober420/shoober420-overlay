# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils desktop flag-o-matic toolchain-funcs

DESCRIPTION="return to castle wolfenstein source port based on ioquake3"
HOMEPAGE="https://github.com/iortcw/iortcw"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/iortcw/iortcw.git"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
# "smp" is omitted, because currently it does not work.
IUSE="opengl +openal curl vorbis voice mumble"

UIDEPEND="virtual/opengl
	media-libs/libsdl2[sound,video,X,opengl]
	virtual/jpeg:0
	openal? ( media-libs/openal )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	voice? ( media-libs/speex )
	curl? ( net-misc/curl )
"

DEPEND="opengl? ( ${UIDEPEND} )
"

UIRDEPEND="voice? ( mumble? ( media-sound/mumble ) )
"

RDEPEND="${DEPEND}
	opengl? ( ${UIRDEPEND} )
"

S="${WORKDIR}/${PN}-${PV}/SP"

my_arch() {
	case "${ARCH}" in
		x86)    echo "i386" ;;
		amd64)  echo "x86_64" ;;
		*)      tc-arch-kernel ;;
	esac
}

my_platform() {
	usex kernel_linux linux freebsd
}

src_prepare() {
	default

	tc-export CC
}

src_compile() {

	buildit() { use $1 && echo 1 || echo 0 ; }

	# Workaround for used zlib macro, wrt bug #449510
        append-flags -DOF=_Z_OF

	# OPTIMIZE is disabled in favor of CFLAGS.
	#
	# TODO: BUILD_CLIENT_SMP=$(buildit smp)
	emake \
		ARCH="$(my_arch)" \
		V=0 \
		USE_INTERNAL_LIBS=0 \
		BUILD_CLIENT=$(buildit opengl) \
		BUILD_GAME_QVM=0 \
		BUILD_GAME_SO=0 \
		DEFAULT_BASEDIR="${EPREFIX}/usr/$(get_libdir)/rtcw" \
		FULLBINEXT="" \
		GENERATE_DEPENDENCIES=0 \
		OPTIMIZE="" \
		PLATFORM="$(my_platform)" \
		TOOLS_CC="$(tc-getBUILD_CC)" \
		USE_CODEC_VORBIS=$(buildit vorbis) \
		USE_CODEC_OPUS=0 \
		USE_CURL=$(buildit curl) \
		USE_CURL_DLOPEN=0 \
		USE_INTERNAL_JPEG=0 \
		USE_INTERNAL_SPEEX=0 \
		USE_INTERNAL_ZLIB=0 \
		USE_LOCAL_HEADERS=0 \
		USE_MUMBLE=$(buildit mumble) \
		USE_OPENAL=$(buildit openal) \
		USE_OPENAL_DLOPEN=0 \
		USE_VOIP=$(buildit voice)
}

src_install() {
#	dodoc ChangeLog id-readme.txt md4-readme.txt README.md TODO voip-readme.txt
#	if use voice ; then
#		dodoc voip-readme.txt
#	fi

#	if use opengl || ! use dedicated ; then
#		doicon misc/rtcw.svg
#		make_desktop_entry iortcw "Return to Castle Wolfenstein"
#	fi

	cd build/release-$(my_platform)-$(my_arch) || die
	local exe
	for exe in iowolfsp ; do
		if [[ -x ${exe} ]] ; then
			dobin ${exe}
		fi
	done

	# Install renderer libraries, wrt bug #449510
	# this should be done through 'dogameslib', but
	# for this some files need to be patched
	exeinto "/usr/$(get_libdir)/rtcw"
	doexe renderer*.so
}
