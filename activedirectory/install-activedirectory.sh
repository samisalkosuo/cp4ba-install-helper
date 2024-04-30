#!/bin/bash

if [[ "$1" == "" ]]; then
    echo "Namespace is missing."
    exit 1
fi

NAMESPACE=$1
OPERATION=$2
if [[ "$OPERATION" == "delete" ]]; then
    OPERATION="delete"
else
    OPERATION="apply"
fi

ALL=$3
#get script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

TEMP_FILE=$SCRIPT_DIR/temp.yaml
rm -f $TEMP_FILE

NAMESPACE_FILE=$SCRIPT_DIR/activedirectory-namespace.yaml
CONFIG_FILE=$SCRIPT_DIR/activedirectory-deployment.yaml


function namespace
{
    local OP=$1
    #create namespace, if not already created
    YAML_FILE=$NAMESPACE_FILE
    #change all occurrences of namespace
    sed "s/{NAMESPACE}/${NAMESPACE}/" ${YAML_FILE} > ${TEMP_FILE}

    oc $OP -f $TEMP_FILE
}

function configuration
{
    local OP=$1
    #create postgresql statefulset
    YAML_FILE=$CONFIG_FILE
    #change all occurrences of namespace
    sed "s/{NAMESPACE}/${NAMESPACE}/" ${YAML_FILE} > ${TEMP_FILE}2

    local PREFIX="prereq-cp4ba-"
    sed "s/{PREFIX}/${PREFIX}/" ${TEMP_FILE}2 > $TEMP_FILE

    #change password if environment variables are present
    if [[ "$LDAP_USER_PASSWORD" != "" ]]; then
        sed "s/DEFAULT_PASSWORD: passw0rd/DEFAULT_PASSWORD: \"${LDAP_USER_PASSWORD}\"/" ${TEMP_FILE} > ${TEMP_FILE}2
        mv ${TEMP_FILE}2 ${TEMP_FILE}
    fi

    if [[ "$LDAP_BIND_PASSWORD" != "" ]]; then
        sed "s/SAMBA_ADMIN_PASSWORD: \"S4m3aPassw@rd\"/SAMBA_ADMIN_PASSWORD: \"${LDAP_BIND_PASSWORD}\"/" ${TEMP_FILE} > ${TEMP_FILE}2
        mv ${TEMP_FILE}2 ${TEMP_FILE}
    fi

    oc $OP -f $TEMP_FILE

}

#create namespace if operation is apply
if [[ "$OPERATION" == "apply" ]]; then
    namespace apply
fi

configuration $OPERATION

#delete namespace if operation is delete and all is specified
if [[ "$OPERATION" == "delete" ]]; then
    if [[ "$ALL" == "all" ]]; then
        namespace delete
    fi
fi