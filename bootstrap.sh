#!/bin/zsh

readonly IS_LOADING_BOOTSTRAP=1

MULTICORE=`grep processor /proc/cpuinfo | wc -l`

require() {
    . "${SCRIPT_ROOT_DIR}${1}"
}

require "/lib/config.sh"
require "/lib/download.sh"
require "/lib/watchdog.sh"
require "/lib/unpackit.sh"


