
create_database() {
    clear
    read -p "Enter database name or press 0 to go to the main menu: " dbName

    if [ "$dbName" = "0" ]; then
        ./main.sh
        return 0
    fi

    if [[ ! $dbName =~ ^[a-zA-Z][a-zA-Z0-9_]{0,100}$ ]]; then
        echo "**********************************************"
        echo -e "\n Invalid database name. It must start with a letter and contain only alphanumeric characters and underscores.\n"
        echo "**********************************************"

        read -p "press enter to to back to main manu:..." dummy
        ./main.sh  
        return 1

    elif [ -d "./Databases/$dbName" ]; then
        echo "**********************************************"
        echo -e "\n $dbName database already exists.\n"
        echo "**********************************************"

        read -p "press enter to to back to main manu:..." dummy
        ./main.sh  
        return 0

    else
        mkdir -p "./Databases/$dbName"
        echo "**********************************************"
        echo -e "\n $dbName database has been created successfully.\n"
        echo "**********************************************"

        read -p "press enter to to back to main manu:..." dummy
        ./main.sh
        return 0
    fi
}