#!/bin/bash

function main {
    input_file=$1
    minimum_length=$2
    output_dir=$3

    if [[ ! -f $input_file ]]; then
        echo "Could not understand input file"
        exit 1
    fi

    if [[ -n $output_dir && ! -d $output_dir ]]; then
        echo "Could not understand output directory"
        exit 1
    fi

    if [[ ! -n $output_dir ]]; then
        output_dir="generated"
    fi

    mkdir -p $output_dir

    temp_file=$(mktemp)
    echo "file '$input_file'" >> $temp_file

    # TO DO: find the video length of file
    # calculate how many repeats to cover minimum_length
    # set default of minimum_length to 10mins
    # ffmpeg -f concat -i $temp_file -c copy $output_dir/output_file.mov

}

main $1 $2 $3