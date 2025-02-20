TERMUX_PKG_HOMEPAGE=https://github.com/topgrade-rs/topgrade/
TERMUX_PKG_DESCRIPTION="Upgrade all the things"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@laurentlbm"
TERMUX_PKG_VERSION="14.0.0"
TERMUX_PKG_SRCURL="https://github.com/topgrade-rs/topgrade/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5635080f7b8d092c107b2b49a18b707a275bd07c6f121778d49b9d147eef9891
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	rm -f pyproject.toml
}

termux_step_post_massage() {
	mkdir -p ./share/bash-completion/completions
	mkdir -p ./share/zsh/site-functions
	mkdir -p ./share/fish/vendor_completions.d
	mkdir -p ./share/man/man1
}

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		${TERMUX_PREFIX}/bin/topgrade --gen-completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/topgrade
		${TERMUX_PREFIX}/bin/topgrade --gen-completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_topgrade
		${TERMUX_PREFIX}/bin/topgrade --gen-completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/topgrade.fish
		${TERMUX_PREFIX}/bin/topgrade --gen-manpage > ${TERMUX_PREFIX}/share/man/man1/topgrade.1
		exit 0
	EOF
	cat <<-EOF > ./prerm
		#!${TERMUX_PREFIX}/bin/sh
		rm -f ${TERMUX_PREFIX}/share/bash-completion/completions/topgrade
		rm -f ${TERMUX_PREFIX}/share/zsh/site-functions/_topgrade
		rm -f ${TERMUX_PREFIX}/share/fish/vendor_completions.d/topgrade.fish
		rm -f ${TERMUX_PREFIX}/share/man/man1/topgrade.1
		exit 0
	EOF
}
