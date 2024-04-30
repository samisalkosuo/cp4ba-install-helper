#/bin/bash

if [[ "$1" == "" ]]; then
    echo "LDAP server:port is missing."
    echo ""
    echo "Sample usage: $0 ldap.server:686"
    exit 1
fi

LDAP_SERVER=$1

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo | openssl s_client -connect  $LDAP_SERVER 2>/dev/null | openssl x509 > $SCRIPT_DIR/ldap-cert2.crt

echo "LDAP certificate downloaded."
echo ""
echo "LDAP_SSL_CERT_FILE_FOLDER=\"$SCRIPT_DIR\""