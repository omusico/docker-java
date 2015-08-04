FROM fedora:21
MAINTAINER omusico@omusico.net

RUN  yum install -y wget tar make gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libpng libpng-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel gd-devel openssl-devel curl bison libcurl-devel gmp-devel libmcrypt-devel readline-devel libxslt-devel httpd-devel

ENV PHP_VERSION 7.0.0beta1

RUN curl -SL "https://downloads.php.net/~ab/php-$PHP_VERSION.tar.bz2" -o php.tar.bz2 \
        && set -x \
        && mkdir -p /usr/src/php \
		&& tar -xof php.tar.bz2 -C /usr/src/php --strip-components=1 \
		&& rm php.tar.bz2* \
		&& cd /usr/src/php \
		&& ./buildconf --force \
		&& ./configure \
						--prefix=/usr/local/php \
						--with-config-file-path=/usr/local/php/etc \
						--with-config-file-scan-dir=/usr/local/php/etc/conf.d \
						--enable-fpm \
						--enable-soap \
						--with-openssl \
						--with-mcrypt \
						--with-pcre-regex \
						--with-sqlite3 \
						--with-zlib \
						--enable-bcmath \
						--with-iconv \
						--with-bz2 \
						--enable-calendar \
						--with-curl \
						--with-gd \
						--with-openssl-dir \
						--with-jpeg-dir \
						--with-png-dir \
						--with-freetype-dir \
						--with-gettext \
						--with-gmp \
						--with-mhash \
						--enable-json \
						--enable-mbstring \
						--disable-mbregex \
						--disable-mbregex-backtrack \
						--with-libmbfl \
						--with-onig \
						--enable-pdo \
						--with-pdo-mysql \
						--with-zlib-dir \
						--with-pdo-sqlite \
						--with-readline \
						--enable-session \
						--enable-shmop \
						--enable-simplexml \
						--enable-sockets \
						--enable-sysvmsg \
						--enable-sysvsem \
						--enable-sysvshm \
						--enable-wddx \
						--with-libxml-dir \
						--with-xsl \
						--enable-zip \
						--enable-mysqlnd-compression-support \
						--with-pear \
						--with-mysqli \
						--disable-fileinfo \
	&&make -j"$(nproc)" \
	&&make install \
	&&yum remove -y libjpeg-devel libpng-devel freetype-devel libpng-devel libxml2-devel zlib-devel glibc-devel glib2-devel bzip2-devel gd-devel openssl-devel libcurl-devel gmp-devel libmcrypt-devel readline-devel libxslt-devel httpd-devel
	&&make clean \
	&&yum clean all 

RUN  cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf

COPY httpd-php.conf /etc/httpd/conf.d/
COPY www.conf  /usr/local/php/etc/php-fpm.d/

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]