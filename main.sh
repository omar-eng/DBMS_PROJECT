#!/bin/bash

source "./createdb.sh"
source "./listdb.sh"
source "./connectdb.sh"
source "./dropdb.sh"
source "./tablemenu.sh"
clear
echo "                                            Welcome $USER"

options=("create database" "list database" "connect database" "drop database" "exit")

        PS3="Please select an option: "
        select op in "${options[@]}"; do
            case $op in
                "create database")
                    create_database
                    break
                    ;;
                "list database")
                    list_database
                    break
                    ;;
                "connect database")
                    connect_database
                    break
                    ;;
                "drop database")
                    drop_database
                    break
                    ;;
                "exit")
                    echo "Goodbye!"
                    break
                    ;;
                *)
                echo "invalid option '$REPLY'.exiting..."
                    
                    break
                    ;;
            esac
done
    
