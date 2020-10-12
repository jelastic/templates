#!/bin/bash

OPTIMIZATION_LIST="/usr/local/sbin/optimization.list"
TEST_OUTPUT="/tmp/test.output"
WEBROOT_ROOT="/var/www/webroot/ROOT"
WP=`which wp`
APP_VERSION=$(${WP} core version --path=${WEBROOT_ROOT})
echo "APP_VERSION: ${APP_VERSION}" > $TEST_OUTPUT

