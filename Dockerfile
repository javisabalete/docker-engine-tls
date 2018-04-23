FROM alpine

RUN apk update && \
  apk add --no-cache openssl --update bash && \
  rm -rf /var/cache/apk/*

ADD run.sh /run.sh
RUN chmod +x /run.sh

VOLUME /certs

CMD /run.sh
