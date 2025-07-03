#!/bin/bash

# chmod +x Samba.sh
# ./Samba.sh

# Variables
SHARE_DIR="/srv/samba/shared"
SMB_USER="<username>"  # Replace this with the desired username

echo "Updating and installing Samba..."
apt update && apt install -y samba

echo "Creating the shared directory..."
mkdir -p $SHARE_DIR
chmod 2770 $SHARE_DIR
groupadd sambashare 2>/dev/null
chown root:sambashare $SHARE_DIR

echo "Adding Samba user..."
smbpasswd -a $SMB_USER

echo "Configuring Samba..."
cat <<EOL >> /etc/samba/smb.conf

[Shared]
   path = $SHARE_DIR
   valid users = $SMB_USER
   read only = no
   browsable = yes
   writable = yes
   guest ok = no
   create mask = 0660
   directory mask = 0770
EOL

echo "Testing Samba configuration..."
testparm

echo "Restarting Samba services..."
systemctl restart smbd nmbd

echo "Allowing Samba traffic in the firewall..."
pve-firewall add rule -type in -interface net0 -action ACCEPT -macro smb

echo "Samba setup completed successfully."
echo "You can now access the shared directory using \\<Proxmox_IP>\Shared"
