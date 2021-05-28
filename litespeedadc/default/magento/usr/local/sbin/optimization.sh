#!/bin/bash

LSLB_CONF="/var/www/conf/lslbd_config.xml"
VH_CONF="/var/www/conf/jelastic.xml"
ED_CMD="ed --inplace"

cp -f ${LSLB_CONF} ${LSLB_CONF}.backup.$(date +%d-%m-%Y.%H:%M:%S.%N) || exit 1

#Enable LiteMage
/usr/bin/xmlstarlet ${ED_CMD} -u "virtualHostConfig/cache/storage/litemage" -v "1" "${VH_CONF}" 2>/dev/null;

#Enable  cachePolicy
/usr/bin/xmlstarlet ${ED_CMD} -d "virtualHostConfig/cache/cachePolicy" "${VH_CONF}" 2>/dev/null;
/usr/bin/xmlstarlet ${ED_CMD} -s "virtualHostConfig/cache"  -t elem -n "cachePolicy" "${VH_CONF}" 2>/dev/null;
/usr/bin/xmlstarlet ${ED_CMD} -s "virtualHostConfig/cache/cachePolicy"  -t elem -n "checkPublicCache" -v "1" "${VH_CONF}" 2>/dev/null;
/usr/bin/xmlstarlet ${ED_CMD} -s "virtualHostConfig/cache/cachePolicy"  -t elem -n "checkPrivateCache" -v "1" "${VH_CONF}" 2>/dev/null;
/usr/bin/xmlstarlet ${ED_CMD} -s "virtualHostConfig/cache/cachePolicy"  -t elem -n "cacheStaticFile" -v "15" "${VH_CONF}" 2>/dev/null;

#Enable cluster for webroot
/usr/bin/xmlstarlet ${ED_CMD} -d "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']" "${LSLB_CONF}";
/usr/bin/xmlstarlet ${ED_CMD} -s "loadBalancerConfig/loadBalancerList"  -t elem -n "loadBalancer" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[not(name)]" -t elem -n "name" -v "masterIP" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']"  -t elem -n "type" -v "layer7" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']"  -t elem -n "mode" -v "0" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']"  -t elem -n "strategy" -v "0" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']"  -t elem -n "sessionExMethod" -v "25" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']"  -t elem -n "workerGroupList" -v "" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']/workerGroupList"  -t elem -n "workerGroup" -v "" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']/workerGroupList/workerGroup"  -t elem -n "name" -v "master-ip" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']/workerGroupList/workerGroup"  -t elem -n "type" -v "proxy" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']/workerGroupList/workerGroup"  -t elem -n "workerGroupEnabled" -v "1" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']/workerGroupList/workerGroup"  -t elem -n "sourceIP" -v "ANY" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']/workerGroupList/workerGroup"  -t elem -n "defaultTargetPort" -v "80" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']/workerGroupList/workerGroup"  -t elem -n "maxConns" -v "150" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']/workerGroupList/workerGroup"  -t elem -n "initTimeout" -v "60" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']/workerGroupList/workerGroup"  -t elem -n "retryTimeout" -v "5" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']/workerGroupList/workerGroup"  -t elem -n "respBuffer" -v "0" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']/workerGroupList/workerGroup"  -t elem -n "pingUrl" -v "http://127.0.0.1:80/" \
       -s "loadBalancerConfig/loadBalancerList/loadBalancer[name = 'masterIP']/workerGroupList/workerGroup"  -t elem -n "nodeAddresses" -v "127.0.0.1" "${LSLB_CONF}" 2>/dev/null;

#Enable webroot redirect       
/usr/bin/xmlstarlet ${ED_CMD} -d "virtualHostConfig/contextList" /var/www/conf/jelastic.xml;
/usr/bin/xmlstarlet ${ED_CMD} -s "virtualHostConfig"  -t elem -n "contextList" \
       -s "virtualHostConfig/contextList" -t elem -n "context" -v "" \
       -s "virtualHostConfig/contextList/context" -t elem -n "type" -v "loadbalancer" \
       -s "virtualHostConfig/contextList/context" -t elem -n "uri" -v "exp: ^/(\.well-known/acme-challenge)" \
       -s "virtualHostConfig/contextList/context" -t elem -n "handler" -v "masterIP" \
       -s "virtualHostConfig/contextList/context" -t elem -n "accessControl" -v "" \
       -s "virtualHostConfig/contextList/context" -t elem -n "cachePolicy" -v "" \
       -s "virtualHostConfig/contextList/context" -t elem -n "rewrite" -v "" \
       -s "virtualHostConfig/contextList/context" -t elem -n "addDefaultCharset" -v "off" "${VH_CONF}" 2>/dev/null;

# Reload service
sudo service lslb reload
