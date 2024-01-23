@echo off
rem Crear una regla de firewall que bloquee el tráfico entrante por el puerto 22 (TCP)
netsh advfirewall firewall add rule name="Bloquear SSH entrante TCP" dir=in action=block protocol=TCP localport=22

rem Crear una regla de firewall que bloquee el tráfico entrante por el puerto 23 (UDP)
netsh advfirewall firewall add rule name="Bloquear SSH entrante UDP" dir=in action=block protocol=UDP localport=23

rem Crear una regla de firewall que bloquee el tráfico saliente por el puerto 22 (TCP)
netsh advfirewall firewall add rule name="Bloquear SSH saliente TCP" dir=out action=block protocol=TCP remoteport=22

rem Crear una regla de firewall que bloquee el tráfico saliente por el puerto 23 (UDP)
netsh advfirewall firewall add rule name="Bloquear SSH saliente UDP" dir=out action=block protocol=UDP remoteport=23

rem Mostrar las reglas de firewall creadas
netsh advfirewall firewall show rule name=all | findstr /i "SSH"
