#!/bin/bash

# Function to display the menu and get user inputs
show_menu() {
    URL=""
    Filesize="None"
    while true; do
        dialog --backtitle "Media Downloader" --title "Menu" \
            --ok-label "Download" --cancel-label "Quit" \
            --form "\nEnter the download details:" 15 60 6 \
            "URL:" 1 1 "$URL" 1 15 50 150 \
            "Size:" 2 1 "$Filesize" 2 15 50 0 \
            2>temp.txt

        choice=$?

        if [ $choice -eq 0 ]; then
            read_inputs_from_file
            # Validate URL is not empty and is a valid URL
            if [ -z "$URL" ] || ! validate_url "$URL" ; then
                show_error "Invalid URL. Please enter a valid URL."
                continue
            fi

            # If empty filesize
            if [ -z $Filesize ]; then
                $Filesize="None"
            fi

            # Perform the download using the provided inputs
            download_file "$URL" "$Filesize" "mp4"

            # Clear temp file to highlight the URL field on the next iteration
            >temp.txt
        elif [ $choice -eq 1 -o $choice -eq 255 ]; then
            clear
            exit 0
        fi
    done
}

# Function to read user inputs from the temp file
read_inputs_from_file() {
    URL=$(sed -n '1p' temp.txt)
    Filesize=$(sed -n '2p' temp.txt)
}

# Function to validate the URL format
validate_url() {
    local url_regex="^https?://.*$"
    if [[ "$1" =~ $url_regex ]]; then
        return 0
    else
        return 1
    fi
}

# Function to show an error dialog
show_error() {
    dialog --backtitle "Media Downloader" --title "Error" \
        --msgbox "$1" 10 60
}

# Function to download the file
download_file() {
    clear
    if [ -z "$1" ] || ! validate_url "$1"; then
        echo "Invalid URL: $1"
        exit 0
    fi
    echo "Downloading file..."
    # File format
    ytcmd="--remux $3 --merge $3"
    # Filesize limit
    if [ "$2" != "None" ]; then
      ytcmd="--format-sort \"filesize:$2\" $ytcmd"
    fi
    # filename
    filename=$(yt-dlp --print filename -o "%(title)s" $1 --restrict-filenames)
    filename=${filename:0:230}
    outputpath="$SAVEDIR/$filename.$3"
    Filesize=$2
    ytcmd="$ytcmd --ignore-errors --no-abort-on-error --output \"$outputpath\""
    ytcmd="yt-dlp $ytcmd $1"
    echo "$ytcmd"
    eval "$ytcmd"
    
    if [ -f "$outputpath" ]; then
        echo "Download completed. [$1]"
    fi

    # re-encode / try to reach desired filesize
    if [ "$2" != "None" ] && [ -f "$outputpath" ]; then
        input_file="$outputpath"
        output_file="$SAVEDIR/$filename.$Filesize.$3"

        # Function to convert file size with units to bits
        convert_to_bits() {
            local size=$1
            local unit=$(echo "$size" | sed -E 's/[^A-Za-z]*//g')
            local value=$(echo "$size" | sed -E 's/[A-Za-z]*//g')

            case $unit in
                M | MB | m)
                echo "$((value * 1000 * 1000 * 8))"
                ;;
                G | GB | g)
                echo "$((value * 1000 * 1000 * 1000 * 8))"
                ;;
                K | KB | k)
                echo "$((value * 1000 * 8))"
                ;;
                *)
                # invalid unit, set to 0
                echo "0"
                ;;
            esac
        }

        video_size=$(wc -c <"$input_file")
        video_size_bits=$(echo "$video_size * 8" | bc)
        audio_size=$(ffprobe -v error -select_streams a:0 -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 "$input_file")
        audio_bitrates=("320" "256" "192")
        audio_bitrates+=($(echo "scale=0; $audio_size / 1000" | bc))

        # Find the nearest audio bitrate in the audio_bitrates array that is less than or equal to the input audio bitrate
        nearest_audio_bitrate="${audio_bitrates[-1]}"
        for bitrate in "${audio_bitrates[@]}"; do
            if ((bitrate <= $(echo "scale=0; $audio_size / 1000" | bc))); then
                nearest_audio_bitrate=$bitrate
                break
            fi
        done

        target_size=$(convert_to_bits "$2")
        if [ $target_size != "0" ]; then
            length=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input_file"`
            length_round_up=$(( ${length%.*} + 1 ))
            total_bitrate=$(( $target_size / $length_round_up ))
            audio_bitrate=$(( $nearest_audio_bitrate * 1000 ))
            video_bitrate=$(( $total_bitrate - $audio_bitrate ))

            # Check if the input file is already within the target size
            if ((video_size_bits <= target_size)); then
                echo "Input file is already within the target size."
            else
                ffmpeg -y -i "$input_file" -b:v $video_bitrate -maxrate:v $video_bitrate -bufsize:v $(( $target_size / 20 )) -b:a $audio_bitrate "$output_file"       
                # rm original
                rm -f $input_file
                # rename to original
                mv $output_file $input_file
            fi
        fi
        if [ $target_size == "0" ]; then
            echo "Encoding skipped. Valid filesize format = <size>k/m/g ex. 13M"
        fi
    fi
}

# self args
if [ "$1" == "url" ] && [ "$2" == "filesize" ]; then
    exit 0
fi

if [ -n "$1" ] && [ -z "$2" ]; then
    download_file "$1" "None" "mp4"
    exit 0
fi

if [ -n "$1" ] && [ -n "$2" ]; then
    download_file "$1" "$2" "mp4"
    exit 0
fi

if [ $# -eq 0 ] || [ "${1,,}" == "menu" ]; then
    # Run the menu
    while true; do
        show_menu
    done
fi