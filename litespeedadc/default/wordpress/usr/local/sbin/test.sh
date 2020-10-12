#!/bin/bash

OPTIMIZATION_LIST="/usr/local/sbin/optimization.list"
TEST_OUTPUT="/tmp/test.output"
LSLB_CONF="/var/www/conf/lslbd_config.xml"
VH_CONF="/var/www/conf/jelastic.xml"
SEL_CMD="sel -t -v"

echo "" > $TEST_OUTPUT
while read -ru 4 PARAM; do
  [[ $PARAM = loadBalancerConfig* ]] && value=($(/usr/bin/xmlstarlet ${SEL_CMD} ${PARAM%=*} $LSLB_CONF));
  [[ $PARAM = virtualHostConfig* ]] && value=($(/usr/bin/xmlstarlet ${SEL_CMD} ${PARAM%=*} $VH_CONF));
  [[ ${PARAM#*=} != ${value} ]] && echo "PARAMETER: ${PARAM%=*} EXPECTED: ${PARAM#*=} ACTUAL: ${value[0]}" >> $TEST_OUTPUT
done 4< $OPTIMIZATION_LIST

