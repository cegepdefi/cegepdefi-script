FROM ubuntu

ARG RAM_AMOUNT

ENV ram=${RAM_AMOUNT}

WORKDIR /server

RUN apt update -y
RUN apt install nano -y
RUN apt install wget -y
RUN apt install openjdk-17-jdk openjdk-17-jre -y

CMD echo "El servidor de Minecraft está comenzando\n" && java -Xmx${ram} -jar paper-1.19.1-104.jar