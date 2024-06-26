# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib multilib-minimal

MY_P="SDL2_image-${PV}"
DESCRIPTION="Image file loading library"
HOMEPAGE="https://www.libsdl.org/projects/SDL_image/"

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/libsdl-org/SDL_image.git"
fi

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="gif jpeg png static-libs tiff webp"

RDEPEND="
	>=media-libs/libsdl2-2.0.9[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	png? ( >=media-libs/libpng-1.6.10:0[${MULTILIB_USEDEP}] )
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-3.9.7-r1:0[${MULTILIB_USEDEP}] )
	webp? ( >=media-libs/libwebp-0.3.0[${MULTILIB_USEDEP}] )"
DEPEND=${RDEPEND}

S=${WORKDIR}/${PN}-${PV}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		--disable-sdltest
		--enable-bmp
		$(use_enable gif)
		$(use_enable jpeg jpg)
		--disable-jpg-shared
		--enable-lbm
		--enable-pcx
		$(use_enable png)
		--disable-png-shared
		--enable-pnm
		--enable-tga
		$(use_enable tiff tif)
		--disable-tif-shared
		--enable-xcf
		--enable-xpm
		--enable-xv
		$(use_enable webp)
		--disable-webp-shared
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	multilib_is_native_abi && newbin .libs/showimage$(get_exeext) showimage2$(get_exeext)
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt
	find "${ED}" -type f -name "*.la" -delete || die

	dosym /usr/lib/libSDL2_image-2.0.so.0 /usr/lib/libSDL_image-2.0.so
        dosym /usr/lib64/libSDL2_image-2.0.so.0 /usr/lib64/libSDL_image-2.0.so
        dosym /usr/lib/libSDL2_image-2.0.so.0 /usr/lib/libSDL_image-2.0.so.0
        dosym /usr/lib64/libSDL2_image-2.0.so.0 /usr/lib64/libSDL_image-2.0.so.0
}
