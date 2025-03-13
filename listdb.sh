#! /bin/bash


function list_database {
    clear

    if [ ! -d "./Databases" ]; then
        echo "**********************************************"
        echo -e "\n  Databases folder does not exist.\n"
        echo "**********************************************"
        read -p "press enter to go to create database..." dummy
        create_database 
        return 0
    fi
    if [ -z "$(ls -A "./Databases")" ]; then
        echo "**********************************************"
        echo -e "\n no databases found\n"
        echo "**********************************************"
        read -p "press enter to go to create database..." dummy
        create_database  
        return 0
    else
        echo "*************Databases*******************"
        ls -1 "./Databases" 
        echo "*****************************************"
        read -p "press enter to back to main manu..." dummy
        ./main.sh
        return 0;
    fi      
}