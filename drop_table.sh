#!/usr/bin/bash


drop_table(){
    clear
    read -p "Enter table name: " TABLE_NAME
    drop_table_files "$TABLE_NAME"
    if [[ $? -eq 0 ]]; then
        echo "Table '$TABLE_NAME' dropped successfully."
    else
        echo "Failed to drop table '$TABLE_NAME'."
    fi
    read -p "[Press enter to continue...]"
    clear
    table_menu "$DATABASE_NAME"
}
