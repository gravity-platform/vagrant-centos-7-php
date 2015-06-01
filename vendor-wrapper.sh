#/bin/sh

# Simple wrapper for potentially vendorized bins
#
# This script is always called through a symlink. ie 'phpunit -> vagrant-centos-7-php-wrapper.sh'.
#
# @author  Lucas Bickel <lucas.bickel@swisscom.com>
# @license GPL
# @link    http://swisscom.com

REQUESTED_BIN=`basename ${0}`
if [[ -f ${PWD}/vendor/bin/${REQUESTED_BIN} ]]; then
    FINAL_BIN=${PWD}/vendor/bin/${REQUESTED_BIN}
else
    FINAL_BIN=${HOME}/.composer/vendor/bin/${REQUESTED_BIN}
fi
exec $FINAL_BIN $@
