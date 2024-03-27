PACKAGE_NAME="openwakeword"
PACKAGE_VERSION="1.10.0"
PACKAGE_SRC="https://github.com/rhasspy/wyoming-openwakeword/archive/v${PACKAGE_VERSION}.tar.gz"
PACAKGE_DEPENDS="python3 aec-cmdline"

preconfigure_package() {
	FILE="v${PACKAGE_VERSION}.tar.gz"
	if [ ! -e "${PACKAGE_SRC_DOWNLOAD_DIR}/${FILE}" ]; then
		echo_info "downloading wyoming-openwakeword - ${FILE}"
                wget -O ${PACKAGE_SRC_DOWNLOAD_DIR}/${FILE} "${PACKAGE_SRC}"
	fi
}

install_package() {
	mkdir -p ${STAGING_DIR}/usr/share/openwakeword/

	# create package build-packages/openwakeword-data.tar.gz for manual transfer to /data folder on lx06
	mkdir /xiaoai/build-packages/openwakeword-data
	cp -rv ${PACKAGE_SRC_DIR}/wyoming_openwakeword ${PACKAGE_SRC_DIR}/script /xiaoai/build-packages/openwakeword-data

	mkdir -p /xiaoai/build-packages/openwakeword-data/.venv/include  /xiaoai/build-packages/openwakeword-data/.venv/lib/python3.9/site-packages
	pip install -r ${PACKAGE_SRC_DIR}/requirements.txt --target=/tmp/openwakeword
	cp -rv /tmp/openwakeword/* /xiaoai/build-packages/openwakeword-data/.venv/lib/python3.9/site-packages
	rm -rf /tmp/openwakeword

	cp -v ${PACKAGE_DIR}/config/launcher /xiaoai/build-packages/openwakeword-data/launcher

	tar -czvf /xiaoai/build-packages/openwakeword-data.tar.gz /xiaoai/build-packages/openwakeword-data/
}

postinstall_package() {
	cp -v ${PACKAGE_DIR}/config/openwakeword.init ${STAGING_DIR}/etc/init.d/openwakeword
	ln -sf ../init.d/openwakeword ${STAGING_DIR}/etc/rc.d/S95openwakeword

	TRIGGERHAPPY_FOLDER="${STAGING_DIR}/etc/triggerhappy/triggers.d"
	mkdir -p ${TRIGGERHAPPY_FOLDER}

	cp -v ${PACKAGE_DIR}/config/triggerhappy.conf ${TRIGGERHAPPY_FOLDER}/openwakeword.conf
}
