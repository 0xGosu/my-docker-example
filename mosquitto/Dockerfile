FROM alpine:edge
MAINTAINER V.Anh Tran <tranvietanh1991@gmail.com>

LABEL Description="Eclipse Mosquitto MQTT Broker"

RUN apk --no-cache add mosquitto=1.4.11-r1 libwebsockets=2.2.0-r1

RUN mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log && \
    cp /etc/mosquitto/mosquitto.conf /mosquitto/config

COPY ./docker-entrypoint.sh /mosquitto/docker-entrypoint.sh
COPY ./conf /mosquitto/config

RUN chown -R mosquitto:mosquitto /mosquitto && \
    chmod -R 755 /mosquitto

ENTRYPOINT ["/mosquitto/docker-entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]