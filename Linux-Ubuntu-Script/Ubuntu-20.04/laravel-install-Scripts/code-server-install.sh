#!/bin/bash

# Accede a la interfaz web de code-server desde tu navegador usando la URL: ip:/adminer

# Para executar y que responda "YES" a cualquier pregunta usar:
# yes | sudo sh code-server-install.sh

# Link:
# https://www.digitalocean.com/community/tutorials/how-to-set-up-the-code-server-cloud-ide-platform-on-ubuntu-18-04


# ======== *** Prerequisites *** ========

# A server running Ubuntu 18.04 with at least 2GB RAM,
# root access, and a sudo, non-root account. You can set
# this up by following this initial server setup guide.

# Nginx installed on your server. For a guide on how to do this,
# complete Steps 1 to 4 of How To Install Nginx on Ubuntu 18.04.

# A fully registered domain name to host code-server, pointed to your server.
# This tutorial will use code-server.your-domain throughout. You can purchase
# a domain name on Namecheap, get one for free on Freenom, or use the domain
# registrar of your choice. For DigitalOcean, you can follow this introduction
# to DigitalOcean DNS for details on how to add them.
# ===========================================


# In this section, you will set up code-server on your server.
# This entails downloading the latest version and creating a
# systemd service that will keep code-server always running in
# the background. You’ll also specify a restart policy for the service,
# so that code-server stays available after possible crashes or reboots.

# You’ll store all data pertaining to code-server in a folder
# named ~/code-server. Create it by running the following command:
mkdir code-server

# Navigate to it:
cd code-server

# You’ll need to head over to the Github releases page of code-server
# and pick the latest Linux build (the file will contain ‘linux’ in its name).
# At the time of writing, the latest version was 3.2.0. Download it using wget by running the following command:
wget https://github.com/cdr/code-server/releases/download/3.2.0/code-server-3.2.0-linux-x86_64.tar.gz

# Then, unpack the archive by running:
tar -xzvf code-server-3.2.0-linux-x86_64.tar.gz

# You’ll get a folder named exactly as the original file you downloaded,
# which contains the code-server source code. Copy it to /usr/lib/code-server
# so you’ll be able to access it system wide by running the following command:
sudo cp -r code-server-3.2.0-linux-x86_64 /usr/lib/code-server

# Then, create a symbolic link at /usr/bin/code-server, pointing to the code-server executable:
sudo ln -s /usr/lib/code-server/code-server /usr/bin/code-server

# Next, create a folder for code-server, where it will store user data:
sudo mkdir /var/lib/code-server


# Now that you’ve downloaded code-server and made it available system-wide,
# you will create a systemd service to keep code-server running in the background at all times.

# You’ll store the service configuration in a file named code-server.service,
# in the /lib/systemd/system directory, where systemd stores its services. Create it using your text editor:
# sudo nano /lib/systemd/system/code-server.service

cd ..
sudo cp -f code-server.service /lib/systemd/system/code-server.service

# =============================================
# [Unit]
# Description=code-server
# After=nginx.service

# [Service]
# Type=simple
# Environment=PASSWORD=your_password
# ExecStart=/usr/bin/code-server --bind-addr 127.0.0.1:8080 --user-data-dir /var/lib/code-server --auth password
# Restart=always

# [Install]
# WantedBy=multi-user.target
# =============================================

sudo systemctl start code-server
sudo systemctl restart code-server
sudo systemctl enable code-server
# sudo systemctl status code-server
