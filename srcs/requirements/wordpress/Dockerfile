FROM alpine:3.19

RUN apk update && apk add bash curl \
php82-fpm \
php82-phar \
php82-mysqli \
php82-gd \
php82-mbstring \
php82-xml \
php82-zip \
php82-curl && \
adduser -S nginx &&	addgroup -S nginx && \
sed -i 's/;pid = run\/php-fpm82.pid/pid = run\/php-fpm82.pid/g' /etc/php82/php-fpm.d/www.conf && \
sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf && \
sed -i 's/user = nobody/user = nginx/g' /etc/php82/php-fpm.d/www.conf && \
sed -i 's/group = nobody/group = nginx/g' /etc/php82/php-fpm.d/www.conf && \
# sed -i 's/listen = \/run\/php\/php82-fpm.sock/listen = 9000/' /etc/php/82/fpm/pool.d/www.conf && \
mkdir -p /run/php && \
mkdir -p /var/www/html && \
chmod -R 755 /var/www/html

COPY wordpressinstall.sh /tmp/wordpressinstall.sh

ENTRYPOINT ["/bin/bash", "/tmp/wordpressinstall.sh"]

CMD ["php-fpm82", "-F"]
