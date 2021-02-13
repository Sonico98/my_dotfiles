#!/bin/bash

# Batch transcode files in a folder
mkdir -p $HOME/Videos/MP4

for video in *.mkv
do
    base=${video%%.*}
    echo "Extracting subs..."
    ffmpeg -y -i "$base.mkv" "$base.ass"
    clear
    echo "Subtitles extracted. Transcoding..."
    time (ffpb -i "$base.mkv" -filter_complex "ass='$base.ass'" -c:a libfdk_aac -c:v libx264 -crf 18 -b:a 256k -pix_fmt yuv420p -preset slow -profile:v high -profile:a aac_low -bf 2 -tune animation -movflags faststart "/mnt/Heaven/Videos/MP4/$base.mp4")
done
