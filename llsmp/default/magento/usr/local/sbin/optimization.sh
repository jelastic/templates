#!/bin/bash
DEFAULT_LSWS_CONFIG="/var/www/conf/httpd_config.xml"
PHPMYADMIN_VIRTUALHOST_CONFIG="/usr/share/phpMyAdmin/vhost.conf"
ED_CMD="ed --inplace"

[ -f "/var/www/webroot/vhconf.xml" ] && DEFAULT_VIRTUALHOST_CONFIG="/var/www/webroot/vhconf.xml";
[ -f "/var/www/conf/vhconf.xml" ] && DEFAULT_VIRTUALHOST_CONFIG="/var/www/conf/vhconf.xml";

if [ -e ${DEFAULT_VIRTUALHOST_CONFIG} ]; then
  /usr/bin/xmlstarlet ${ED_CMD} -u "virtualHostConfig/docRoot" -v "\$VH_ROOT/ROOT/pub/" "${DEFAULT_VIRTUALHOST_CONFIG}" 2>/dev/null;
fi

sudo jem service restart
