# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib java-pkg-opt-2

DESCRIPTION="MMX, SSE, and SSE2 SIMD accelerated JPEG library"
HOMEPAGE="https://libjpeg-turbo.org/ https://sourceforge.net/projects/libjpeg-turbo/"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
fi

LICENSE="BSD IJG ZLIB"
SLOT="0/0.2"
IUSE="java static-libs"

ASM_DEPEND="|| ( dev-lang/nasm dev-lang/yasm )"

COMMON_DEPEND="!media-libs/jpeg:0
	!media-libs/jpeg:62"

BDEPEND=">=dev-util/cmake-3.16.5
	amd64? ( ${ASM_DEPEND} )
	x86? ( ${ASM_DEPEND} )
	amd64-fbsd? ( ${ASM_DEPEND} )
	x86-fbsd? ( ${ASM_DEPEND} )
	amd64-linux? ( ${ASM_DEPEND} )
	x86-linux? ( ${ASM_DEPEND} )
	x64-macos? ( ${ASM_DEPEND} )
	x64-cygwin? ( ${ASM_DEPEND} )"

DEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.8:* )"

RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )"

MULTILIB_WRAPPED_HEADERS=( /usr/include/jconfig.h )

src_prepare() {

	default

	cmake_src_prepare
	java-pkg-opt-2_src_prepare
}

multilib_src_configure() {
	if multilib_is_native_abi && use java ; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		export JNI_CFLAGS="$(java-pkg_get-jni-cflags)"
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_DEFAULT_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DENABLE_STATIC="$(usex static-libs)"
		-DWITH_JAVA="$(multilib_native_usex java)"
		-DWITH_MEM_SRCDST=ON
	)

	# bug #420239, bug #723800
	[[ ${ABI} == "x32" ]] && mycmakeargs+=( -DWITH_SIMD=OFF )

	# mostly for Prefix, ensure that we use our yasm if installed and
	# not pick up host-provided nasm
	has_version dev-lang/yasm && ! has_version dev-lang/nasm && \
		mycmakeargs+=( -DCMAKE_ASM_NASM_COMPILER=$(type -P yasm) )

	cmake_src_configure
}

multilib_src_install() {
	cmake_src_install

	if multilib_is_native_abi && use java ; then
		rm -rf "${ED}"/usr/classes || die
		java-pkg_dojar java/turbojpeg.jar
	fi
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die

	local -a DOCS=( README.md ChangeLog.md )
	einstalldocs

#	docinto html
#	dodoc -r "${S}"/doc/html/*

	if use java; then
		docinto html/java
		dodoc -r "${S}"/java/doc/*
		newdoc "${S}"/java/README README.java
	fi
}
