#!/bin/bash

mkdir -p repaired_videos
mkdir -p sanitized_videos
mkdir -p logs

SUCCESS_LOG="logs/success.log"
ERROR_LOG="logs/errors.log"
REPAIRED_LOG="logs/repaired.log"

> "$SUCCESS_LOG"
> "$ERROR_LOG"
> "$REPAIRED_LOG"

for file in *.mp4; do
    [ -e "$file" ] || continue

    base="${file%.mp4}"
    repaired="repaired_videos/${base}_repaired.mp4"
    sanitized="sanitized_videos/${base}_sanitized.mp4"
    ffmpeg_log="logs/ffmpeg_${base}.log"

    echo "----------------------------------------"
    echo "Analizando integridad: $file"

    # 1) Verificar corrupción estructural
    ffmpeg -v error -i "$file" -f null - 2> "$ffmpeg_log"
    if [ $? -ne 0 ]; then
        echo "⚠️ Archivo con errores: $file"
        echo "$file" >> "$ERROR_LOG"

        echo "Intentando reparación..."
        ffmpeg -y -i "$file" \
          -c:v libx264 -preset medium -crf 18 \
          -c:a aac -b:a 192k \
          -fflags +genpts \
          "$repaired" >> "$ffmpeg_log" 2>&1

        if [ $? -ne 0 ]; then
            echo "❌ Reparación fallida: $file"
            echo "$file" >> "$ERROR_LOG"
            continue
        fi

        echo "✔️ Reparado: $file"
        echo "$file" >> "$REPAIRED_LOG"
        input="$repaired"
    else
        echo "✔️ Integridad OK: $file"
        input="$file"
    fi

    echo "Sanitizando: $input"

    # 2) Sanitizar el video (redecodificación completa)
    ffmpeg -y -i "$input" \
      -map 0:v:0 -map 0:a? \
      -vf "format=yuv420p" \
      -c:v libx264 -preset slow -crf 20 \
      -c:a aac -b:a 128k \
      -map_metadata -1 -map_chapters -1 \
      -movflags +faststart \
      -fflags +genpts \
      "$sanitized" >> "$ffmpeg_log" 2>&1

    if [ $? -eq 0 ]; then
        echo "✔️ Sanitizado correctamente: $file"
        echo "$file" >> "$SUCCESS_LOG"
    else
        echo "❌ Error sanitizando: $file"
        echo "$file" >> "$ERROR_LOG"
    fi
done

echo "----------------------------------------"
echo "Proceso completado."
echo "Videos OK: $SUCCESS_LOG"
echo "Videos reparados: $REPAIRED_LOG"
echo "Videos con errores: $ERROR_LOG"
