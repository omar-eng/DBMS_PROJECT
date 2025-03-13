#! /bin/bash



function drop_database {
    clear
    
    if [ ! -d "./Databases" ]; then
        echo "**********************************************"
        echo -e "\n The Databases folder does not exist.\n"
        echo "**********************************************"
        read -p "Press Enter to back to main manu..." dummy
        ./main.sh
        return 0
    fi

    if [ -z "$(ls -A "./Databases")" ]; then
        echo "**********************************************"
        echo -e "\n No databases found\n"
        echo "**********************************************"
        read -p "press enter to go to create database..." dummy
        create_database  
        return 0
    else
        echo "*************** Databases ********************"
        ls -1 "./Databases"
        echo -e "******************************************* \n"
        read -p "Enter database name or 0 to back to main manu: " dbName
        
         if [ "$dbName" = "0" ]; then
        ./main.sh
        return 0
        fi
        
        if [ -d "./Databases/$dbName" ]; then 
            rm -r "./Databases/$dbName"
            echo "--------------------------------------"
            echo  "Database $dbName dropped successfully"
            echo "--------------------------------------"
            read -p "press enter to to back to main manu:..." dummy
            ./main.sh

        else
            echo "-------------------------------"
            echo "Database $dbName does not exist"
            echo "-------------------------------"
            read -p "press enter to to back to main manu:..." dummy
            ./main.sh

        fi
    fi
}