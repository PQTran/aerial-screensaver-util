#!/bin/bash

source ./files-util.sh

function get_video_length {
    video=$1

    line=$(ffmpeg -i $video 2>&1 | grep "Duration")
    hours=""
    minutes=""
    seconds=""
    if [[ "$line" =~ ([0-9]*):([0-9]*):([0-9]*)\. ]]; then
	hours=${BASH_REMATCH[1]}
	minutes=${BASH_REMATCH[2]}
	seconds=${BASH_REMATCH[3]}
    else
	"Unable to parse length."
	exit 1
    fi

    if [[ -z $hours || -z $minutes || -z $seconds ]]; then
	"Unable to parse length."
	exit 1
    fi

    echo $(( ($hours * 3600) + ($minutes * 60) + $seconds ))
}

function main {
    input_video=$1
    minimum_length=$2
    output_dir=$3

    if [[ ! -f $input_video ]]; then
        echo "Could not understand input file"
        exit 1
    fi

    if [[ -z $minimum_length ]]; then
	minimum_length=600
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

    video_length=$(get_video_length $input_video)

    output_video_length=0
    iteration=0
    while [[ $output_video_length -lt $minimum_length ]]; do
	echo "iteration: $iteration, $output_video_length"
	echo "file '$input_video'" >> $temp_file
	let output_video_length+=$video_length
    done

    cat $temp_file
    ffmpeg -f concat -safe 0 -i $temp_file -c copy $(concat_directory_file $output_dir "output_file.mov")

}

main $1 $2 $3
