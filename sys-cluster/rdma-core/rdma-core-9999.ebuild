# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..10} )

inherit cmake python-single-r1 udev systemd

DESCRIPTION="Userspace components for the Linux Kernel's drivers/infiniband subsystem"
HOMEPAGE="https://github.com/linux-rdma/rdma-core"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linux-rdma/rdma-core"
else
	SRC_URI="https://github.com/linux-rdma/rdma-core/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="|| ( GPL-2 ( CC0-1.0 MIT BSD BSD-with-attribution ) )"
SLOT="0"
IUSE="neigh python static-libs systemd valgrind"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
	virtual/libudev:=
	neigh? ( dev-libs/libnl:3 )
	systemd? ( sys-apps/systemd:= )
	valgrind? ( dev-util/valgrind )
	python? ( ${PYTHON_DEPS} )"

DEPEND="${COMMON_DEPEND}
	python? (
		$(python_gen_cond_dep '
			dev-python/cython[${PYTHON_USEDEP}]
		')
	)"

RDEPEND="${COMMON_DEPEND}
	!sys-fabric/infiniband-diags
	!sys-fabric/libibverbs
	!sys-fabric/librdmacm
	!sys-fabric/libibumad
	!sys-fabric/ibacm
	!sys-fabric/libibmad
	!sys-fabric/srptools
	!sys-fabric/infinipath-psm
	!sys-fabric/libcxgb3
	!sys-fabric/libcxgb4
	!sys-fabric/libmthca
	!sys-fabric/libmlx4
	!sys-fabric/libmlx5
	!sys-fabric/libocrdma
	!sys-fabric/libnes"

BDEPEND="virtual/pkgconfig"

pkg_setup() {
	use python && python-single-r1_pkg_setup

}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}"/etc
		-DCMAKE_INSTALL_RUNDIR=/run
		-DCMAKE_INSTALL_SHAREDSTATEDIR=/var/lib
		-DCMAKE_INSTALL_UDEV_RULESDIR="${EPREFIX}""$(get_udevdir)"/rules.d
		-DCMAKE_INSTALL_SYSTEMD_SERVICEDIR="$(systemd_get_systemunitdir)"
		-DCMAKE_DISABLE_FIND_PACKAGE_Systemd="$(usex systemd no yes)"
		-DENABLE_VALGRIND="$(usex valgrind)"
		-DENABLE_RESOLVE_NEIGH="$(usex neigh)"
		-DENABLE_STATIC="$(usex static-libs)"
		-DNO_PYVERBS="$(usex python OFF ON)"
		-DNO_MAN_PAGES=1
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	udev_dorules "${ED}"/etc/udev/rules.d/70-persistent-ipoib.rules
	rm -r "${ED}"/etc/{udev,init.d} || die

	if use neigh; then
		newinitd "${FILESDIR}"/ibacm.init ibacm
		newinitd "${FILESDIR}"/iwpmd.init iwpmd
	fi

	newinitd "${FILESDIR}"/srpd.init srpd

	use python && python_optimize
}
