# Use an official Apache runtime as a parent image
FROM httpd:2.4

# Optionally, set environment variables
# ENV APACHE_DOCUMENT_ROOT /path/to/your/document/root

# Optionally, copy your website files into the container
COPY ./index.html /usr/local/apache2/htdocs/

# If you have custom Apache configuration, copy it into the container
# COPY ./path/to/your/httpd.conf /usr/local/apache2/conf/httpd.conf

# If you need to install additional software or dependencies, you can do it here

# Expose port 80 for web traffic
# EXPOSE 80

# Define the command to start Apache (this is the default command in the parent image)
CMD ["httpd-foreground"]

# Errores
# 1) no se puede hacer update de apache despues de crear imagen y contenedor
# 2) vulnerabilidad de header version x.x?
# 3) 

# === Home Page  [domain.com/] ====
# 1) Create image from Dockerfile:
# docker build -t apache-home-image .
# 2) Create containe from the image from the Dockefile:
# docker run -p 40082:80 --name my-apache-home-container apache-home-image

# === Test Page [domain.com/test] ====
# 1) Create image from Dockerfile:
# docker build -t apache-test-image .
# 2) Create containe from the image from the Dockefile:
# docker run -p 40083:80 --name my-apache-test-container apache-test-image
