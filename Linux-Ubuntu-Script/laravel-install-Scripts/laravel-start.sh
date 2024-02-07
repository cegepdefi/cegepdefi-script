#!/bin/bash

# yes | sudo sh laravel-start.sh

# *A) Executar el script en primer plano:
# sudo bash ./laravel-start.sh

# *B) Executar el script en segundo plano:
# ./laravel-start.sh &

# *C) You can use the nohup command to run your script in
# *the background even after you log out. Here’s how you can use it:
# sudo nohup ./laravel-start.sh &

echo "--> comando: php artisan serve"
cd ./myapp
php artisan serve --host=0.0.0.0

# ================ [ Executar script on BOOT ] ======================
# *1) Create a new file with .service extension in /etc/systemd/system/ directory using your preferred text editor. For example:
# sudo nano /etc/systemd/system/laravelStart.service

# *2) Add the following lines to the file:
# ------------
# [Unit]
# Description=Laravel Service
# After=network.target

# [Service]
# ExecStart=/home/admin/Laravel-Doc/myapp/laravel-start.sh

# [Install]
# WantedBy=multi-user.target
# ------------


# ------------
# [Unit]
# Description=Laravel App

# [Service]
# ExecStart=/usr/bin/php /home/admin/Laravel-Doc/myapp artisan serve --host=0.0.0.0 --port=8000
# Restart=always
# User=root

# [Install]
# WantedBy=multi-user.target
# ------------


# *3) Save and close the file.
# *4) Reload Systemd daemon:
# sudo systemctl daemon-reload

# *5) Enable your service:
# sudo systemctl enable laravelStart.service

# *6) Reboot your system to test if it works:
# sudo reboot

# sudo systemctl status laravelStart.service
# sudo systemctl start laravelStart.service
# sudo systemctl stop laravelStart.service
# sudo systemctl restart laravelStart.service
# ==================================================================