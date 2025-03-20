#!/usr/bin/bash

# Data files named by their table name.
# Table name must NOT begin with 'meta_'.
DB_FILE_EXTENSION=.csv
META_DATA_FILE_PREFIX=meta_        # followed by table name
# echo $META_DATA_FILE_POSTFIX;


get_available_tables(){
    for file in *$DB_FILE_EXTENSION; do
        table_name=$(basename "$file" $DB_FILE_EXTENSION)
        if [[ $table_name != $META_DATA_FILE_PREFIX* ]]; then
            echo $table_name
        fi
    done
}

# args: <table-name>
# return 0 -> files is created, 1 -> table files already exists.
create_table_files(){
    local NAME=$1;
    if [[ -e $META_DATA_FILE_PREFIX$NAME$DB_FILE_EXTENSION && -e $NAME$DB_FILE_EXTENSION ]] ;
    then
        return 1;
    else  
        touch $META_DATA_FILE_PREFIX$NAME$DB_FILE_EXTENSION $NAME$DB_FILE_EXTENSION;
        return 0;
    fi
}

# args: <table-name>
# return: 0 -> files is dropped, 1 -> failed.
drop_table_files(){
    local NAME=$1;
    if [[ -e $META_DATA_FILE_PREFIX$NAME$DB_FILE_EXTENSION && -e $NAME$DB_FILE_EXTENSION ]] ;
    then
        rm $META_DATA_FILE_PREFIX$NAME$DB_FILE_EXTENSION $NAME$DB_FILE_EXTENSION;
        return 0;
    else  
        return 1;
    fi
}

# args: <table-name> <column-name> <data-type> <constrain>
#    - <data-type> : INT, STRING
#    - <constrain> : PRIMARY_KEY
# return: 0 -> success, 1 -> table does not exist, 2 -> column is already exists.
add_column() {
    local TABLE_NAME="$1"
    local COLUMN_NAME="$2"
    local DATA_TYPE="$3"
    local CONSTRAIN="$4"

    if [[ ! -e "$META_DATA_FILE_PREFIX${TABLE_NAME}${DB_FILE_EXTENSION}" ]]; then
        return 1
    fi

    if grep -q "^${COLUMN_NAME}:" "$META_DATA_FILE_PREFIX${TABLE_NAME}${DB_FILE_EXTENSION}"; then
        return 2
    fi

    if [[ "$DATA_TYPE" == "1" ]]; then 
        DATA_TYPE=int
    else
        DATA_TYPE=str
    fi
    
    if [[ "$CONSTRAIN" == "1" ]]; then
        echo "${COLUMN_NAME}:${DATA_TYPE}:PK" >> "$META_DATA_FILE_PREFIX${TABLE_NAME}${DB_FILE_EXTENSION}"
    else
        echo "${COLUMN_NAME}:${DATA_TYPE}:" >> "$META_DATA_FILE_PREFIX${TABLE_NAME}${DB_FILE_EXTENSION}"
    fi
    return 0
}



# return: 0 -> success, 1 -> table does not exist, 2 -> invalid number of data fields, 
#         3 -> attribute data type mismatch(column name returned), 4 -> duplicate primary key.
add_row(){
    local TABLE_NAME="$1"
    shift # Shift the positional parameters to the left
    local ROW_DATA=("$@")

    if [[ ! -e "$META_DATA_FILE_PREFIX${TABLE_NAME}${DB_FILE_EXTENSION}" ]]; then
        return 1
    fi

    local COLUMN_NAMES=($(cut -d ':' -f 1 "$META_DATA_FILE_PREFIX${TABLE_NAME}${DB_FILE_EXTENSION}"))
    local COLUMN_DATATYPE=($(cut -d ':' -f 2 "$META_DATA_FILE_PREFIX${TABLE_NAME}${DB_FILE_EXTENSION}"))
    local COLUMN_CONST=($(cut -d ':' -f 3 "$META_DATA_FILE_PREFIX${TABLE_NAME}${DB_FILE_EXTENSION}"))

    if [[ ${#ROW_DATA[@]} -ne ${#COLUMN_NAMES[@]} ]]; then
        return 2
    fi

    for i in "${!ROW_DATA[@]}"; do # iterate on data
        if [[ "${COLUMN_DATATYPE[$i]}" == "int" && ! "${ROW_DATA[$i]}" =~ ^-?[0-9]+$ ]]; then
            echo "${COLUMN_NAMES[$i]}"
            return 3
        fi
    done
    # assuming that the first column is the only possible primary key
    if [[ ${COLUMN_CONST[0]} == "PK" ]]; then
        local PRIMARY_KEY_COLUMN_DATA=($(cut -d ':' -f 1 "${TABLE_NAME}${DB_FILE_EXTENSION}"))
        for pk in "${PRIMARY_KEY_COLUMN_DATA[@]}"; do
            if [[ "$pk" == "${ROW_DATA[0]}" ]]; then
                return 4
            fi
        done
    fi

    local ROW_STRING=$(IFS=:; echo "${ROW_DATA[*]}") # make the data in this format (field1:field1:field1)
    echo "$ROW_STRING" >> "${TABLE_NAME}${DB_FILE_EXTENSION}"
    return 0

}

# return: 0 -> success, 1 -> table does not exist
delete_row(){
    local TABLE_NAME="$1"
    local PK_VALUE="$2"

    if [[ ! -e "$META_DATA_FILE_PREFIX${TABLE_NAME}${DB_FILE_EXTENSION}" ]]; then
        return 1
    fi

    awk -F: -v pk_value="$PK_VALUE" 'BEGIN {OFS=FS} $1 != pk_value' "${TABLE_NAME}${DB_FILE_EXTENSION}" > .temp && mv .temp "${TABLE_NAME}${DB_FILE_EXTENSION}"
    return 0

}

file_exists() {
    if [ -f "$1" ]; then
        return 0
    else
        return 1
    fi
}
# echo creating track table;
# create_table_files track;
# echo return status $?

# echo adding a column to track table;
# add_column track id INT PRIMARY_KEY
# echo return status $?


# echo dropping track table;
# drop_table_files track;
# echo return status $?

# echo 'available tables:';
# echo `get_available_tables`;
