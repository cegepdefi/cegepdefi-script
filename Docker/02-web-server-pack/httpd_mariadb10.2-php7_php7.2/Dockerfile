FROM centos

ARG RAM_AMOUNT
ENV ram=${RAM_AMOUNT}

WORKDIR /

RUN yum check-update
RUN yum update -y
RUN yum amazon-linux-extras install -y lamp-mariadb10.2-php7 php7.2
RUN yum install -y httpd mariadb-server
RUN systemctl start httpd
RUN systemctl enable httpd
RUN systemctl is-enabled httpd
RUN echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
RUN systemctl start mariadb
CMD  [ "/usr/sbin/httpd", "-D", "FOREGROUND"]