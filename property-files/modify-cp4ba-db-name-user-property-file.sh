#!/bin/bash

# if [[ "$CP4BA_PREREQ_DIRECTORY" == "" ]]; then
#     echo "CP4BA_PREREQ_DIRECTORY environment variable is missing."
#     exit 1
# fi
if [[ "$CP4BA_CASE_VERSION" == "" ]]; then
    echo "CP4BA_CASE_VERSION environment variable is not set."
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CP4BA_PREREQ_DIRECTORY=$SCRIPT_DIR/../$CP4BA_CASE_VERSION/cert-kubernetes/scripts/cp4ba-prerequisites
DB_NAME_USER_PROPERTY_FILE=$CP4BA_PREREQ_DIRECTORY/propertyfile/cp4ba_db_name_user.property

#Change all <youruser1> to postgres.
sed -i "s/<youruser1>/postgres/g" $DB_NAME_USER_PROPERTY_FILE
#Change all {Base64}<yourpassword> to passw0rd.
sed -i "s/{Base64}<yourpassword>/passw0rd/g" $DB_NAME_USER_PROPERTY_FILE
#Change all <youruser2> to postgres.
sed -i "s/<youruser2>/postgres/g" $DB_NAME_USER_PROPERTY_FILE
#Change all {Base64}<yourpassword1> to passw0rd.
sed -i "s/{Base64}<yourpassword1>/passw0rd/g" $DB_NAME_USER_PROPERTY_FILE
#Change all {Base64}<yourpassword2> to passw0rd.
sed -i "s/{Base64}<yourpassword2>/passw0rd/g" $DB_NAME_USER_PROPERTY_FILE
