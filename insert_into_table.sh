






function insert_into_table(){
    DATABASE_NAME="$1"
    clear
    read -p "Enter table name: " TABLE_NAME
    read -p "Enter data fields separated by space: " -a DATA_FIELDS

    ERROR_COLUMN_NAME=$(add_row "$TABLE_NAME" ${DATA_FIELDS[@]})

    ERROR_CODE=$?
    if [[ $ERROR_CODE -eq 1 ]]; then
        echo "Error: Table does not exist"
    elif [[ $ERROR_CODE -eq 2 ]]; then
        echo "Error: Invalid number of columns"
    elif [[ $ERROR_CODE -eq 3 ]]; then
        echo "Error: field data type mismatch at column: $ERROR_COLUMN_NAME"
    elif [[ $ERROR_CODE -eq 4 ]]; then
        echo "Error: duplicated primary key value"
    else
        clear
        echo "**********************************************"
        echo -e "\n Row has been inserted successfully.\n"
        echo "**********************************************"
    fi
    read -p "[Press enter to continue...]"
    table_menu "$DATABASE_NAME"   
}