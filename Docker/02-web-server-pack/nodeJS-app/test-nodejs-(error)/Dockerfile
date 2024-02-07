FROM node:14

# Create and set the working directory in the container
WORKDIR /app

# Copy project to the working directory
COPY ./app ./app

# update
# RUN apt update

# Install nodejs
# RUN apt-get install -y nodejs

# Install app dependencies
RUN npm install

# RUN npm init --yes
# RUN npm install express

# Print the version of npm
# RUN nodejs -v
# RUN npm -v

# 
EXPOSE 3000

# Command to start your Express app
CMD ["node", "app.js"]

# =======
# 1) Create image from Dockerfile:
# docker build -t test-nodejs .
# 2) Create containe from the image from the Dockefile:
# docker run -p 3001:3000 --name test-nodejs-container test-nodejs
# =======

# Utiliza un Contenedor Interactivo:
# docker run -it --entrypoint=/bin/bash nodejs-app
# npm --version