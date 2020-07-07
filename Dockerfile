#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
FROM php:7-alpine

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

# Configure apt and install packages
    #
    # install git iproute2, procps, lsb-release (useful for CLI installs)
    RUN apk add git
    # less iproute2 procps iproute2 lsb-release \
    #
    # Install extensions
    RUN install-php-extensions zip xdebug
    #
    # Install xdebug
    # && yes | pecl install xdebug \
    # && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    # && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    # && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    #
    # Install Composer
    RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require hirak/prestissimo \
    && composer clear-cache
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    RUN addgroup --gid 1000 --system dockeruser \
    && adduser --system --uid 1000 --ingroup dockeruser dockeruser
