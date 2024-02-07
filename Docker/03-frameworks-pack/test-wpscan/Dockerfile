# Use a base image with Ruby and common dependencies
FROM ruby:latest
# FROM ubuntu:latest

# Install required packages
RUN apt-get update
# RUN apt-get install -y ruby-full
# RUN gem install wpscan
RUN apt-get install -y git
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y libssl-dev

# Clone WPScan from GitHub
RUN git clone --depth 1 https://github.com/wpscanteam/wpscan.git

# Change working directory to WPScan
WORKDIR /wpscan

# Install WPScan dependencies
RUN gem install bundler && bundle install --without test

# Create a non-root user
# RUN groupadd -g 1000 myusergroup && useradd -u 1000 -g myusergroup -m myuser

# Set the default user
# USER myuser

# Define the default command to run WPScan
CMD ["./wpscan.rb"]


# Errores
# 1) No se puede hacer apt si el FROM es ruby
# 2) no se puede instalar apt install wpscan porque no existe
# 3) los comandos de ruby como [gem] no funcionan
# 4) si quito el usuario root y uso otro usuario como "myuser" no se podra usar comandos de root como apt update o install.

# Limpiar
# docker container prune
# docker image prune
# docker system prune

# Build the Docker Image:
# docker build -t wpscan-docker .

# Run WPScan in a Docker Container:
# After building the image, you can run WPScan in a Docker container as follows:
# docker run --rm -it wpscan-docker --url http://example.com
# 
# The --rm option removes the container after it's done running
# 
# docker run --rm -it wpscan-docker:latest wpscan --url http://example.com
# 
# Utiliza un Contenedor Interactivo:
# docker run -it --entrypoint=/bin/bash wpscan-docker
# wpscan --version

