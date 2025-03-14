#!/usr/bin/bash

# INCLUDE SCRIPTS
# . ./common.sh



create_table(){
    clear
    DATABASE_NAME="$1"
    read -p "Enter table name: " TABLE_NAME

    create_table_files "$TABLE_NAME" 
    if [[ $? -eq 0 ]]; then
        echo "Table is created!" 
    else
        echo "Table already exists [Press any key to continue...]."
        read ; clear
        return
    fi
    read -p "Enter number of columns: " NUMBER_OF_COLUMNS
    declare -i COLUMN_NUM=0
    while [[ $COLUMN_NUM -lt $NUMBER_OF_COLUMNS ]]; do
        echo "Column [$(($COLUMN_NUM + 1))]: "
        read -p "Enter column name: " COLUMN_NAME
        read -p "Enter column data type (INT, STRING): " COLUMN_DATATYPE
        read -p "Enter column constraint (PRIMARY_KEY, empty): " COLUMN_CONSTRAIN
        add_column "$TABLE_NAME" "$COLUMN_NAME" "$COLUMN_DATATYPE" "$COLUMN_CONSTRAIN"
        case $? in
            0)
                echo "Column is created!"
                COLUMN_NUM+=1
                ;;
            2)
                echo "Error: Column already exists"
                ;;
            1)
                echo "Error: Table does not exist to create a column"
                ;;
        esac
    done
    clear
    echo "**********************************************"
    echo -e "\n $TABLE_NAME table has been created successfully.\n"
    echo "**********************************************"

    read -p "[Press enter to continue...]"
}

