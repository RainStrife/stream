FROM ubuntu:16.04

EXPOSE 1935
EXPOSE 80
ENV DEBIAN_FRONTEND noninteractive
ENV PATH $PATH:/usr/local/nginx/sbin

RUN apt-get update -y && apt-get upgrade -y \
 && apt-get install -y apt-utils build-essential libpcre3 libpcre3-dev libssl-dev unzip wget ffmpeg && apt-get clean

RUN mkdir /nginx && mkdir /config && cd /nginx \
 && wget http://nginx.org/download/nginx-1.11.3.tar.gz && wget https://github.com/arut/nginx-rtmp-module/archive/v1.1.9.zip \
 && tar -zxvf nginx-1.11.3.tar.gz && unzip v1.1.9.zip && rm nginx-1.11.3.tar.gz v1.1.9.zip \
 && cd nginx-1.11.3 && ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-1.1.9 --conf-path=/config/nginx.conf --error-log-path=/logs/error.log --http-log-path=/logs/access.log\
 && make && make install

ADD nginx.conf /config/nginx.conf
VOLUME /source
VOLUME /logs







