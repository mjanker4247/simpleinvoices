#!/bin/bash
set -e

# Ensure tmp dirs exist and are writable by Apache
mkdir -p /var/www/html/tmp/cache /var/www/html/tmp/log /var/www/html/tmp/database_backups
chown -R www-data:www-data /var/www/html/tmp
chmod -R 775 /var/www/html/tmp

# Run composer install if vendor is missing (e.g. custom image without build-step install)
if [ -f "/var/www/html/composer.json" ] && [ ! -f "/var/www/html/vendor/autoload.php" ]; then
    echo "Running composer install..."
    (cd /var/www/html && composer install --no-interaction --no-dev --optimize-autoloader) || true
    chown -R www-data:www-data /var/www/html/vendor 2>/dev/null || true
fi

# When SI_DB_HOST is set, write a custom.config.php so the app connects to the right host
if [ -n "${SI_DB_HOST}" ]; then
    cp -f /var/www/html/config/config.php /var/www/html/config/custom.config.php
    sed -i "s/^database.params.host[[:space:]]*=.*/database.params.host                = ${SI_DB_HOST}/" /var/www/html/config/custom.config.php
    sed -i "s/^database.params.port[[:space:]]*=.*/database.params.port                = ${SI_DB_PORT:-3306}/" /var/www/html/config/custom.config.php
    sed -i "s/^database.params.username[[:space:]]*=.*/database.params.username            = ${SI_DB_USER:-root}/" /var/www/html/config/custom.config.php
    sed -i "s|^database.params.password[[:space:]]*=.*|database.params.password            = ${SI_DB_PASSWORD}|" /var/www/html/config/custom.config.php
    sed -i "s/^database.params.dbname[[:space:]]*=.*/database.params.dbname              = ${SI_DB_NAME:-simple_invoices}/" /var/www/html/config/custom.config.php

    # Wait for MySQL to be ready before starting Apache
    echo "Waiting for MySQL at ${SI_DB_HOST}:${SI_DB_PORT:-3306}..."
    MAX_TRIES=30
    TRIES=0
    until php -r "
        \$sock = @fsockopen('${SI_DB_HOST}', ${SI_DB_PORT:-3306}, \$e, \$msg, 2);
        if (\$sock) { fclose(\$sock); exit(0); }
        exit(1);
    " 2>/dev/null; do
        TRIES=$((TRIES + 1))
        if [ "$TRIES" -ge "$MAX_TRIES" ]; then
            echo "MySQL did not become ready in time. Proceeding anyway..."
            break
        fi
        echo "  MySQL not ready yet (attempt $TRIES/$MAX_TRIES), retrying in 2s..."
        sleep 2
    done
    echo "MySQL is ready."
fi

exec "$@"
