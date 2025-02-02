# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Python docutils-compatibility bridge to CommonMark"
HOMEPAGE="https://recommonmark.readthedocs.io/"
SRC_URI="https://github.com/rtfd/recommonmark/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/commonmark-0.8.1[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.14[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-0.6.0-sphinx3-1.patch"
	"${FILESDIR}/${PN}-0.6.0-sphinx3-2.patch"
)

distutils_enable_tests pytest
