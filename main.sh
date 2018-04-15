#!/bin/bash

source ./files-util.sh

aerial_files="aerial-cached-files.txt"
# for user prompts
exec 3<&0

# purpose:
# Take a directory of videos and generate an aerial screensaver directory

function get_line {
    line_num=$1
    let line_num+=1

    # awk is base-1
    echo $(awk 'NR == '$line_num <&0)
}

function create_aerial_cache_file {
    input_dir=$1
    output_dir=$2
    output_file_index=$3

    num_input_videos=$(get_valid_video_files $input_dir | number_of_files)
    <&2 echo "num_input_videos: $num_input_videos"
    input_file_index=$(($output_file_index % $num_input_videos))

    <&2 echo "input_file_index: $input_file_index"
    input_file=$(get_valid_video_files $input_dir | get_line $input_file_index)
    output_file=$(cat $aerial_files | get_line $output_file_index)

    ffmpeg -y -i $(concat_directory_file $input_dir $input_file) -acodec copy -vcodec copy -f mov $(concat_directory_file $output_dir $output_file)
}

function get_user_response {
    response=""
    until [[ "$response" =~ [yYnN] ]]; do
        read -u 3 -p "Currently only supports .mp4 and .mov, proceed? [y/N]: " response
    done

    [[ "$response" =~ [yY] ]]
}

# 1: input directory with files
# 2: output directory to generate aerial cache files
function main {
    input_dir=$1
    output_dir=$2

    if [[ ! -d $input_dir ]]; then
        echo "Need a valid input directory"
        exit 1
    fi

    file_count=$(ls $input_dir | grep -c -E "(\.mp4|\.mov)")
    if [[ $file_count -eq 0 ]]; then
        echo "Need valid videos in input directory"
    fi

    if [[ -n $output_dir && ! -d $output_dir ]]; then
        echo "Could not understand output directory"
        exit 1
    fi

    if [[ ! -n $output_dir ]]; then
        output_dir="generated"
    fi

    mkdir -p $output_dir

    if get_user_response; then
        line_num=0
        while read -r aerial_file; do
            create_aerial_cache_file $input_dir $output_dir $line_num
            let line_num+=1
        done < $aerial_files
    else
        echo "Bye bye."
    fi
}

main $1 $2
