#!/bin/bash

replace_or_append_env() {
    #echo "Replacing or appending $1=\"${2}\""
    sed -i "/^\$$1=/{h;s/=.*/=\"${2}\"/};\${x;/^\$/{s//$1=\"${2}\"/;H};x}" /conf/.env
}

inject_env () {
    if [ "${!1}" != '' ]; then
        replace_or_append_env "$1" "${!1}"
    fi
}

# app config
inject_env "APP_NAME"
inject_env "APP_ENV"
inject_env "APP_DEBUG"
inject_env "APP_URL"
inject_env "APP_FORCE_HTTPS"
inject_env "APP_DIR"

# db config
inject_env "DB_CONNECTION"
inject_env "DB_HOST"
inject_env "DB_PORT"
inject_env "DB_DATABASE"
inject_env "DB_USERNAME"
if [ "$DB_PASSWORD" != '' ]; then
    replace_or_append_env "DB_PASSWORD" "$DB_PASSWORD"
elif [ "$DB_PASSWORD_FILE" != '' ]; then
    value=$(<$DB_PASSWORD_FILE)
    replace_or_append_env "DB_PASSWORD" "$value"
fi
inject_env "DB_LOG_SQL"
inject_env "DB_LOG_SQL_EXPLAIN"

inject_env "TIMEZONE"
inject_env "ENABLE_TOKEN_AUTH"


inject_env "CACHE_DRIVER"
if [ "$QUEUE_CONNECTION" != '' ]; then
    replace_or_append_env "QUEUE_DRIVER" "$QUEUE_DRIVER"
fi

# session & security
inject_env "SESSION_DRIVER"
inject_env "SESSION_LIFETIME"
inject_env "SESSION_SECURE_COOKIE"

inject_env "SECURITY_HEADER_HSTS_ENABLE"
inject_env "SECURITY_HEADER_CSP_CONNECT_SRC"
inject_env "SECURITY_HEADER_SCRIPT_SRC_ALLOW"

# redis config
inject_env "REDIS_SCHEME"
inject_env "REDIS_PATH"
inject_env "REDIS_HOST"
inject_env "REDIS_PORT"
if [ "$REDIS_PASSWORD" != '' ]; then
    replace_or_append_env "REDIS_PASSWORD" "$REDIS_PASSWORD"
elif [ "$REDIS_PASSWORD_FILE" != '' ]; then
    value=$(<$REDIS_PASSWORD_FILE)
    replace_or_append_env "REDIS_PASSWORD" "$value"
fi

# mail config
inject_env "MAIL_DRIVER"
inject_env "MAIL_HOST"
inject_env "MAIL_PORT"
inject_env "MAIL_USERNAME"
if [ "$MAIL_PASSWORD" != '' ]; then
    replace_or_append_env "MAIL_PASSWORD" "$MAIL_PASSWORD"
elif [ "$MAIL_PASSWORD_FILE" != '' ]; then
    value=$(<$MAIL_PASSWORD_FILE)
    replace_or_append_env "MAIL_PASSWOD" "$value"
fi
inject_env "MAIL_ENCRYPTION"
inject_env "MAIL_FROM_NAME"
inject_env "MAIL_FROM_ADDRESS"

inject_env "TRUSTED_PROXIES"
inject_env "SANCTUM_STATEFUL_DOMAINS"
inject_env "SESSION_DOMAIN"

# timezone config
if [ "$PHP_TZ" != '' ]; then
    sed -i "s|;*date.timezone =.*|date.timezone = ${PHP_TZ}|i" /etc/php/8.2/cli/php.ini
    sed -i "s|;*date.timezone =.*|date.timezone = ${PHP_TZ}|i" /etc/php/8.2/fpm/php.ini
fi
