# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="An extension which adds links to GitHub users, repositories, issues and commits"
HOMEPAGE="https://github.com/Python-Markdown/github-links"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	dev-python/markdown[${PYTHON_USEDEP}]
"
