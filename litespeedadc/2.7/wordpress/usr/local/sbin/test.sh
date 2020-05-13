#!/bin/bash

OPTIMIZATION_LIST="optimization.list"
OPTIMIZATION_OUTPUT="/tmp/optimization.output"
LSLB_CONF="/var/www/conf/lslbd_config.xml"
VH_CONF="/var/www/conf/jelastic.xml"
SEL_CMD="sel -t -v"

[ -f $OPTIMIZATION_OUTPUT ] && rm -f $OPTIMIZATION_OUTPUT
while read -ru 4 PARAM; do
  [[ $PARAM = \#* ]] && continue
  [[ $PARAM = loadBalancerConfig* ]] && value=($(/usr/bin/xmlstarlet ${SEL_CMD} ${PARAM%=*} $LSLB_CONF))
  [[ $PARAM = virtualHostConfig* ]] && value=($(/usr/bin/xmlstarlet ${SEL_CMD} ${PARAM%=*} $VH_CONF))

  echo "${PARAM%=*}=${value[0]}" >> $OPTIMIZATION_OUTPUT
done 4< $OPTIMIZATION_LIST

