#!/bin/env bash

# flags and their values
SRC_FLAG='False'
SRC_VALUE=''
DST_FLAG='False'
DST_VALUE=''
COPY_FLAG='False'
REMOVE_FLAG='False'
TMP_FLAG='False'

MENU_FLAGS=''
SCRIPT_NAME=''
HOST_NAME=''
DST_DIR=""
SRC_DIR=""
TMP_DIR=""
DEBUG=""

###

function usage {
    cat << END
Usage: ${SCRIPT_NAME} -s SRC_DIR -d DST_DIR -c|-r [-t]

-s SRC_DIR
    description

-d DST_DIR
    description

-t
    tmp - description

-c
    copy - description

-r
    remove - description

    
END
}

function send_mail {
    local msg="${1}"
                
    echo "$msg" | mail -s "${SCRIPT_NAME}" admin@example.com
}

function log_debug {
    local caller="${1}"
    local var_name="${2}"
    local msg="${3}"

    logger -t ${SCRIPT_NAME} "DEBUG: [ ${caller} ] - ${var_name} >>${msg}<<"
}

function log_msg {
    local caller="${1}"
    local msg="${2}"

    logger -t ${SCRIPT_NAME} "[ ${caller} ] ${msg}"
}


function _config {
    ### _config - set variables

    ### global variables
    # kiss - one locale, one commands output
    DEBUG="True"
    export LANG='en_US.UTF-8'
    HOST_NAME=$(hostname -s)
    export HOST_NAME


    # local variables
    local log_func="${FUNCNAME[0]}"
    
    if [ "${DEBUG}" == 'True' ]; then log_debug "${log_func}" "HOST_NAME" "${HOST_NAME}"; fi

    SRC_DIR="${SRC_VALUE}"
    DST_DIR="${DST_VALUE}"
    if [ "${DEBUG}" == 'True' ]; then log_debug "${log_func}" "SRC_VALUE" "${SRC_VALUE}"; fi
    if [ "${DEBUG}" == 'True' ]; then log_debug "${log_func}" "SRC_DIR" "${SRC_DIR}"; fi
    if [ "${DEBUG}" == 'True' ]; then log_debug "${log_func}" "DST_VALUE" "${DST_VALUE}"; fi
    if [ "${DEBUG}" == 'True' ]; then log_debug "${log_func}" "DST_DIR" "${DST_DIR}"; fi

    if [ "${TMP_FLAG}" == 'True' ]
    then
        TMP_DIR="/tmp/foo/bar/"
        DST_DIR="${TMP_DIR}/${DST_DIR}/"
    fi 
    if [ "${DEBUG}" == 'True' ]; then log_debug "${log_func}" "TMP_DIR" "${TMP_DIR}"; fi
    if [ "${DEBUG}" == 'True' ]; then log_debug "${log_func}" "DST_DIR" "${DST_DIR}"; fi
}

function init {
    # check dirs, download data, generate intermediate information, etc.
  
    _config

    # local variables
    local log_func="${FUNCNAME[0]}"
    local foo='local foo'

    if [ "${DEBUG}" == 'True' ]; then log_debug "${log_func}" "foo" "${foo}"; fi

    # menu flags
    if [ "${DEBUG}" == 'True' ]; then log_debug "${log_func}" "MENU_FLAGS" "${MENU_FLAGS}"; fi

    if [ ! -d ${SRC_DIR} ]
    then
        log_msg "${log_func}" "Dir ${SRC_DIR} doesn't exist"
    fi
    if [ ! -d ${DST_DIR} ]
    then
        log_msg "${log_func}" "Dir ${DST_DIR} doesn't exist"
    fi
}

function copy {

    # local variables
    local log_func="${FUNCNAME[0]}"
    local foo='local foo'

    if [ "${DEBUG}" == 'True' ]; then log_debug "${log_func}" "foo" "${foo}"; fi

    log_msg "${log_func}" "coping ..."
    if [ "$?" -ne 0 ]
    then
        exit 1
    fi
}

function remove {

    # local variables
    local log_func="${FUNCNAME[0]}"
    local foo='local foo'

    if [ "${DEBUG}" == 'True' ]; then log_debug "${log_func}" "foo" "${foo}"; fi

    log_msg "${log_func}" "removing ..."
    if [ "$?" -ne 0 ]
    then
        exit 1
    fi
}


SCRIPT_NAME="${0}"
while getopts ':s:d:crt' option
do
    case $option in
        s)
            SRC_FLAG='True'
            SRC_VALUE="${OPTARG}"
            ;;
        d)
            DST_FLAG='True'
            DST_VALUE="${OPTARG}"
            ;;
        c)
            COPY_FLAG='True'
            ;;
        r)
            REMOVE_FLAG='True'
            ;;
        t)
            TMP_FLAG='True'
            ;;
        ?)
            usage >&2
            exit 1
            ;;
    esac
done
MENU_FLAGS="${@}"
shift $(($OPTIND - 1))


## main - allowed flag combinations
# -s -d -c
if [[ "${SRC_FLAG}" == 'True' && "${DST_FLAG}" == 'True' && "${COPY_FLAG}" == 'True' && "${TMP_FLAG}" == 'False' && "${REMOVE_FLAG}" == 'False' ]]
then
    init
    copy
# -s -d -c -t
elif [[ "${SRC_FLAG}" == 'True' && "${DST_FLAG}" == 'True' && "${COPY_FLAG}" == 'True' && "${TMP_FLAG}" == 'True' && "${REMOVE_FLAG}" == 'False' ]]
then
    init
    copy
# -s -d -r
elif [[ "${SRC_FLAG}" == 'True' && "${DST_FLAG}" == 'True' && "${COPY_FLAG}" == 'False' && "${TMP_FLAG}" == 'False' && "${REMOVE_FLAG}" == 'True' ]]
then
    init
    remove
# -s -d -r -t
elif [[ "${SRC_FLAG}" == 'True' && "${DST_FLAG}" == 'True' && "${COPY_FLAG}" == 'False' && "${TMP_FLAG}" == 'True' && "${REMOVE_FLAG}" == 'True' ]]
then
    init
    remove
else
    usage >&2
    exit 1
fi

