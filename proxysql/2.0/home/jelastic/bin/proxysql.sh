#!/bin/bash

initialGalera="INSERT INTO mysql_galera_hostgroups (writer_hostgroup,backup_writer_hostgroup,reader_hostgroup,offline_hostgroup,active,max_writers,writer_is_also_reader,max_transactions_behind)
VALUES (2,4,3,1,1,1,0,100);"

initialMGR="INSERT INTO mysql_group_replication_hostgroups (writer_hostgroup,backup_writer_hostgroup,reader_hostgroup, offline_hostgroup,active,max_writers,writer_is_also_reader,max_transactions_behind) values (2,4,3,1,1,10,1,100);"

initialSimple="INSERT INTO mysql_replication_hostgroups VALUES (10,11,'Group setup');"

initialDB() {

ARGUMENT_LIST=(
	"clusterType"
	"adminUser"
	"adminPass"
)

# read arguments
opts=$(getopt \
    --longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)
eval set --$opts

while [[ $# -gt 0 ]]; do
   case "$1" in
        --adminUser)
            adminUser=$2
            shift 2
            ;;

        --adminPass)
            adminPass=$2
            shift 2
            ;;

        --clusterType)
            clusterType=$2
            shift 2
            ;;

        *)
            break
            ;;
    esac
done

mysqlCmd="mysql -h 127.0.0.1 -u ${adminUser} --password=${adminPass} -e"

    case "${clusterType}" in
        galera)
	    cmd="INSERT INTO mysql_galera_hostgroups (writer_hostgroup,backup_writer_hostgroup,reader_hostgroup,offline_hostgroup,active,max_writers,writer_is_also_reader,max_transactions_behind)
VALUES (2,4,3,1,1,1,0,100);"
            ;;

        multi|single)
	    cmd="INSERT INTO mysql_group_replication_hostgroups (writer_hostgroup,backup_writer_hostgroup,reader_hostgroup, offline_hostgroup,active,max_writers,writer_is_also_reader,max_transactions_behind) values (2,4,3,1,1,10,1,100);"
            ;;

        master|slave)
	    cmd="INSERT INTO mysql_replication_hostgroups VALUES (10,11,'Group setup');"
            ;;

        *)
            break
            ;;
    esac
    $mysqlCmd "$cmd" &>> /var/log/run.log

}

"$@"
