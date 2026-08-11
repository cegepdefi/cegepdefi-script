@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM CONFIG
REM ============================================================

set "OUTPUT_DIR=sanitized_videos"

REM NVIDIA codec:
REM h264_nvenc
REM hevc_nvenc
set "V_CODEC=hevc_nvenc"

REM Calidad:
set "CQ=22"

REM Preset:
set "PRESET=p6"

REM Audio:
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
    REM Quitar la barra final
    set "FILEDIR=!FILEDIR:~0,-1!"

    REM Comprobar si FILEDIR contiene OUTPUT_DIR
    echo !FILEDIR! | find /I "%OUTPUT_DIR%" >nul
    if errorlevel 1 (
        rem Archivo NO está en sanitized_videos -> procesar

        set "infile=%%~fF"
        set "basename=%%~nF"

        set "outfile=%OUTPUT_DIR%\!basename!_sanitized.mp4"

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
            -cq %CQ% ^
            -b:v 0 ^
            -pix_fmt yuv420p ^
            -movflags +faststart ^
            -map_metadata -1 ^
            -map_chapters -1 ^
            -fflags +genpts ^
            -c:a aac ^
            -b:a %AUDIO_BITRATE% ^
            "%OUTPUT_DIR%\!basename!_sanitized.mp4"

        if errorlevel 1 (
            echo.
            echo [ERROR]
            echo.
        ) else (
            echo.
            echo [OK]
            echo.
        )

    ) else (
        rem Archivo está en sanitized_videos -> saltar
    )

)

echo.
echo ============================================================
echo FINALIZADO
echo ============================================================
echo.

pause
endlocal