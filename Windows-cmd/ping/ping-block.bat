@echo off
netsh advFirewall Firewall add rule name="PING IPv4" protocol=icmpv4:8,any dir=in action=block
netsh advFirewall Firewall add rule name="PING IPv6" protocol=icmpv6:8,any dir=in action=block
netsh advFirewall Firewall add rule name="PING IPv4 Out" protocol=icmpv4:8,any dir=out action=block
netsh advFirewall Firewall add rule name="PING IPv6 Out" protocol=icmpv6:8,any dir=out action=block
echo Ping has been blocked in and out the firewall.
pause
