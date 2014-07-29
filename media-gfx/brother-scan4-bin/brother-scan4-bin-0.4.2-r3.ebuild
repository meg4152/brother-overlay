# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

#based on ebuilds from the funtoo and flow overlay

inherit rpm versionator


MY_PR="3"
MY_PN=brscan4

DESCRIPTION="Brother scanner tool (brscan4) 64bit"

HOMEPAGE="http://support.brother.com"

#this version is for x86_64
SRC_URI="amd64? ( http://download.brother.com/welcome/dlf006648/${MY_PN}-${PV}-${MY_PR}.x86_64.rpm )
x86? (	http://download.brother.com/welcome/dlf006647/${MY_PN}-${PV}-${MY_PR}.i386.rpm ) "
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="-* x86 amd64"

IUSE=""

RESTRICT="mirror strip"

DEPEND="media-gfx/sane-backends[usb]"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_unpack() {
	rpm_unpack ${A}
}

src_install() {
	cp -r usr "${D}" || die

	mkdir -p "${D}/etc/sane.d/dll.d"
	echo "brother4" >"${D}/etc/sane.d/dll.d/brscan4.conf"
}

pkg_postinst() {
	"${ROOT}/opt/brother/scanner/brscan4/setupSaneScan4" -i
	#this is already done with the previous line
	#einfo "In order to use scanner you need to add it first with setupSaneScan4."

	einfo "Example with MFC-9340CW over network:"
	einfo "	/opt/brother/scanner/brscan4/brsaneconfig4 -a name=mfcscan model=MFC-9340CW ip=192.168.10.6"
	einfo "	chmod 644 /opt/brother/scanner/brscan4/brsanenetdevice4.cfg"

	#only for usb access
#	elog "You may need to be in the scanner or plugdev group in order to use the scanner"
}

pkg_prerm() {
	${ROOT}/opt/brother/scanner/brscan4/setupSaneScan4 -e
}
