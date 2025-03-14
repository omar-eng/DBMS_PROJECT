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
    if [[ -e "meta_"$NAME$DB_FILE_EXTENSION && -e $NAME$DB_FILE_EXTENSION ]] ;
    then
        return 1;
    else  
        touch "meta_"$NAME$DB_FILE_EXTENSION $NAME$DB_FILE_EXTENSION;
        return 0;
    fi
}

# args: <table-name>
# return: 0 -> files is dropped, 1 -> failed.
drop_table_files(){
    local NAME=$1;
    if [[ -e "meta_"$NAME$DB_FILE_EXTENSION && -e $NAME$DB_FILE_EXTENSION ]] ;
    then
        rm "meta_"$NAME$DB_FILE_EXTENSION $NAME$DB_FILE_EXTENSION;
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

    if [[ ! -e "meta_${TABLE_NAME}${DB_FILE_EXTENSION}" ]]; then
        return 1
    fi

    if grep -q "^${COLUMN_NAME}:" "meta_${TABLE_NAME}${DB_FILE_EXTENSION}"; then
        return 2
    fi

    if [[ "$DATA_TYPE" == "INT" ]]; then 
        DATA_TYPE=int
    else
        DATA_TYPE=str
    fi
    
    if [[ "$CONSTRAIN" == "PRIMARY_KEY" ]]; then
        echo "${COLUMN_NAME}:${DATA_TYPE}:PK" >> "meta_${TABLE_NAME}${DB_FILE_EXTENSION}"
    else
        echo "${COLUMN_NAME}:${DATA_TYPE}:" >> "meta_${TABLE_NAME}${DB_FILE_EXTENSION}"
    fi
    return 0
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
