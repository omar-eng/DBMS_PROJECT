#!/usr/bin/bash





function delete_from_table(){
    clear
    DATABASE_NAME="$1"
    read -p "Enter table name: " TABLE_NAME
    read -p "Enter primary key value: " PK_VALUE
    delete_row $TABLE_NAME $PK_VALUE
    if [[ $? -eq 1 ]]; then
        echo "Error: table does not exist"
    else
        clear
        echo "**********************************************"
        echo -e "\n Row has been deleted successfully.\n"
        echo "**********************************************"
    fi
    read -p "[Press enter to continue...]"
    table_menu "$DATABASE_NAME"
}