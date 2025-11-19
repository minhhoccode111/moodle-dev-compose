FROM moodlehq/moodle-php-apache:8.3

# Enable and configure Xdebug
RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20230831/xdebug.so\n\
xdebug.mode=debug\n\
xdebug.start_with_request=yes\n\
xdebug.client_host=host.docker.internal\n\
xdebug.client_port=9003\n\
xdebug.idekey=VSCODE\n\
xdebug.log=/tmp/xdebug.log" \
    > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN echo "upload_max_filesize = 1G\npost_max_size = 1G" > /usr/local/etc/php/conf.d/uploads.ini

# replace line (this line work on my linux ubuntu with docker compose)
# xdebug.remote_host=172.17.0.1\n\
# with
# xdebug.remote_host=host.docker.internal\n\
# to work on macOS and Windows
