#!bin/bash

function get_file_name {
    file=$1

    [[ "$file" =~ ^(.*)\. ]]
    echo ${BASH_REMATCH[1]}
}

function get_file_extension {
    file=$1

    [[ "$file" =~ \.(.*)$ ]]
    echo ${BASH_REMATCH[1]}
}

function concat_directory_file {
    directory=$1
    file=$2

    >&2 echo "dir: $directory file: $file"

    if [[ -z $directory || -z $file ]]; then
        >&2 echo "Could not concat_directory_file"
        exit 1
    fi

    result=$directory
    if [[ "$directory" =~ (.*)/$ ]]; then
        result=${BASH_REMATCH[1]}
    fi

    result=$result"/"$file
    echo $result
}

function number_of_files {
    # directory=

    echo $(grep -c ".*" <&0)
}

function get_valid_video_files {
    directory=$1

    # in order to echo ls as multiple lines
    echo "$(ls $directory | grep -E "(\.mp4|\.mov)")"
}
