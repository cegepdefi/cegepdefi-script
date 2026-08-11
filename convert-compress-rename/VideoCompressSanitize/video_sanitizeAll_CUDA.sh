#!/bin/bash

# ffmpeg -encoders | grep nvenc

mkdir -p sanitized_videos

find . -type f -iname "*.mp4" | while read -r file; do
    base="$(basename "$file" .mp4)"
    out="sanitized_videos/${base}_sanitized.mp4"

    echo "Sanitizing: $file"
    ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i "$file" \
      -map 0:v:0 -map 0:a? \
      -vf "format=yuv420p" \
      -c:v h264_nvenc -preset slow -crf 20 \
      -c:a aac -b:a 128k \
      -map_metadata -1 -map_chapters -1 \
      -movflags +faststart \
      -fflags +genpts \
      -strict -2 \
      "$out"
done