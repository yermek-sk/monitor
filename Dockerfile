FROM alpine:3.19

RUN apk add --no-cache curl bash \
    bc \
    postgresql-client	

COPY monitor.sh /usr/local/bin/monitor.sh
COPY send_alert.sh /usr/local/bin/send_alert.sh

RUN chmod 755 /usr/local/bin/monitor.sh /usr/local/bin/send_alert.sh

# Файл расписания

CMD ["/usr/local/bin/monitor.sh"]
