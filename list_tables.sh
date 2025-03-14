#!/usr/bin/bash

# . ./common.sh

list_tables(){
    clear
    local TABLES=`get_available_tables`;
    if [[ -z "$TABLES" ]]; then
        echo "No tables available."
    else
        echo -e "Available Tables:\n"
        echo "Table Name"
        echo " ----------------------"
        for table in $TABLES; do
            printf "| %-20s |\n" "$table"
            echo " ----------------------"
        done
    fi
    echo "[Press any key to continue...]"
    read ; clear
}