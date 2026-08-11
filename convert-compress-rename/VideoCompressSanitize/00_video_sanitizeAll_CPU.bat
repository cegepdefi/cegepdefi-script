@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM CONFIG
REM ============================================================

set "OUTPUT_DIR=sanitized_videos"

REM Codec NVIDIA
set "V_CODEC=hevc_nvenc"

REM Calidad:
REM 18 = casi sin pérdida (muy pesado)
REM 22 = alta calidad
REM 26 = buena compresión
REM 28 = excelente balance
set "CQ=28"

REM Preset:
REM p1 = más rápido
REM p7 = mejor calidad
set "PRESET=p5"

REM Bitrate máximo permitido
set "MAXRATE=4M"

REM Buffer
set "BUFSIZE=8M"

REM Audio
set "AUDIO_BITRATE=128k"

REM ============================================================

if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
)

echo.
echo ============================================================
echo NVIDIA NVENC Batch Encoder
echo ============================================================
echo.

for /R %%F in (*.mp4) do (

    REM Obtener carpeta del archivo actual
    set "FILEDIR=%%~dpF"

    REM Quitar barra final
    set "FILEDIR=!FILEDIR:~0,-1!"

    REM Saltar archivos ya procesados
    echo !FILEDIR! | find /I "%OUTPUT_DIR%" >nul

    if errorlevel 1 (

        set "infile=%%~fF"
        set "basename=%%~nF"

        set "outfile=%OUTPUT_DIR%\!basename!_compressed.mp4"

        echo.
        echo ------------------------------------------------
        echo INPUT:
        echo !infile!
        echo.
        echo OUTPUT:
        echo !outfile!
        echo ------------------------------------------------
        echo.

        ffmpeg ^
            -hide_banner ^
            -loglevel error ^
            -stats ^
            -y ^
            -hwaccel cuda ^
            -i "!infile!" ^
            -map 0:v:0 ^
            -map 0:a? ^
            -vf "format=yuv420p" ^
            -c:v %V_CODEC% ^
            -preset %PRESET% ^
            -rc vbr_hq ^
            -cq %CQ% ^
            -b:v 0 ^
            -maxrate %MAXRATE% ^
            -bufsize %BUFSIZE% ^
            -spatial_aq 1 ^
            -aq-strength 8 ^
            -pix_fmt yuv420p ^
            -movflags +faststart ^
            -map_metadata -1 ^
            -map_chapters -1 ^
            -c:a aac ^
            -b:a %AUDIO_BITRATE% ^
            "!outfile!"

        if errorlevel 1 (
            echo.
            echo [ERROR]
            echo.
        ) else (
            echo.
            echo [OK]
            echo.
        )

    )

)

echo.
echo ============================================================
echo FINALIZADO
echo ============================================================
echo.

pause
endlocal