#!/bin/bash



# soruces

function table_menu {

    clear
    echo -e "\nYou are in $1 database\n"

    options=("create table" "list tables" "drop table" "insert into tables"
             "select from table" "delete from table" "update table" "exit")
    PS3=$'\n'"Select an option: "

        select opt in "${options[@]}"; do
            case $opt in
                "create table")
                    create_table "$1"
                    ;;
                "list tables")
                    list_tables "$1"
                    ;;
                "drop table")
                    drop_table "$1"
                    ;;
                "insert into tables")
                    insert_into_table "$1"
                    ;;
                "select from table")
                    select_from_table "$1"
                    ;;
                "delete from table")
                    delete_from_table "$1"
                    ;;
                "update table")
                    update_table "$1"
                    ;;
                "exit")
                    cd ../..
                    ./main.sh
                    return 0  
                    ;;
                *)
                    echo "invalid option,try again later."
                    cd ../..
                    ./main.sh
                    ;;
            esac
            break  
        done
    
}