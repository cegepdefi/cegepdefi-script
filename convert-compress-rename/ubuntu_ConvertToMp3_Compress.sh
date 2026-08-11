#!/bin/bash

# Create output folder (optional)
mkdir -p mp3_out

# Loop through all audio files
for f in *.wav *.flac *.aac *.ogg *.m4a *.wma *.aiff *.mp3; do
    # Skip if no files match
    [ -e "$f" ] || continue

    # Remove extension
    base="${f%.*}"

    # Convert to MP3 (128 kbps)
    ffmpeg -i "$f" -vn -ar 44100 -ac 2 -b:a 128k "mp3_out/${base}.mp3"
done
