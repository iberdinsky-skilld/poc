FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
  git unzip curl nano \
  libpng-dev libjpeg-dev libonig-dev libxml2-dev \
  python3.7 python3.7-venv python3.7-dev python3-pip \
  supervisor \
  && docker-php-ext-install pdo pdo_mysql gd

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY drupal/ /opt/drupal/
WORKDIR /opt/drupal
RUN composer install --no-interaction --no-dev \
    && cp -r web /var/www/html \
    && chown -R www-data:www-data /var/www/html

COPY django/ /opt/django-app/
WORKDIR /opt/django-app
RUN python3.7 -m venv venv \
    && ./venv/bin/pip install --upgrade pip \
    && ./venv/bin/pip install -r requirements.txt

RUN echo '[program:gunicorn]' > /etc/supervisor/conf.d/gunicorn.conf \
    && echo 'command=/opt/django-app/venv/bin/gunicorn mysite.wsgi:application --bind 127.0.0.1:8000' >> /etc/supervisor/conf.d/gunicorn.conf \
    && echo 'directory=/opt/django-app' >> /etc/supervisor/conf.d/gunicorn.conf \
    && echo 'autostart=true' >> /etc/supervisor/conf.d/gunicorn.conf \
    && echo 'autorestart=true' >> /etc/supervisor/conf.d/gunicorn.conf

RUN a2enmod rewrite proxy proxy_http

RUN echo '<VirtualHost *:80>' > /etc/apache2/sites-available/000-default.conf \
    && echo 'DocumentRoot /var/www/html' >> /etc/apache2/sites-available/000-default.conf \
    && echo 'ProxyPass "/django" "http://127.0.0.1:8000"' >> /etc/apache2/sites-available/000-default.conf \
    && echo 'ProxyPassReverse "/django" "http://127.0.0.1:8000"' >> /etc/apache2/sites-available/000-default.conf \
    && echo '</VirtualHost>' >> /etc/apache2/sites-available/000-default.conf

COPY docker/supervisord.conf /etc/supervisord.conf

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
