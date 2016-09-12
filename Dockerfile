FROM ubuntu:16.04

EXPOSE 1935
EXPOSE 80
VOLUME /logs
ENV DEBIAN_FRONTEND noninteractive
ENV PATH $PATH:/usr/local/nginx/sbin

RUN apt-get update -y && apt-get upgrade -y \
 && apt-get install -y apt-utils build-essential libpcre3 libpcre3-dev libssl-dev unzip wget software-properties-common python-software-properties \
 && add-apt-repository -y "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse" \
 && add-apt-repository -y "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse" \
 && apt-get update -y && apt-get install -y libfdk-aac-dev

RUN apt-get install -y yasm libx264-dev git && apt-get clean

RUN mkdir /src && mkdir /apps && cd /src && git clone git://git.libav.org/libav.git . && ./configure \
 --prefix=/apps \
 --enable-nonfree \
 --enable-gpl \
 --disable-shared \
 --enable-static \
 --enable-libx264 \
 --enable-libfdk-aac && make && make install \
 && rm -rf /src

RUN mkdir /nginx && mkdir /config && mkdir /static && mkdir /data && cd /nginx \
 && wget http://nginx.org/download/nginx-1.11.3.tar.gz && wget https://github.com/arut/nginx-rtmp-module/archive/v1.1.9.zip \
 && tar -zxvf nginx-1.11.3.tar.gz && unzip v1.1.9.zip && rm nginx-1.11.3.tar.gz v1.1.9.zip \
 && cd nginx-1.11.3 && ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-1.1.9 --conf-path=/config/nginx.conf --error-log-path=/logs/error.log --http-log-path=/logs/access.log\
 && make && make install

ADD nginx.conf /config/nginx.conf
CMD "nginx"







