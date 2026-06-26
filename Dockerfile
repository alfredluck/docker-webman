# https://hub.docker.com/_/php/tags
ARG PHP_CLI_VERSION=8.2-cli-alpine
# https://hub.docker.com/r/mlocati/php-extension-installer
ARG PHP_EXTENSION_INSTALL_VERSION=latest
# https://hub.docker.com/r/composer/composer
ARG COMPOSER_VERSION=latest

# install-php-extensions
FROM mlocati/php-extension-installer:$PHP_EXTENSION_INSTALL_VERSION AS php-extension-installer
# composer
FROM composer/composer:$COMPOSER_VERSION AS composer

# 开始构建
FROM php:$PHP_CLI_VERSION

# 系统依赖安装
COPY --from=php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer /usr/bin/composer /usr/bin/composer

# PHP 扩展安装
# https://github.com/mlocati/docker-php-extension-installer#supported-php-extensions
RUN install-php-extensions \
    bcmath \
    event \
    gd \
    mysqli \
    pdo_mysql \
    opcache \
    pcntl \
    redis \
    sockets \
    zip

# 设置配置文件
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY config/php.ini "$PHP_INI_DIR/conf.d/app.ini"

# 设置项目目录
RUN mkdir -p /www
WORKDIR /www
