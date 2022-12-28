#!/bin/bash

DEFAULT_LSWS_CONFIG="/var/www/conf/httpd_config.xml"
ED_CMD="ed --inplace"

cp -f "${DEFAULT_LSWS_CONFIG}" ${DEFAULT_LSWS_CONFIG}.backup.$(date +%d-%m-%Y.%H:%M:%S.%N) || exit 1

/usr/bin/xmlstarlet $ED_CMD -u "httpServerConfig/extProcessorList/extProcessor/memSoftLimit" -v "10240M" ${DEFAULT_LSWS_CONFIG} 2>&1;
/usr/bin/xmlstarlet $ED_CMD -u "httpServerConfig/extProcessorList/extProcessor/memHardLimit" -v "10240M" ${DEFAULT_LSWS_CONFIG} 2>&1;

# Reload service
sudo jem service restart
