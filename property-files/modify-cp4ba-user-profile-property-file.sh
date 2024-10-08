#!/bin/bash

if [[ "$CP4BA_NAMESPACE" == "" ]]; then
    echo "CP4BA_NAMESPACE environment variable is not set."
    exit 1
fi

if [[ "$CP4BA_VERSION" == "" ]]; then
    echo "CP4BA_VERSION environment variable is not set."
    exit 1
fi

if [[ "$LDAP_USER_PASSWORD" == "" ]]; then
    echo "LDAP_USER_PASSWORD environment variable is not set."
    exit 1
fi


#change password to base64 encoded
BASE64_ENCODED_PWD=$(echo -n $LDAP_USER_PASSWORD | base64)
LDAP_USER_PASSWORD="{Base64}$BASE64_ENCODED_PWD"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CP4BA_PREREQ_DIRECTORY=$SCRIPT_DIR/../$CP4BA_VERSION/cert-kubernetes/scripts/cp4ba-prerequisites
USER_PROFILE_PROPERTY_FILE=$CP4BA_PREREQ_DIRECTORY/project/$CP4BA_NAMESPACE/propertyfile/cp4ba_user_profile.property

DEFAULT_USER=dwells
DEFAULT_GROUP=admin
DEFAULT_USER_DN="cn=dwells,cn=users,dc=sirius,dc=com"

#change ADP Mongo password before changing other passwords
sed -i "s/ADP.MONGO_USER_PASSWORD=\"{Base64}<Required>\"/ADP.MONGO_USER_PASSWORD=\"passw0rd\"/g" $USER_PROFILE_PROPERTY_FILE

#change all passwords
sed -i "s/{Base64}<Required>/$LDAP_USER_PASSWORD/g" $USER_PROFILE_PROPERTY_FILE
#change required properties, check the file later to verify that all required properties are filled
sed -i "s/CP4BA.CP4BA_LICENSE=\"<Required>\"/CP4BA.CP4BA_LICENSE=\"non-production\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/CP4BA.FNCM_LICENSE=\"<Required>\"/CP4BA.FNCM_LICENSE=\"non-production\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/CP4BA.BAW_LICENSE=\"<Required>\"/CP4BA.BAW_LICENSE=\"non-production\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/CONTENT.APPLOGIN_USER=\"<Required>\"/CONTENT.APPLOGIN_USER=\"$DEFAULT_USER\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/CONTENT.ARCHIVE_USER_ID=\"<Required>\"/CONTENT.ARCHIVE_USER_ID=\"$DEFAULT_USER\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/CONTENT_INITIALIZATION.LDAP_ADMIN_USER_NAME=\"<Required>\"/CONTENT_INITIALIZATION.LDAP_ADMIN_USER_NAME=\"$DEFAULT_USER\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/CONTENT_INITIALIZATION.LDAP_ADMINS_GROUPS_NAME=\"<Required>\"/CONTENT_INITIALIZATION.LDAP_ADMINS_GROUPS_NAME=\"$DEFAULT_GROUP\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/CONTENT_INITIALIZATION.CPE_OBJ_STORE_ADMIN_USER_GROUPS=\"<Required>\"/CONTENT_INITIALIZATION.CPE_OBJ_STORE_ADMIN_USER_GROUPS=\"$DEFAULT_GROUP\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/CONTENT_INITIALIZATION.CPE_OBJ_STORE_WORKFLOW_ADMIN_GROUP=\"<Required>\"/CONTENT_INITIALIZATION.CPE_OBJ_STORE_WORKFLOW_ADMIN_GROUP=\"$DEFAULT_GROUP\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/CONTENT_INITIALIZATION.CPE_OBJ_STORE_WORKFLOW_CONFIG_GROUP=\"<Required>\"/CONTENT_INITIALIZATION.CPE_OBJ_STORE_WORKFLOW_CONFIG_GROUP=\"$DEFAULT_GROUP\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/CONTENT_INITIALIZATION.CPE_OBJ_STORE_WORKFLOW_PE_CONN_POINT_NAME=\"<Required>\"/CONTENT_INITIALIZATION.CPE_OBJ_STORE_WORKFLOW_PE_CONN_POINT_NAME=\"pe_conn_point\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/BAN.APPLOGIN_USER=\"<Required>\"/BAN.APPLOGIN_USER=\"$DEFAULT_USER\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/ADP.SERVICE_USER_NAME=\"<Required>\"/ADP.SERVICE_USER_NAME=\"$DEFAULT_USER_DN\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/ADP.SERVICE_USER_NAME_BASE=\"<Required>\"/ADP.SERVICE_USER_NAME_BASE=\"$DEFAULT_USER_DN\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/ADP.SERVICE_USER_NAME_CA=\"<Required>\"/ADP.SERVICE_USER_NAME_CA=\"$DEFAULT_USER_DN\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/ADP.ENV_OWNER_USER_NAME=\"<Required>\"/ADP.ENV_OWNER_USER_NAME=\"$DEFAULT_USER_DN\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/APP_ENGINE.ADMIN_USER=\"<Required>\"/APP_ENGINE.ADMIN_USER=\"$DEFAULT_USER\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/ADP.EXTERNAL_MONGO_URI=\"<Required>\"/ADP.EXTERNAL_MONGO_URI=\"mongodb:\/\/admin:passw0rd@prereq-cp4ba-mongodb-svc.$CP4BA_NAMESPACE.svc.cluster.local:27017\/adp?retryWrites=true\&w=majority\&authSource=admin\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/ADP.MONGO_USER_NAME=\"<Required>\"/ADP.MONGO_USER_NAME=\"admin\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/APP_PLAYBACK.ADMIN_USER=\"<Required>\"/APP_PLAYBACK.ADMIN_USER=\"$DEFAULT_USER\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/BASTUDIO.ADMIN_USER=\"<Required>\"/BASTUDIO.ADMIN_USER=\"$DEFAULT_USER\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/ADS.EXTERNAL_GIT_MONGO_URI=\"<Required>\"/ADS.EXTERNAL_GIT_MONGO_URI=\"mongodb:\/\/admin:passw0rd@prereq-cp4ba-mongodb-svc.$CP4BA_NAMESPACE.svc.cluster.local:27017\/ads-git?retryWrites=true\&w=majority\&authSource=admin\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/ADS.EXTERNAL_MONGO_URI=\"<Required>\"/ADS.EXTERNAL_MONGO_URI=\"mongodb:\/\/admin:passw0rd@prereq-cp4ba-mongodb-svc.$CP4BA_NAMESPACE.svc.cluster.local:27017\/ads?retryWrites=true\&w=majority\&authSource=admin\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/ADS.EXTERNAL_MONGO_HISTORY_URI=\"<Required>\"/ADS.EXTERNAL_MONGO_HISTORY_URI=\"mongodb:\/\/admin:passw0rd@prereq-cp4ba-mongodb-svc.$CP4BA_NAMESPACE.svc.cluster.local:27017\/ads-history?retryWrites=true\&w=majority\&authSource=admin\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/ADS.EXTERNAL_RUNTIME_MONGO_URI=\"<Required>\"/ADS.EXTERNAL_RUNTIME_MONGO_URI=\"mongodb:\/\/admin:passw0rd@prereq-cp4ba-mongodb-svc.$CP4BA_NAMESPACE.svc.cluster.local:27017\/ads-runtime-archive-metadata?retryWrites=true\&w=majority\&authSource=admin\"/g" $USER_PROFILE_PROPERTY_FILE
sed -i "s/BAW_RUNTIME.ADMIN_USER=\"<Required>\"/BAW_RUNTIME.ADMIN_USER=\"$DEFAULT_USER\"/g" $USER_PROFILE_PROPERTY_FILE



REQUIRED_PROPERTIES=$(cat $USER_PROFILE_PROPERTY_FILE | grep "<Required>")

if [[ "$REQUIRED_PROPERTIES" != "" ]]; then
    echo "$USER_PROFILE_PROPERTY_FILE still has required properties:"
    echo ""
    echo $REQUIRED_PROPERTIES
    exit 1
fi
