FROM ubuntu:latest

# install
RUN apt-get update -y
RUN apt-get install sudo -y
RUN apt-get install nano -y
RUN apt-get install wget -y
# RUN apt install -y curl

# SSH
RUN apt-get install openssh-server -y
RUN systemctl enable ssh
RUN systemctl start ssh

# create user for sudo group
RUN useradd -rm -d /home/admin -s /bin/bash -g root -G sudo -u 1001 admin --no-log-init
RUN echo 'admin:admin123' | chpasswd
#RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER admin
WORKDIR /home/admin

# dont power off
CMD /bin/bash

#ENTRYPOINT ["tail"]
#CMD ["-f","/dev/null"]

# ou docker run -t -i image