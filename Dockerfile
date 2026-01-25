FROM alpine:3.20
LABEL maintainer "Jonathan Gazeley"

RUN apk add --no-cache postfix \
    && /usr/bin/newaliases

COPY smtp-relay.sh /

COPY master.cf /etc/postfix/

EXPOSE 2525

ENTRYPOINT [ "/smtp-relay.sh" ]
