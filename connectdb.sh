#! /bin/bash

function connect_database {
    clear

    if [ ! -d "./Databases" ]; then
        echo "**********************************************"
        echo -e "\n no databases found\n"
        echo "**********************************************"

        read -p "press enter to go to create database..." dummy
        create_database 
        return
    fi

    echo "*************** Databases ********************"
    ls -1 "./Databases"
    echo "**********************************************"

    read -p "enter database name: " dbName

    if [ -d "./Databases/$dbName" ]; then
        cd "./Databases/$dbName"
        echo "**********************************************"
        echo "connected to $dbName database"
        echo "**********************************************"
        clear
        table_menu "$dbName"
    else
        echo "-------------------------------"
        echo "database $dbName does not exist"
        echo "-------------------------------"
         read -p "press enter to go back to manu..." dummy
        ./main.sh 
    fi
}