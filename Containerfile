FROM quay.io/centos-bootc/centos-bootc:stream10

RUN dnf -y install nginx && dnf clean all

COPY app/index.html /usr/share/nginx/html/index.html
COPY app/nginx.conf /etc/nginx/nginx.conf

RUN systemctl enable nginx.service

EXPOSE 8080
