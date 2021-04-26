# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7,8,9} pypy3 )

inherit python-single-r1

DESCRIPTION="ANother Auto NICe daemon"
HOMEPAGE="https://github.com/Nefelim4ag/Ananicy"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Nefelim4ag/${PN}.git"
else
	MY_PV=${PV/_rc/-rc}
	SRC_URI="https://github.com/Nefelim4ag/Ananicy/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND="${PYTHON_DEPS}"

DOCS=( README.md )

src_prepare(){
	sed -e 's|\/sbin\/sysctl|\/usr\/sbin\/sysctl|g' -i ananicy.service || die
	default
}

src_compile() {
	return
}

src_install() {
	emake PREFIX="${ED}" install
	python_fix_shebang "${ED}/usr/bin/ananicy"
	einstalldocs
	
	#openrc
	newinitd ${FILESDIR}/${PN}.initd ${PN} 
	
	#runit
	insinto /etc/runit/sv/${PN}; newins ${FILESDIR}/${PN}.runrunit run
	insinto /etc/runit/sv/${PN}; newins ${FILESDIR}/${PN}.start start
	insinto /etc/runit/sv/${PN}; newins ${FILESDIR}/${PN}.finish finish
	
	#s6
	insinto /etc/s6/sv/${PN}; newins ${FILESDIR}/${PN}.runs6 run
	insinto /etc/s6/sv/${PN}; newins ${FILESDIR}/${PN}.type type
	insinto /etc/s6/sv/${PN}; newins ${FILESDIR}/${PN}.finish finish
}
