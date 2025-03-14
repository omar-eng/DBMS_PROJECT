#!/bin/bash



# soruces
source ./common.sh
source ./create_table.sh
source ./list_tables.sh

function table_menu {


    options=("create table" "list tables" "drop table" "insert into tables"
             "select from table" "delete from table" "update table" "exit")
    PS3=$'\n'"Select an option: "

    while true; do
        clear
        echo -e "\nYou are in $1 database\n"
        select opt in "${options[@]}"; do
            case $opt in
                "create table")
                    create_table "$1"
                    break
                    ;;
                "list tables")
                    list_tables "$1"
                    break
                    ;;
                "drop table")
                    drop_table "$1"
                    break
                    ;;
                "insert into tables")
                    insert_into_table "$1"
                    break
                    ;;
                "select from table")
                    select_from_table "$1"
                    break
                    ;;
                "delete from table")
                    delete_from_table "$1"
                    break
                    ;;
                "update table")
                    update_table "$1"
                    break
                    ;;
                "exit")
                    cd ../..
                    ./main.sh
                    return 0  
                    ;;
                *)
                    echo "invalid option, try again later."
                    break
                    ;;
            esac
        done
    done
}