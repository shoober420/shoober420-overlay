# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_PN="hexen2"

DESCRIPTION="Hexen II source port - Hammer of Thyrion"
HOMEPAGE="http://uhexen2.sourceforge.net/"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://git.code.sf.net/p/${PN}/${PN}"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa cdda +client debug dedicated demo gtk hexenworld lights +mad midi mp3 mpg123 +ogg opengl opus oss sdlaudio static +sound timidity tools tremor +vorbis +wav wildmidi cpu_flags_x86_mmx"
REQUIRED_USE="
	|| ( client dedicated tools )
	mp3? ( || ( mad mpg123 ) )
	mad? ( mp3 )
	mpg123? ( mp3 )
	midi? ( || ( timidity wildmidi ) )
	timidity? ( midi )
	wildmidi? ( midi )
	ogg? ( || ( tremor vorbis ) )
	tremor? ( ogg )
	vorbis? ( ogg )
"
GUIDEPEND="media-libs/libsdl2
	gtk? ( >=x11-libs/gtk+-2.24.25:2 )
	opengl? ( >=virtual/opengl-7.0-r1 )
	alsa? ( >=media-libs/alsa-lib-1.0.27.2 )
	midi? (
		timidity? ( >=media-sound/timidity++-2.13.2-r13 )
		wildmidi? ( >=media-sound/wildmidi-0.2.3.5 )
	)
	mp3? (
		mad? ( >=media-libs/libmad-0.15.1b-r6 )
		mpg123? ( >=media-sound/mpg123-1.18.1 )
	)
	ogg? (
		tremor? ( >=media-libs/tremor-0_pre20130223 )
		vorbis? ( >=media-libs/libvorbis-1.3.3-r1 )
	)
	opus? (
		>=media-libs/opus-1.0.2-r2
		>=media-libs/opusfile-0.4
	)"
RDEPEND="client? ( ${GUIDEPEND} )"
DEPEND="${RDEPEND}
	x86? ( cpu_flags_x86_mmx? ( || (
		>=dev-lang/nasm-2.11.06
		>=dev-lang/yasm-1.2.0
	) ) )"

PATCHES=( "${FILESDIR}/sdl2.patch" )

yesno() {
	local yesno="yes"
	for f in "$@" ; do use ${f} || yesno="no" ; done
	echo ${yesno}
}

src_prepare() {
	default
}

src_compile() {
	local g_opts=""

	use debug	&& g_opts+=" DEBUG=0"
	use demo	&& g_opts+=" DEMO=0"

	local c_opts=" \
		SDLQUAKE=2 \
		LINK_GL_LIBS=$(yesno static) \
		USE_SOUND=$(yesno sound) \
		USE_CDAUDIO=$(yesno cdda) \
		USE_ALSA=$(yesno alsa) \
		USE_OSS=$(yesno oss) \
		USE_SDLAUDIO=$(yesno sdlaudio) \
		USE_MIDI=$(yesno midi) \
		USE_CODEC_TIMIDITY=$(yesno timidity) \
		USE_CODEC_WILDMIDI=$(yesno wildmidi) \
		USE_CODEC_MP3=$(yesno mp3) \
		USE_CODEC_OPUS=$(yesno opus) \
		USE_CODEC_VORBIS=$(yesno ogg) \
		USE_CODEC_WAVE=$(yesno wav) \
		USE_X86_ASM=$(yesno x86 cpu_flags_x86_mmx) \
	"
	use mad				|| c_opts+=" MP3LIB=mpg123"
	use vorbis			|| c_opts+=" VORBISLIB=tremor"
	has_version dev-lang/nasm	|| c_opts+=" NASM=yasm"

	if use client ; then
		cd ${S}/engine/${MY_PN}
		einfo "\nBuilding UHexen2 game executable(s)"

		emake clean
		emake \
			${g_opts} \
			${c_opts} \
			h2                                              || die "emake Hexen II software failed"  # software mode is needed for original true look
#			glh2						|| die "emake Hexen II opengl failed"

		if use gtk ; then
			cd ${S}/launcher
			einfo "\nBuilding graphical launcher"

			emake clean
			emake \
				${g_opts}
		fi

		if use hexenworld ; then
			cd ${S}/engine/hexenworld
			einfo "\nBuilding Hexenworld servers"

			emake -C server clean
			emake \
				${g_opts} \
				-C server					|| die "emake HexenWorld Server failed"

			einfo "\nBuilding Hexenworld client(s)"

			emake -C client clean
			emake \
				${g_opts} \
				${c_opts} \
				${gl}hw \
				-C client 					|| die "emake Hexenworld Client failed"
		fi
	fi

	if use dedicated ; then
		cd ${S}/engine/${MY_PN}
		einfo "\nBuilding Dedicated Server"

		emake -C server clean
		emake \
			${g_opts} \
			-C server						|| die "emake Dedicated server failed"
	fi

	if use tools ; then
		cd ${S}/utils
		einfo "\nBuilding utils"

		local utils_list+="bspinfo dcc genmodel hcc jsh2color light pak qbsp qfiles texutils/bsp2wal texutils/lmp2pcx vis"
		for x in ${utils_list} ; do
			emake -C ${x} clean
			emake \
				${g_opts} \
				-C ${x}						|| die "emake ${x} failed"
		done

		if use hexenworld ; then
			cd ${S}/hw_utils
			einfo "\nBuilding Hexenworld utils"

			local hw_utils="hwmaster hwmquery hwrcon"
			for x in ${hw_utils} ; do
				emake -C ${x} clean
				emake \
					${g_opts} \
					-C ${x}					|| die "emake ${x} failed"
			done
		fi
	fi
}

src_install() {
	dodoc docs/README{,.hwcl,.hwmaster,.hwsv,.music}			|| die "dodoc failed"

	if use client ; then
		dobin engine/hexen2/hexen2              || die "hexen2 failed"    # software mode is needed for original look
#		dobin engine/hexen2/glhexen2		|| die "glhexen2 failed"

		if use gtk ; then
			dobin launcher/h2launcher	|| die "h2launcher failed"
		fi

		if use hexenworld ; then
			rm -f ${WORKDIR}/hw/pak4_readme.txt

			insinto "${dir}"
			doins -r ${WORKDIR}/hw

			dobin engine/hexenworld/server/hwsv		|| die "hwsv failed"
			dobin engine/hexenworld/client/hwcl	|| die "hwcl failed"

			doicon engine/resource/hexenworld.png			|| die "doicon hexenworld.png failed"
		fi
	fi

	if use dedicated ; then
		insinto "${dir}"/data1
		doins -r ${WORKDIR}/siege/server.cfg				|| die "doins server.cfg failed"

		dobin engine/hexen2/server/h2ded ${MY_PN}-ded		|| die "h2ded failed"
	fi

	if use tools ; then
		dobin utils/bspinfo/bspinfo					|| die "dobin bspinfo failed"
		dobin utils/dcc/dhcc						|| die "dobin dhcc failed"
		dobin utils/genmodel/genmodel					|| die "dobin genmodel failed"
		dobin utils/hcc/hcc						|| die "dobin hcc failed"
		dobin utils/jsh2color/jsh2colour				|| die "dobin jsh2colour failed"
		dobin utils/light/light						|| die "dobin light failed"
		dobin utils/pak/paklist						|| die "dobin paklist failed"
		dobin utils/pak/pakx						|| die "dobin pakx failed"
		dobin utils/qbsp/qbsp						|| die "dobin qbsp failed"
		dobin utils/qfiles/qfiles					|| die "dobin qfiles failed"
		dobin utils/texutils/lmp2pcx/lmp2pcx				|| die "dobin lmp2pcx failed"
		dobin utils/texutils/bsp2wal/bsp2wal				|| die "dobin bsp2wal failed"
		dobin utils/vis/vis						|| die "dobin vis failed"

		docinto utils
		dodoc utils/README						|| die "dodoc README failed"
		dodoc utils/dcc/dcc.txt						|| die "dodoc dcc.txt failed"
		newdoc utils/dcc/README README.dcc				|| die "newdoc README.dcc failed"
		newdoc utils/hcc/README README.hcc				|| die "newdoc README.hcc failed"
		newdoc utils/jsh2color/README README.jsh2color			|| die "newdoc README.jsh2color failed"
		newdoc utils/jsh2color/ChangeLog ChangeLog.jsh2color		|| die "newdoc Changelog.jsh2color failed"

		if use hexenworld ; then
			dobin hw_utils/hwmaster/hwmaster			|| die "dobin hwmaster failed"
			dobin hw_utils/hwmquery/hwmquery			|| die "dobin hwmquery failed"
			dobin hw_utils/hwrcon/{hwrcon,hwterm}			|| die "dobin hwrcon/hwterm failed"

			docinto utils
			dodoc hw_utils/hwmquery/hwmquery.txt			|| die "dodoc hwmquery.txt failed"
			dodoc hw_utils/hwrcon/{hwrcon,hwterm}.txt		|| die "dodoc hwrcon/hwterm.txt failed"
		fi
	fi
}
