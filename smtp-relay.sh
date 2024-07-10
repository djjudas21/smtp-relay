#!/bin/sh

SMTP_RELAY_HOST=${SMTP_RELAY_HOST?Missing env var SMTP_RELAY_HOST}
SMTP_RELAY_MYHOSTNAME=${SMTP_RELAY_MYHOSTNAME?Missing env var SMTP_RELAY_MYHOSTNAME}
SMTP_RELAY_USERNAME=${SMTP_RELAY_USERNAME?Missing env var SMTP_RELAY_USERNAME}
SMTP_RELAY_PASSWORD=${SMTP_RELAY_PASSWORD?Missing env var SMTP_RELAY_PASSWORD}
SMTP_RELAY_MYNETWORKS=${SMTP_RELAY_MYNETWORKS?Missing env var SMTP_RELAY_MYNETWORKS}
SMTP_RELAY_WRAPPERMODE=${SMTP_RELAY_WRAPPERMODE?Missing env var SMTP_RELAY_WRAPPERMODE}
SMTP_TLS_SECURITY_LEVEL=${SMTP_TLS_SECURITY_LEVEL?Missing env var SMTP_TLS_SECURITY_LEVEL}


# handle sasl
echo "${SMTP_RELAY_HOST} ${SMTP_RELAY_USERNAME}:${SMTP_RELAY_PASSWORD}" > /etc/postfix/sasl_passwd || exit 1
postmap /etc/postfix/sasl_passwd || exit 1
rm /etc/postfix/sasl_passwd || exit 1

postconf 'smtp_sasl_auth_enable = yes' || exit 1
postconf 'smtp_sasl_password_maps = lmdb:/etc/postfix/sasl_passwd' || exit 1
postconf 'smtp_sasl_security_options =' || exit 1
postconf "smtp_use_tls = ${SMTP_USE_TLS:-no}" || exit 1

# These are required.
postconf "relayhost = ${SMTP_RELAY_HOST}" || exit 1
postconf "myhostname = ${SMTP_RELAY_MYHOSTNAME}" || exit 1
postconf "mynetworks = ${SMTP_RELAY_MYNETWORKS}" || exit 1
postconf "smtp_tls_wrappermode = ${SMTP_RELAY_WRAPPERMODE}" || exit 1
postconf "smtp_tls_security_level = ${SMTP_TLS_SECURITY_LEVEL}" || exit 1

# http://www.postfix.org/COMPATIBILITY_README.html#smtputf8_enable
postconf 'smtputf8_enable = no' || exit 1

# This makes sure the message id is set. If this is set to no dkim=fail will happen.
postconf 'always_add_missing_headers = yes' || exit 1

# Log to stdout
postconf 'maillog_file = /dev/stdout' || exit 1

# Start postfix
postfix start-fg
