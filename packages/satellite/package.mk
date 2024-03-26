PACKAGE_NAME="satellite"
PACKAGE_VERSION="1.2.0"
PACKAGE_SRC="https://github.com/rhasspy/wyoming-satellite/archive/v${PACKAGE_VERSION}.tar.gz"
PACAKGE_DEPENDS="python3 aec-cmdline"

preconfigure_package() {
	FILE="v${PACKAGE_VERSION}.tar.gz"
	if [ ! -e "${PACKAGE_SRC_DOWNLOAD_DIR}/${FILE}" ]; then
		echo_info "downloading wyoming-satellite - ${FILE}"
                wget -O ${PACKAGE_SRC_DOWNLOAD_DIR}/${FILE} "${PACKAGE_SRC}"
	fi
}

install_package() {
	mkdir -p ${STAGING_DIR}/usr/share/satellite/

	cp -rv ${PACKAGE_SRC_DIR}/sounds ${PACKAGE_SRC_DIR}/wyoming_satellite ${PACKAGE_SRC_DIR}/script ${STAGING_DIR}/usr/share/satellite/

	cp -rv ${PACKAGE_DIR}/config/venv ${STAGING_DIR}/usr/share/satellite/.venv
	cp -v ${PACKAGE_DIR}/config/launcher ${STAGING_DIR}/usr/share/satellite/launcher
}

postinstall_package() {
	cp -v ${PACKAGE_DIR}/config/satellite.init ${STAGING_DIR}/etc/init.d/listener
	ln -sf ../init.d/listener ${STAGING_DIR}/etc/rc.d/S98listener

	TRIGGERHAPPY_FOLDER="${STAGING_DIR}/etc/triggerhappy/triggers.d"
	mkdir -p ${TRIGGERHAPPY_FOLDER}

	cp -v ${PACKAGE_DIR}/config/triggerhappy.conf ${TRIGGERHAPPY_FOLDER}/listener.conf
}
