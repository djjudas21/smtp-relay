# smtp-relay

This image provides an SMTP relay host for emails from within a Kubernetes cluster.

Configure this container to use an upstream authenticated SMTP relay like SendGrid or your ISP's mail server, and provide an
open relay service to your cluster. This means you don't have to configure all of your containerised services with email auth secrets.
 
## Config

This image supports the following enironment variables. All are **required**.


| Variable                   | Use                                                                 | Example                   |
|----------------------------|---------------------------------------------------------------------|---------------------------|
| `SMTP_RELAY_HOST`          | Hostname of upstream SMTP relay server                              | `[smtp.sendgrid.net]:587` |
| `SMTP_RELAY_USERNAME`      | Username for upstream SMTP relay server                             | `apikey`                  |
| `SMTP_RELAY_PASSWORD`      | Password for upstream SMTP relay server                             | `pAsSwOrD`                |
| `SMTP_RELAY_MYHOSTNAME`    | Hostname of this SMTP relay                                         | `smtp-relay.yourhost.com` |
| `SMTP_RELAY_MYNETWORKS`    | Comma-separated list of local networks that can use this SMTP relay | `127.0.0.0/8,10.0.0.0/8`  |
| `SMTP_RELAY_WRAPPERMODE`   | Request postfix connects using SUBMISSIONS/SMTPS protocol instead of STARTTLS | `no`            |
| `SMTP_TLS_SECURITY_LEVEL`  | default SMTP TLS security level for the Postfix SMTP client         | `""`                      |
| `SMTP_USE_TLS`             | Define TLS usage to secure communication between mail servers       | `no`                      |

# Quickstart
Run on docker
```
docker run --rm -it -p 2525:25 \
	-e SMTP_RELAY_HOST="[smtp.sendgrid.net]:587" \
	-e SMTP_RELAY_MYHOSTNAME=smtp-relay.yourhost.com \
	-e SMTP_RELAY_USERNAME=username \
	-e SMTP_RELAY_PASSWORD=password \
	-e SMTP_RELAY_MYNETWORKS=127.0.0.0/8,10.0.0.0/8 \
	-e SMTP_RELAY_WRAPPERMODE=no \
	-e SMTP_TLS_SECURITY_LEVEL="" \
	djjudas21/smtp-relay

```
Send a test message
<pre>
<b>telnet localhost 2525</b>
220 smtp-relay.yourhost.com ESMTP Postfix
<b>helo localhost</b>
250 smtp-relay.yourhost.com
<b>mail from: noreply@yourhost.com</b>
250 2.1.0 Ok
<b>rcpt to: chris@applariat.com</b>
250 2.1.5 Ok
<b>data</b>
354 End data with <CR><LF>.<CR><LF>
<b>Subject: What?</b>
<b>My hovercraft is full of eels.</b>
<b>.</b>
250 2.0.0 Ok: queued as 982FF53C
<b>quit</b>
221 2.0.0 Bye
Connection closed by foreign host
</pre>
