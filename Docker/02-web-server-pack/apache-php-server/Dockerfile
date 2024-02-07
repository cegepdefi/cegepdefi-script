FROM debian

ARG RAM_AMOUNT

ENV ram=${RAM_AMOUNT}

WORKDIR /var/www/

RUN apt update -y
RUN apt install nano -y
RUN apt install wget -y
RUN apt install apache2 -y