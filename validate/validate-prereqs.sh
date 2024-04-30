#!/bin/bash

#validate prereqs

if [[ "$CP4BA_CASE_VERSION" == "" ]]; then
    echo "CP4BA_CASE_VERSION environment variable is not set."
    exit 1
fi

#get script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
set -e
cd $CP4BA_CASE_VERSION
set +e

rm -f cert-kubernetes.tar
tar -cf cert-kubernetes.tar cert-kubernetes/

POD_NAME=$(oc get pods |grep -v cp4a-operator-catalog | grep cp4a-operator |awk '{print $1}')

oc cp -c operator cert-kubernetes.tar $POD_NAME:/tmp/
cd $SCRIPT_DIR/..
oc cp -c operator ldap-cert/ldap-cert.crt $POD_NAME:/tmp/

#extract files and change ldap property file
oc exec -it -c operator $POD_NAME -- bash -c "cd /tmp && tar -xf cert-kubernetes.tar && cd cert-kubernetes/scripts && sed -i \"s/^LDAP_SSL_CERT_FILE_FOLDER.*/LDAP_SSL_CERT_FILE_FOLDER=\\\"\\\/tmp\\\"/g\" cp4ba-prerequisites/propertyfile/cp4ba_LDAP.property"

echo "Files copied to operator pod."
echo ""
echo "Login to pod:"
echo "  oc exec -it -c operator $POD_NAME -- bash"
echo "Validate:"
echo "  cd /tmp/cert-kubernetes/scripts && ./cp4a-prerequisites.sh -m validate"
