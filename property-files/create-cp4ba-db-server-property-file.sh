#!/bin/bash

if [[ "$CP4BA_NAMESPACE" == "" ]]; then
    echo "CP4BA_NAMESPACE environment variable is not set."
    exit 1
fi

if [[ "$CP4BA_CASE_VERSION" == "" ]]; then
    echo "CP4BA_CASE_VERSION environment variable is not set."
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CP4BA_PREREQ_DIRECTORY=$SCRIPT_DIR/../$CP4BA_CASE_VERSION/cert-kubernetes/scripts/cp4ba-prerequisites
DB_SERVER_PROPERTY_FILE=$CP4BA_PREREQ_DIRECTORY/propertyfile/cp4ba_db_server.property

#create DB server property file
cat > $DB_SERVER_PROPERTY_FILE << EOF
## Please input the value for the multiple database server/instance name, this key supports comma-separated lists. ##
## (NOTES: The value (CAN NOT CONTAIN DOT CHARACTER) is alias name for database server/instance, it is not real database server/instance host name.) ##
DB_SERVER_LIST="dbserver1"

####################################################
## Property for Database Server "dbserver1" required by IBM Cloud Pak for Business Automation on postgresql type database ##
####################################################
## Provide the database type from your infrastructure. The possible values are "db2" or "db2HADR" or "oracle" or "sqlserver" "postgresql".
dbserver1.DATABASE_TYPE="postgresql"

## Provide the database server name or IP address of the database server.
dbserver1.DATABASE_SERVERNAME="prereq-cp4ba-postgres.$CP4BA_NAMESPACE.svc.cluster.local"

## Provide the database server port. For Db2, the default is "50000". For Oracle, the default is "1521". For Postgresql, the default is "5432".
dbserver1.DATABASE_PORT="5432"

## The parameter is used to support database connection over SSL for database. Default value is "true"
dbserver1.DATABASE_SSL_ENABLE="False"
 
## Whether your PostgreSQL database enables server only or both server and client authentication. Default value is "True" for enabling both server and client authentication, "False" is for enabling server-only authentication.
dbserver1.POSTGRESQL_SSL_CLIENT_SERVER="False"

## The name of the secret that contains the DB2/Oracle/MSSQLServer/PostgreSQL SSL certificate.
dbserver1.DATABASE_SSL_SECRET_NAME="ibm-cp4ba-db-ssl-secret-for-dbserver1"

## If POSTGRESQL_SSL_CLIENT_SERVER is "True" and DATABASE_SSL_ENABLE is "True", please get "<your-server-certification: root.crt>" "<your-client-certification: client.crt>" "<your-client-key: client.key>" from server and client, and copy into this directory.Default value is "/devcon/cp4ba-install-helper/5.1.3/cert-kubernetes/scripts/cp4ba-prerequisites/propertyfile/cert/db/dbserver1".
## If POSTGRESQL_SSL_CLIENT_SERVER is "False" and DATABASE_SSL_ENABLE is "True", please get the SSL certificate file (rename db-cert.crt) from server and then copy into this directory.Default value is "/devcon/cp4ba-install-helper/5.1.3/cert-kubernetes/scripts/cp4ba-prerequisites/propertyfile/cert/db/dbserver1".
dbserver1.DATABASE_SSL_CERT_FILE_FOLDER="/tmp"

EOF

