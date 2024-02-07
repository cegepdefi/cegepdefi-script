# Use the official WordPress image as the base image
FROM wordpress:latest

# Install nano using apt-get
RUN apt-get install -y nano && rm -rf /var/lib/apt/lists/*

RUN chmod 0600 /var/www/html/wp-config.php

# Ya esta en plugin -> HMWP Ghost
# RUN rm /var/www/html/xmlrpc.php