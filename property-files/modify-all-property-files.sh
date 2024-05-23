#!/bin/bash

cdir=$(pwd)

#get script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd $SCRIPT_DIR

./modify-cp4ba-db-name-user-property-file.sh
./create-cp4ba-db-server-property-file.sh
./create-cp4ba-LDAP-property-file.sh
./modify-cp4ba-user-profile-property-file.sh

cd $cdir
