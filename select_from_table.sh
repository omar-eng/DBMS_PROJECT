#!/bin/bash

function select_from_table {
    local db_name="$1"
    clear
    
    # 1. Check if there are any tables
    local tables=$(get_available_tables)
    if [[ -z "$tables" ]]; then
        echo "----------------------------------"
        echo "no tables exist in the database"
        echo "----------------------------------"
        read -p "[press enter to continue...]"
        table_menu "$db_name"
        return
    fi
    
    # 2. Show available tables and get table name
    echo "available tables:"
    echo "$tables"
    echo
    read -p "enter table name: " table_name
    
    # 3. Validate table existence
    if ! file_exists "${table_name}${DB_FILE_EXTENSION}"; then
        echo "----------------------------------"
        echo "error: Table does not exist"
        echo "----------------------------------"
        read -p "[press enter to continue...]"
        table_menu "$db_name"
        return
    fi
    
    # 4. Get column names from metadata
    local col_names=($(cut -d ':' -f 1 "$META_DATA_FILE_PREFIX${table_name}${DB_FILE_EXTENSION}"))
    
    # 5. Get selection options
    read -p "enter column name to select (enter for all): " column_name
    read -p "enter primary key value to filter (enter for all): " pk_value
    
    echo "----------------------------------"
    if [[ -z "$column_name" && -z "$pk_value" ]]; then
        # Select all records with header
        echo "${col_names[*]}" | tr ' ' ':'
        echo "----------------------------------"
        awk -F: '{print $0}' "${table_name}${DB_FILE_EXTENSION}"
    elif [[ -z "$column_name" ]]; then
        # Select all columns for specific PK with header
        echo "${col_names[*]}" | tr ' ' ':'
        echo "----------------------------------"
        awk -F: -v pk="$pk_value" '$1 == pk {print $0}' "${table_name}${DB_FILE_EXTENSION}"
    else
        # get column position
        local col_num=0
        for i in "${!col_names[@]}"; do
            if [[ "${col_names[$i]}" == "$column_name" ]]; then
                col_num=$((i+1))
                break
            fi
        done
        
        if [[ $col_num -eq 0 ]]; then
            echo "error: Column '$column_name' not found"
        elif [[ -z "$pk_value" ]]; then
            # select specific column for all records with header
            echo "${col_names[$((col_num-1))]}"
            echo "----------------------------------"
            awk -F: -v col="$col_num" '{print $col}' "${table_name}${DB_FILE_EXTENSION}"
        else
            # select specific column for specific PK with header
            echo "${col_names[$((col_num-1))]}"
            echo "----------------------------------"
            awk -F: -v col="$col_num" -v pk="$pk_value" '$1 == pk {print $col}' "${table_name}${DB_FILE_EXTENSION}"
        fi
    fi
    echo "----------------------------------"
    
    read -p "[press enter to continue...]"
    table_menu "$db_name"
}