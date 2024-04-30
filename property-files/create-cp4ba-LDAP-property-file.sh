#!/bin/bash

if [[ "$CP4BA_CASE_VERSION" == "" ]]; then
    echo "CP4BA_CASE_VERSION environment variable is not set."
    exit 1
fi

if [[ "$CP4BA_NAMESPACE" == "" ]]; then
    echo "CP4BA_NAMESPACE environment variable is not set."
    exit 1
fi

if [[ "$LDAP_BIND_PASSWORD" == "" ]]; then
    echo "LDAP_BIND_PASSWORD environment variable is not set."
    exit 1
fi

#change password to base64 encoded
BASE64_ENCODED_PWD=$(echo -n $LDAP_BIND_PASSWORD | base64)
LDAP_BIND_PASSWORD="{Base64}$BASE64_ENCODED_PWD"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

#set values for LDAP server
LDAP_SERVER="prereq-cp4ba-ad-demo-service.${CP4BA_NAMESPACE}.svc.cluster.local"
LDAP_PORT="636"
LDAP_BASE_DN="dc=sirius,dc=com"
LDAP_BIND_DN="Administrator@sirius.com"
LDAP_BIND_DN_PASSWORD="$LDAP_BIND_PASSWORD"
LDAP_SSL_ENABLED="True"
#folder where LDAP server certificate is found. certificate must be named: `ldap-cert.crt`.
LDAP_SSL_CERT_FILE_FOLDER="$SCRIPT_DIR/../ldap-cert"
LDAP_GROUP_BASE_DN="dc=sirius,dc=com"
LDAP_GROUP_DISPLAY_NAME_ATTR="cn"
LC_AD_GC_HOST="$LDAP_SERVER"
LC_AD_GC_PORT="$LDAP_PORT"

CP4BA_PREREQ_DIRECTORY=$SCRIPT_DIR/../$CP4BA_CASE_VERSION/cert-kubernetes/scripts/cp4ba-prerequisites
LDAP_PROPERTY_FILE=$CP4BA_PREREQ_DIRECTORY/propertyfile/cp4ba_LDAP.property

#create LDAP property file
cat > $LDAP_PROPERTY_FILE << EOF
###########################
## Property file for AD ##
###########################
## The possible values are: "IBM Security Directory Server" or "Microsoft Active Directory"
LDAP_TYPE="Microsoft Active Directory"

## The name of the LDAP server to connect
LDAP_SERVER="$LDAP_SERVER"

## The port of the LDAP server to connect.  Some possible values are: 389, 636, etc.
LDAP_PORT="$LDAP_PORT"

## The LDAP base DN.  For example, "dc=example,dc=com", "dc=abc,dc=com", etc
LDAP_BASE_DN="$LDAP_BASE_DN"

## The LDAP bind DN. For example, "uid=user1,dc=example,dc=com", "uid=user1,dc=abc,dc=com", etc.
LDAP_BIND_DN="$LDAP_BIND_DN"

## The password (if password has special characters then Base64 encoded with {Base64} prefix, otherwise use plain text) for LDAP bind DN.
LDAP_BIND_DN_PASSWORD="$LDAP_BIND_DN_PASSWORD"

## Enable SSL/TLS for LDAP communication. Refer to Knowledge Center for more info.
LDAP_SSL_ENABLED="$LDAP_SSL_ENABLED"

## The name of the secret that contains the LDAP SSL/TLS certificate.
LDAP_SSL_SECRET_NAME="ibm-cp4ba-ldap-ssl-secret"

## If enabled LDAP SSL, you need copy the SSL certificate file (named ldap-cert.crt) into this directory. Default value is "/devcon/cp4ba-helper/case/5.1.3/cert-kubernetes/scripts/cp4ba-prerequisites/propertyfile/cert/ldap"
LDAP_SSL_CERT_FILE_FOLDER="$LDAP_SSL_CERT_FILE_FOLDER"

## The LDAP user name attribute. Semicolon-separated list that must include the first RDN user distinguished names. One possible value is "*:uid" for TDS and "user:sAMAccountName" for AD. Refer to Knowledge Center for more info.
LDAP_USER_NAME_ATTRIBUTE="user:sAMAccountName"

## The LDAP user display name attribute. One possible value is "cn" for TDS and "sAMAccountName" for AD. Refer to Knowledge Center for more info.
LDAP_USER_DISPLAY_NAME_ATTR="sAMAccountName"

## The LDAP group base DN.  For example, "dc=example,dc=com", "dc=abc,dc=com", etc
LDAP_GROUP_BASE_DN="$LDAP_GROUP_BASE_DN"

## The LDAP group name attribute.  One possible value is "*:cn" for TDS and "*:cn" for AD. Refer to Knowledge Center for more info.
LDAP_GROUP_NAME_ATTRIBUTE="*:cn"

## The LDAP group display name attribute.  One possible value for both TDS and AD is "cn". Refer to Knowledge Center for more info.
LDAP_GROUP_DISPLAY_NAME_ATTR="$LDAP_GROUP_DISPLAY_NAME_ATTR"

## The LDAP group membership search filter string.  One possible value is "(|(&(objectclass=groupofnames)(member={0}))(&(objectclass=groupofuniquenames)(uniquemember={0})))" for TDS, and "(&(cn=%v)(objectcategory=group))" for AD.
LDAP_GROUP_MEMBERSHIP_SEARCH_FILTER="(&(cn=%v)(objectcategory=group))"

## The LDAP group membership ID map.  One possible value is "groupofnames:member" for TDS and "memberOf:member" for AD.
LDAP_GROUP_MEMBER_ID_MAP="memberOf:member"

## This is the Global Catalog host for the LDAP
LC_AD_GC_HOST="$LC_AD_GC_HOST"

## This is the Global Catalog port for the LDAP
LC_AD_GC_PORT="$LC_AD_GC_PORT"

## One possible value is "(&(sAMAccountName=%v)(objectcategory=user))"
LC_USER_FILTER="(&(sAMAccountName=%v)(objectcategory=user))"

## One possible value is "(&(cn=%v)(objectcategory=group))"
LC_GROUP_FILTER="(&(cn=%v)(objectcategory=group))"

EOF
