FROM php:8.1-apache

# Install dependencies (if needed)
RUN apt-get update && apt-get install -y \
    libzip-dev zlib1g-dev libgsoap-dev libxml2-dev libpng-dev \
    libicu-dev
# Install the mysqli extension
RUN docker-php-ext-install mysqli zip soap intl gd \
    && docker-php-ext-enable mysqli zip soap intl gd
