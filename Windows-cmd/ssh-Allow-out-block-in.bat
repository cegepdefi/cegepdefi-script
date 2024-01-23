@echo off
rem Obtener la dirección IP del ordenador B
set /p ipb="Introduce la dirección IP del ordenador B: "

rem Crear una regla de firewall que permita el tráfico saliente por el puerto 22 (TCP) solo hacia el ordenador B
netsh advfirewall firewall add rule name="Permitir SSH saliente TCP a B" dir=out action=allow protocol=TCP remoteport=22 remoteip=%ipb%

rem Crear una regla de firewall que permita el tráfico saliente por el puerto 23 (UDP) solo hacia el ordenador B
netsh advfirewall firewall add rule name="Permitir SSH saliente UDP a B" dir=out action=allow protocol=UDP remoteport=23 remoteip=%ipb%

rem Crear una regla de firewall que bloquee el tráfico entrante por el puerto 22 (TCP) desde cualquier ordenador
netsh advfirewall firewall add rule name="Bloquear SSH entrante TCP desde cualquier" dir=in action=block protocol=TCP localport=22

rem Crear una regla de firewall que bloquee el tráfico entrante por el puerto 23 (UDP) desde cualquier ordenador
netsh advfirewall firewall add rule name="Bloquear SSH entrante UDP desde cualquier" dir=in action=block protocol=UDP localport=23

rem Mostrar las reglas de firewall creadas
netsh advfirewall firewall show rule name=all | findstr /i "SSH"
