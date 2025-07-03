# LINK: https://www.cyberciti.biz/faq/howto-set-date-time-from-linux-command-prompt/

# Setup date
date

# Show
# Type the following hwclock command to read the Hardware Clock and display the time on screen:
hwclock -r

# OR
hwclock --show

## OR ##
sudo hwclock --show --verbose

# OR show it in Coordinated Universal time (UTC):
# Sample outputs:
# 2019-01-21 01:30:50.608410+05:30
hwclock --show --utc


# === Linux Set Date Command Example ===
# Use the following syntax to set new data and time:
date --set="STRING"

# For example, set new data to 2 Oct 2006 18:00:00, type the following command as root user:
date -s "2 OCT 2006 18:00:00"

# or
date --set="2 OCT 2006 18:00:00"

# Linux Set Time Examples
# To set time use the following syntax:
date +%T -s "10:13:13"

# Use %p locale’s equivalent of either AM or PM, enter:
date +"%T%p" -s "6:10:30AM"
date +"%T%p" -s "12:10:30PM"


# === Hardware Clock ===
# Use the following syntax to set the hardware clock from the system clock,
# and update the timestamps in /etc/adjtime file. For example:
hwclock --systohc
# OR
hwclock -w
# Want to set the System Clock from the Hardware Clock? Try:
hwclock --hctosys
# OR
hwclock -s


# =====
# How do I know I’m using systemd or sys v init or OpenRC as an init system in Linux?

# Run the type command or command command to see what it says. For example:
type systemd

# Do you get any outputs? Here is what Ubuntu 20.04 LTS returned:
systemd is hashed (/usr/bin/systemd)

# In other words, I’m using systemd as init. The following error from Alpine Linux version 3.18 indicates that I’m not using systemd-based Linux distro for init:
-bash: type: systemd: not found


# == Using timedatectl command display the current date and time ==
# Type the following timedatectl command on systemd-based Linux distros:
timedatectl


# == How do I change the current date using the timedatectl command? ==
# To change the current date, type the following command as root user:
timedatectl set-time YYYY-MM-DD
# OR
sudo timedatectl set-time YYYY-MM-DD
# For example set the current date to 2015-12-01 (1st, Dec, 2015):
timedatectl set-time '2015-12-01'
timedatectl
# Sample outputs:
#       Local time: Tue 2015-12-01 00:00:03 EST
#   Universal time: Tue 2015-12-01 05:00:03 UTC
#         RTC time: Tue 2015-12-01 05:00:03
#        Time zone: America/New_York (EST, -0500)
#      NTP enabled: no
# NTP synchronized: no
#  RTC in local TZ: no
#       DST active: no
#  Last DST change: DST ended at
#                   Sun 2015-11-01 01:59:59 EDT
#                   Sun 2015-11-01 01:00:00 EST
#  Next DST change: DST begins (the clock jumps one hour forward) at
#                   Sun 2016-03-13 01:59:59 EST
#                   Sun 2016-03-13 03:00:00 EDT


# To change both the date and time, use the following syntax:
timedatectl set-time YYYY-MM-DD HH:MM:SS

