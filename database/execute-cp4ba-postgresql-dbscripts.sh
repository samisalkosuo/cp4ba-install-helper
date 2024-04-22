#!/bin/bash

if [[ "$1" == "" ]]; then
    echo "CP4BA PostgreSQL namespace is missing."
    exit 1
fi

if [[ "$2" == "" ]]; then
    echo "'cp4ba-prerequisites'-directory is missing."
    exit 1
fi

cdir=$(pwd)

NAMESPACE=$1
PREREQ_DIR=$2
#get script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd $SCRIPT_DIR

oc cp -c postgres $PREREQ_DIR/dbscript $NAMESPACE/postgres-0:/tmp/

#create script
SCRIPT_FILE=execute-sql-in-container.sh
cat > $SCRIPT_FILE << EOF

function execute
{
    local cdir=\$(pwd)
    local DIR=/tmp/dbscript/\$1/postgresql/dbserver1/
    cd \$DIR
    ls -1 *sql | awk '{print "psql -f " \$1}' |sh
    cd \$cdir
}
execute adp
execute ae
execute ban
execute bas
execute fncm
execute odm

EOF

oc cp -c postgres $SCRIPT_FILE $NAMESPACE/postgres-0:/tmp/

oc exec -n $NAMESPACE -c postgres -it postgres-0 -- bash -c "cd /tmp && bash $SCRIPT_FILE"

cd $cdir

#rm -f $SCRIPT_FILE
