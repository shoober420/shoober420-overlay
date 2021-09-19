# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Joonas Niilola (juippis)
# Vincent Grande (shoober420)

EAPI=6

# Define what default functions to run
ETYPE="sources"

# No 'experimental' USE flag provided, but we still want to use genpatches
K_EXP_GENPATCHES_NOUSE="1"

# Pull latest genpatches for consistency
K_GENPATCHES_VER="1"

# -pf already sets EXTRAVERSION to kernel Makefile
K_NOSETEXTRAVERSION="1"

# Not supported by the Gentoo security team
K_SECURITY_UNSUPPORTED="1"

# We want the very basic patches from gentoo-sources, experimental patch is
# already included in pf-sources
K_WANT_GENPATCHES="base extras"

SHPV="5.14"
SHPPV="r2"

inherit git-r3 kernel-2 optfeature

DESCRIPTION="Linux kernel fork that includes the pf-kernel patchset and Gentoo's genpatches"
HOMEPAGE="https://gitlab.com/post-factum/pf-kernel/-/wikis/README
	  https://dev.gentoo.org/~mpagano/genpatches/"

EGIT_REPO_URI="https://gitlab.com/post-factum/pf-kernel"
EGIT_BRANCH="pf-${SHPV}"
EGIT_CHECKOUT_DIR="${WORKDIR}/linux-${P}"

SRC_URI="
	https://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-${SHPV}-${K_GENPATCHES_VER}.base.tar.xz
	https://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-${SHPV}-${K_GENPATCHES_VER}.extras.tar.xz
	https://gitlab.com/alfredchen/projectc/raw/master/${SHPV}/prjc_v${SHPV}-${SHPPV}.patch"

S="${WORKDIR}/linux-${P}"

PATCHES=( "${DISTDIR}/prjc_v${SHPV}-${SHPPV}.patch" )

K_EXTRAEINFO="For more info on pf-sources and details on how to report problems,
	see: ${HOMEPAGE}."

pkg_setup() {
	ewarn ""
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the pf developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn ""

	kernel-2_pkg_setup
}

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	# kernel-2_src_prepare doesn't apply PATCHES().
	default
}

pkg_postinst() {
	kernel-2_pkg_postinst

	optfeature "userspace KSM helper" sys-process/uksmd
}
