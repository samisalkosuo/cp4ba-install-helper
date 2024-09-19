#!/bin/bash

#this script installs CP4BA prereqs to given namespace:
#Active Directory
#PostgreSQL
#Mongo

if [[ "$CP4BA_NAMESPACE" == "" ]]; then
    echo "CP4BA_NAMESPACE environment variable is not set."
    exit 1
fi

bash ./activedirectory/install-activedirectory.sh $CP4BA_NAMESPACE
bash ./mongodb/install-mongodb.sh $CP4BA_NAMESPACE
bash ./gitea/install-gitea.sh $CP4BA_NAMESPACE
