FROM centos:7.6.1810

RUN yum install -y libtranslit-icu.x86_64 libicu-devel.x86_64 libicu.x86_64 icu.x86_64 wget postgresql-devel.x86_64 bzip2 libxml2-devel.x86_64 openssl-devel.x86_64 curl-devel && \
    yum groupinstall -y "Development Tools" && \
    wget https://www.php.net/distributions/php-7.3.7.tar.bz2 && \
    tar -xvjf php-7.3.7.tar.bz2 && \
    cd php-7.3.7 && \
    ./configure \
         --enable-intl \
         --with-pdo-pgsql \
         --with-pgsql \
         --with-config-file-scan-dir=/etc/php.d \
         --enable-opcache \
         --enable-mysqlnd \
         --with-pdo-mysql \
         --with-pdo-mysql=mysqlnd \
         --enable-bcmath \
         --enable-fpm \
         --enable-mbstring \
         --enable-phpdbg \
         --enable-shmop \
         --enable-sockets \
         --enable-sysvmsg \
         --enable-sysvsem \
         --enable-sysvshm \
         --with-curl \
         --with-pear \
         --with-openssl \
         --enable-pcntl && \
    make && \
    make install

#RUN yum install -y net-tools.x86_64
COPY php.ini /usr/local/lib/php.ini
COPY www.conf /usr/local/etc/php-fpm.d/www.conf
COPY php-fpm.conf /usr/local/etc/php-fpm.conf

RUN wget https://xdebug.org/files/xdebug-2.7.2.tgz && \
    tar -xvzf xdebug-2.7.2.tgz && \
    cd xdebug-2.7.2 && \
    phpize && \
    ./configure && \
    make clean && \
    make && \
    make install

COPY xdebug.ini /etc/php.d/xdebug.ini

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/bin --filename=composer

#RUN yum install -y openssl

EXPOSE 9000

CMD php-fpm