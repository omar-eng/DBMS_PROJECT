#!/bin/bash

function update_table {
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
    echo "Available tables:"
    echo "$tables"
    echo

    read -p "Enter table name: " table_name
    if ! file_exists "${table_name}${DB_FILE_EXTENSION}"; then
        echo "----------------------------------"
        echo "error: Table does not exist"
        echo "----------------------------------"
        read -p "[press enter to continue...]"
        table_menu "$db_name"
        return
    fi
    
    # Column information
    local column_names=($(cut -d ':' -f 1 "$META_DATA_FILE_PREFIX${table_name}${DB_FILE_EXTENSION}"))
    local column_types=($(cut -d ':' -f 2 "$META_DATA_FILE_PREFIX${table_name}${DB_FILE_EXTENSION}"))
    local column_constraints=($(cut -d ':' -f 3 "$META_DATA_FILE_PREFIX${table_name}${DB_FILE_EXTENSION}"))
    
    # get the PK column index
    local pk_col_num=-1
    for i in "${!column_constraints[@]}"; do
        if [[ "${column_constraints[$i]}" == "PK" ]]; then
            pk_col_num=$((i + 1))  
            break
        fi
    done
    if [[ $pk_col_num -eq -1 ]]; then
        echo "----------------------------------"
        echo "error: No primary key defined for table"
        echo "----------------------------------"
        read -p "[press enter to continue...]"
        table_menu "$db_name"
        return
    fi
    
    # get PK to update
    read -p "Enter primary key value to update: " pk_value
    
    # check if record exists (using dynamic PK column)
    local record_exists=$(awk -F: -v pk="$pk_value" -v pk_col="$pk_col_num" '$pk_col == pk {print "FOUND"}' "${table_name}${DB_FILE_EXTENSION}")
    if [[ -z "$record_exists" ]]; then
        echo "----------------------------------"
        echo "error: Record with primary key '$pk_value' not found"
        echo "----------------------------------"
        read -p "[press enter to continue...]"
        table_menu "$db_name"
        return
    fi
    
    # Show current record
    echo "current record:"
    echo "----------------------------------"
    awk -F: -v pk="$pk_value" -v pk_col="$pk_col_num" '$pk_col == pk {print $0}' "${table_name}${DB_FILE_EXTENSION}"
    echo "----------------------------------"
    
    # Show all available columns
    echo "columns available to update:"
    for i in "${!column_names[@]}"; do
        echo "$i. ${column_names[$i]} (${column_types[$i]})"
    done
    
    # Get update details
    read -p "enter column number to update (or 'q' to cancel): " col_num
    if [[ "$col_num" == "q" ]]; then
        table_menu "$db_name"
        return
    fi
    
    # Validate column number
    if ! [[ "$col_num" =~ ^[0-9]+$ ]] || [[ $col_num -ge ${#column_names[@]} ]]; then
        echo "----------------------------------"
        echo "error: Invalid column number"
        echo "----------------------------------"
        read -p "[press enter to continue...]"
        table_menu "$db_name"
        return
    fi
    
    read -p "enter new value: " new_value
    
    # Validate data type
    if [[ "${column_types[$col_num]}" == "int" && ! "$new_value" =~ ^-?[0-9]+$ ]]; then
        echo "----------------------------------"
        echo "error: value must be an integer"
        echo "----------------------------------"
        read -p "[press enter to continue...]"
        table_menu "$db_name"
        return
    fi
    
    # If updating the PK column, check for uniqueness
    if [[ $col_num -eq $((pk_col_num - 1)) ]]; then  
        local pk_exists=$(awk -F: -v new_pk="$new_value" -v old_pk="$pk_value" -v pk_col="$pk_col_num" '$pk_col == new_pk && $pk_col != old_pk {print "EXISTS"}' "${table_name}${DB_FILE_EXTENSION}")
        if [[ -n "$pk_exists" ]]; then
            echo "----------------------------------"
            echo "error: Primary key '$new_value' already exists"
            echo "----------------------------------"
            read -p "[press enter to continue...]"
            table_menu "$db_name"
            return
        fi
    fi
    
    # Perform update (using dynamic PK column)
    awk -F: -v pk="$pk_value" -v pk_col="$pk_col_num" -v col="$((col_num+1))" -v val="$new_value" '
        BEGIN {OFS=FS}
        $pk_col == pk {$col = val}
        {print}
    ' "${table_name}${DB_FILE_EXTENSION}" > .temp_update && mv .temp_update "${table_name}${DB_FILE_EXTENSION}"
    
    if [[ $? -eq 0 ]]; then
        echo "----------------------------------"
        echo "record updated successfully"
        echo "----------------------------------"
    else
        echo "----------------------------------"
        echo "error: Update failed"
        echo "----------------------------------"
    fi
    
    read -p "[press enter to continue...]"
    table_menu "$db_name"
}