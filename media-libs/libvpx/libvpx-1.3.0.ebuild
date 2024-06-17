# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
inherit eutils multilib toolchain-funcs multilib-minimal

LIBVPX_TESTDATA_VER=1.3.0

SRC_URI="https://github.com/webmproject/${PN}/archive/v${PV}.tar.gz"
KEYWORDS="amd64 x86"

DESCRIPTION="WebM VP8 Codec SDK"
HOMEPAGE="http://www.webmproject.org"

LICENSE="BSD"
SLOT="1"
IUSE="altivec avx avx2 doc mmx postproc sse sse2 sse3 ssse3 sse4_1 static-libs test +threads"

RDEPEND="abi_x86_32? ( !app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="abi_x86_32? ( dev-lang/yasm )
	abi_x86_64? ( dev-lang/yasm )
	x86-fbsd? ( dev-lang/yasm )
	amd64-fbsd? ( dev-lang/yasm )
	doc? (
		app-doc/doxygen
		dev-lang/php
	)
"

REQUIRED_USE="
	sse? ( sse2 )
	sse2? ( mmx )
	ssse3? ( sse2 )
	"

#src_prepare() {
#	epatch "${FILESDIR}/libvpx-1.3.0-dash.patch"
#	epatch "${FILESDIR}/libvpx-1.3.0-sparc-configure.patch" # 501010
#}

src_configure() {
	# http://bugs.gentoo.org/show_bug.cgi?id=384585
        # https://bugs.gentoo.org/show_bug.cgi?id=465988
        # copied from php-pear-r1.eclass
        addpredict /usr/share/snmp/mibs/.index
        addpredict /var/lib/net-snmp/
        addpredict /var/lib/net-snmp/mib_indexes
        addpredict /session_mm_cli0.sem
	multilib-minimal_src_configure
}

multilib_src_configure() {
	unset CODECS #357487

	# let the build system decide which AS to use (it honours $AS but
	# then feeds it with yasm flags without checking...) #345161
	tc-export AS
	case "${CHOST}" in
		i?86*) export AS=yasm;;
		x86_64*) export AS=yasm;;
	esac

	# Build with correct toolchain.
	tc-export CC CXX AR NM
	# Link with gcc by default, the build system should override this if needed.
	export LD="${CC}"

#	local myconf
#	if [ "${ABI}" = "${DEFAULT_ABI}" ] ; then
#		myconf+=" $(use_enable doc install-docs) $(use_enable doc docs)"
#	else
#		# not needed for multilib and will be overwritten anyway.
#		myconf+=" --disable-examples --disable-install-docs --disable-docs"
#	fi

	local myconfargs=(
		--prefix="${EPREFIX}"/usr 
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--enable-pic
		--enable-vp8
		--enable-vp9
		--enable-shared
		--enable-runtime-cpu-detect
		--disable-examples
                --disable-install-docs
                --disable-docs
		--extra-cflags="${CFLAGS}"
		$(use_enable postproc)
		$(use_enable static-libs static)
		$(use_enable test unit-tests)
		$(use_enable threads multithread)
	)

	echo "${S}"/configure "${myconfargs[@]}" >&2
        "${S}"/configure "${myconfargs[@]}"
}

multilib_src_compile() {
	# build verbose by default and do not build examples that will not be installed
	emake verbose=yes GEN_EXAMPLES=
}

#multilib_src_test() {
#	LD_LIBRARY_PATH="${BUILD_DIR}:${LD_LIBRARY_PATH}" \
#		emake verbose=yes GEN_EXAMPLES=  LIBVPX_TEST_DATA_PATH="${WORKDIR}/${PN}-testdata" test
#}

multilib_src_install() {
#	emake verbose=yes GEN_EXAMPLES= DESTDIR="${D}" install
#	[ "${ABI}" = "${DEFAULT_ABI}" ] && use doc && dohtml docs/html/*
	poop
}
