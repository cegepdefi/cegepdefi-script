FROM alpine:latest

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

#Install SSH
LABEL maintainer="admin"
RUN apk add --update --no-cache openssh 
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN adduser -h /home/admin -s /bin/sh -D admin
RUN echo -n 'admin:admin123' | chpasswd
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22
COPY entrypoint.sh /

#Python twitchio
#Link: https://pypi.org/project/twitchio/
RUN python -m pip install -U twitchio

WORKDIR /home/admin

# ssh root@0.0.0.0
# ssh admin@0.0.0.0