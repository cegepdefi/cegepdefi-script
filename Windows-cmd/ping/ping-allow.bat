@echo off
netsh advFirewall Firewall add rule name="PING IPv4" protocol=icmpv4:8,any dir=in action=allow
netsh advFirewall Firewall add rule name="PING IPv6" protocol=icmpv6:8,any dir=in action=allow
echo Ping has been blocked in the firewall.
pause
