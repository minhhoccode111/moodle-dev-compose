FROM moodlehq/moodle-php-apache:7.2

# RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list \
#     && sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list \
#     && sed -i '/stretch-updates/d' /etc/apt/sources.list \
#     && sed -i '/buster-updates/d' /etc/apt/sources.list
#
# RUN apt update && apt install -y \
#     gcc make autoconf pkg-config curl \
#     && curl -L -o xdebug-2.9.8.tgz https://pecl.php.net/get/xdebug-2.9.8 \
#     && tar -xvzf xdebug-2.9.8.tgz \
#     && cd xdebug-2.9.8 \
#     && phpize \
#     && ./configure --enable-xdebug \
#     && make && make install \
#     && echo "zend_extension=xdebug.so\n\
#     xdebug.remote_enable=1\n\
#     xdebug.remote_autostart=1\n\
#     xdebug.remote_connect_back=0\n\
#     xdebug.remote_host=172.17.0.1\n\
#     xdebug.remote_port=9000\n\
#     xdebug.idekey=VSCODE\n\
#     xdebug.remote_log=/tmp/xdebug.log" \
#     > /usr/local/etc/php/conf.d/xdebug.ini \
#     && rm -rf xdebug-2.9.8*

RUN echo "upload_max_filesize = 1G\\npost_max_size = 1G" > /usr/local/etc/php/conf.d/uploads.ini

# replace line (this line work on my linux ubuntu with docker compose)
# xdebug.remote_host=172.17.0.1\n\
# with
# xdebug.remote_host=host.docker.internal\n\
# to work on macOS and Windows
