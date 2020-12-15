#!/bin/bash

DEFAULT_LSWS_CONFIG="/var/www/conf/httpd_config.xml"
PHPMYADMIN_VIRTUALHOST_CONFIG="/usr/share/phpMyAdmin/vhost.conf"
ED_CMD="ed --inplace"

[ -f "/var/www/webroot/vhconf.xml" ] && DEFAULT_VIRTUALHOST_CONFIG="/var/www/webroot/vhconf.xml"; 
[ -f "/var/www/conf/vhconf.xml" ] && DEFAULT_VIRTUALHOST_CONFIG="/var/www/conf/vhconf.xml"; 

cp -f "${DEFAULT_LSWS_CONFIG}" ${DEFAULT_LSWS_CONFIG}.backup.$(date +%d-%m-%Y.%H:%M:%S.%N) || exit 1
cp -f "${DEFAULT_VIRTUALHOST_CONFIG}" ${DEFAULT_VIRTUALHOST_CONFIG}.backup.$(date +%d-%m-%Y.%H:%M:%S.%N) || exit 1
[ -f "${PHPMYADMIN_VIRTUALHOST_CONFIG}" ] && { cp -f "${PHPMYADMIN_VIRTUALHOST_CONFIG}" ${PHPMYADMIN_VIRTUALHOST_CONFIG}.backup.$(date +%d-%m-%Y.%H:%M:%S.%N) || exit 1; }

if [ -e ${DEFAULT_LSWS_CONFIG} ]; then 
###JE-51695-Disable compression on cp layer for WP cluster
  /usr/bin/xmlstarlet $ED_CMD -u "httpServerConfig/tuning/enableGzipCompress" -v "0" ${DEFAULT_LSWS_CONFIG} 2>&1;
fi

if [ -e ${DEFAULT_VIRTUALHOST_CONFIG} ]; then
  /usr/bin/xmlstarlet ${ED_CMD} -d "virtualHostConfig/cache/storage/cacheStorePath" "${DEFAULT_VIRTUALHOST_CONFIG}" 2>/dev/null;
fi

sudo service lsws reload

