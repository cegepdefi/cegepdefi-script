@ECHO ON
:: This CMD script Update Flutter Tarea
echo Logged time = %time% %date% >> C:\01-tareas\log.txt
TITLE Flutter Update Tarea
ECHO Please wait...
ECHO =========================
start cmd /k "flutter upgrade --force"
::timeout 10
PAUSE