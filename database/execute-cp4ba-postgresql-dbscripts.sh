#!/bin/bash

if [[ "$CP4BA_NAMESPACE" == "" ]]; then
    echo "CP4BA_NAMESPACE environment variable is not set."
    exit 1
fi

if [[ "$CP4BA_CASE_VERSION" == "" ]]; then
    echo "CP4BA_CASE_VERSION environment variable is not set."
    exit 1
fi
cdir=$(pwd)

#get script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PREREQ_DIR=${SCRIPT_DIR}/../${CP4BA_CASE_VERSION}/cert-kubernetes/scripts/cp4ba-prerequisites
CONTAINER_NAME=prereq-cp4ba-postgres
POD_NAME=${CONTAINER_NAME}-0

set -e 
oc cp -c ${CONTAINER_NAME} $PREREQ_DIR/dbscript ${CP4BA_NAMESPACE}/${POD_NAME}:/tmp/
set +e

cd $SCRIPT_DIR

#create script
SCRIPT_FILE=run-sql-in-container.sh
cat > $SCRIPT_FILE << EOF

function execute
{
    local cdir=\$(pwd)
    local DIR=/tmp/dbscript/\$1/postgresql/dbserver1/
    if [ -d \$DIR ]; then
      echo "Executing \$1 SQL scripts..."
      cd \$DIR
      ls -1 *sql | awk '{print "psql -f " \$1}' |sh
      cd \$cdir
      echo "Executing \$1 SQL scripts...done"
    fi
}
execute adp
execute ae
execute ban
execute bas
execute baw-aws
execute fncm
execute odm

EOF

oc cp -c ${CONTAINER_NAME} $SCRIPT_FILE ${CP4BA_NAMESPACE}/${POD_NAME}:/tmp/

oc exec -n ${CP4BA_NAMESPACE} -c ${CONTAINER_NAME} -it ${POD_NAME} -- bash -c "cd /tmp && bash $SCRIPT_FILE"

cd $cdir

#rm -f $SCRIPT_FILE
