FROM php:5.6-apache
MAINTAINER Scott van Brug scottvanbrug@gmail.com

RUN apt-get update -q && apt-get install -yq \
  git \
  graphviz \
  libssl-dev \
  libmcrypt-dev \
  && until rm -rf /var/lib/apt/lists; do sleep 1; done

RUN pecl install xhprof-beta

RUN docker-php-ext-enable xhprof

RUN cd /var/www \
  && git clone https://github.com/phacility/xhprof.git

RUN chown -R www-data:www-data /var/www/xhprof/xhprof_html/

COPY conf/timezone.ini /usr/local/etc/php/conf.d/timezone.ini
COPY conf/xhprof.ini /usr/local/etc/php/conf.d/php.ini

COPY conf/xhprof.conf /etc/apache2/sites-available/xhprof.conf
RUN a2ensite xhprof.conf && a2enmod rewrite

RUN mkdir /srv/profiles
VOLUME /srv/profiles

EXPOSE 80
