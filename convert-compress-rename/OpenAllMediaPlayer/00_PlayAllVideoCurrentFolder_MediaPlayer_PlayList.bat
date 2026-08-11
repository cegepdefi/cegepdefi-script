@echo off
set "list=00_playlist.m3u"
dir /b /on *.mp3 *.wma *.avi *.wmv *.mkv *.mp4 > "%list%"
start wmplayer "%list%"

REM ============================================================
REM How it works:
REM dir /b /on *.mp3 ... > "%list%": Lists all common audio and video files in the current directory,
REM sorted alphabetically, and saves them into a file named playlist.m3u.
REM start wmplayer "%list%": Launches Windows Media Player and loads the generated playlist.
REM ============================================================