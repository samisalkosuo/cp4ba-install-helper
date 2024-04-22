
function execute
{
    local cdir=$(pwd)
    local DIR=/tmp/dbscript/$1/postgresql/dbserver1/
    cd $DIR
    ls -1 *sql | awk '{print "psql -f " $1}' |sh
    cd $cdir
}
execute adp
execute ae
execute ban
execute bas
execute fncm
execute odm

