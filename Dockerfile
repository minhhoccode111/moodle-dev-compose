FROM moodlehq/moodle-php-apache:7.2

RUN echo "upload_max_filesize = 2G\npost_max_size = 2G\nmax_execution_time = 3600\nmemory_limit = 2048M" > /usr/local/etc/php/conf.d/uploads.ini
