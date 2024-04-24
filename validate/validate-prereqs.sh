#!/bin/bash

#validate prereqs


if [[ "$1" == "" ]]; then
    echo "case version is missing."
    echo "for example: $0 5.1.3"
    exit 1
fi

VERSION_DIR=$1
#get script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
set -e
cd $VERSION_DIR
set +e

rm -f cert-kubernetes.tar
tar -cf cert-kubernetes.tar cert-kubernetes/

POD_NAME=$(oc get pods |grep -v cp4a-operator-catalog | grep cp4a-operator |awk '{print $1}')

oc cp -c operator cert-kubernetes.tar $POD_NAME:/tmp/
cd $SCRIPT_DIR/..
oc cp -c operator ldap-cert/ldap-cert.crt $POD_NAME:/tmp/

echo "Files copied to operator pod."
echo ""
echo "Login to pod:"
echo "  oc exec -it $POD_NAME -- bash"
echo "Change dir:"
echo "  cd /tmp"
echo "Extract:"
echo "  tar -xf cert-kubernetes.tar"
echo "Change dir:"
echo "  cd cert-kubernetes/scripts"
echo "Edit property file:"
echo "  vi cp4ba-prerequisites/propertyfile/cp4ba_LDAP.property"
echo "  Change value of LDAP_SSL_CERT_FILE_FOLDER to \"/tmp\""
echo "Validate:"
echo "  ./cp4a-prerequisites.sh -m validate"