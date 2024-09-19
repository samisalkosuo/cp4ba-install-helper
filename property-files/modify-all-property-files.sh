#!/bin/bash

cdir=$(pwd)

#get script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd $SCRIPT_DIR

./create-cp4ba-LDAP-property-file.sh
./modify-cp4ba-user-profile-property-file.sh

cd $cdir
