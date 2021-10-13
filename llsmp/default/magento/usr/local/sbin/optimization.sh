#!/bin/bash
DEFAULT_LSWS_CONFIG="/var/www/conf/httpd_config.xml"
PHPMYADMIN_VIRTUALHOST_CONFIG="/usr/share/phpMyAdmin/vhost.conf"
ED_CMD="ed --inplace"

[ -f "/var/www/webroot/vhconf.xml" ] && DEFAULT_VIRTUALHOST_CONFIG="/var/www/webroot/vhconf.xml";
[ -f "/var/www/conf/vhconf.xml" ] && DEFAULT_VIRTUALHOST_CONFIG="/var/www/conf/vhconf.xml";

if [ -e ${DEFAULT_VIRTUALHOST_CONFIG} ]; then
  CURRENT_VALUE=$(xmlstarlet sel -t -v "virtualHostConfig/docRoot" ${DEFAULT_VIRTUALHOST_CONFIG})
  if [ "x${CURRENT_VALUE}" != "x\$VH_ROOT/ROOT/pub/" ]; then
    /usr/bin/xmlstarlet ${ED_CMD} -u "virtualHostConfig/docRoot" -v "\$VH_ROOT/ROOT/pub/" "${DEFAULT_VIRTUALHOST_CONFIG}" 2>/dev/null;
  fi
  CURRENT_VALUE=$(xmlstarlet sel -t -v "virtualHostConfig/cache/storage/litemage" ${DEFAULT_VIRTUALHOST_CONFIG})
  if [ "x${CURRENT_VALUE}" != "x1" ]; then
    /usr/bin/xmlstarlet ${ED_CMD} -d "virtualHostConfig/cache/storage/litemage" "${DEFAULT_VIRTUALHOST_CONFIG}" 2>/dev/null;
    /usr/bin/xmlstarlet ${ED_CMD} -u "virtualHostConfig/cache/storage/litemage" -v "1" "${DEFAULT_VIRTUALHOST_CONFIG}" 2>/dev/null;
  fi
fi

sudo jem service restart
