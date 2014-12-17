FROM ubuntu:14.04

MAINTAINER Ailove <d.sokolov@ailove.ru>

# keep upstart quiet
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl
ENV DEBIAN_FRONTEND noninteractive

# get up to date
RUN apt-get update --fix-missing

# installs
RUN apt-get install -y build-essential git
RUN apt-get install -y python python-dev python-setuptools
RUN apt-get install -y nginx supervisor
RUN apt-get install -y libpq-dev
RUN apt-get install -y libjpeg-dev openjpeg-tools zlib1g-dev libfreetype6-dev \
                       liblcms1-dev libpng12-dev libxml2-dev libxslt1-dev \
                       gettext libssl-dev

RUN easy_install pip
RUN pip install supervisor
RUN pip install supervisor-stdout
RUN pip install uwsgi

# nginx config
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# create env
ADD ./docker-conf /docker-conf
RUN ln -s /docker-conf/supervisord.conf /etc/supervisord.conf
RUN rm /etc/nginx/sites-available/default && ln -sf /docker-conf/nginx.conf /etc/nginx/sites-enabled/default
# RUN mkdir -p /var/www/project/{cache,conf,data,tmp,logs}
RUN mkdir -p /var/www/project/cache
RUN mkdir -p /var/www/project/conf
RUN mkdir -p /var/www/project/data
RUN mkdir -p /var/www/project/tmp
RUN mkdir -p /var/www/project/logs
RUN chown -R www-data /var/www/project
RUN chmod +x /docker-conf/run.sh

# linked logs
RUN ln -sf /var/log/nginx/access.log /var/www/project/logs/access.log
RUN ln -sf /var/log/nginx/error.log /var/www/project/logs/error.log

# run
CMD /docker-conf/run.sh

# expose ports
EXPOSE 80
EXPOSE 443
