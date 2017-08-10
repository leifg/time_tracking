FROM alpine:3.6
MAINTAINER Leif Gensert <leif@leif.io>

RUN apk add --no-cache ncurses-libs openssl

ARG VERSION

ADD _build/prod/rel/time_tracking/releases/${VERSION}/time_tracking.tar.gz /app

ENTRYPOINT ["app/bin/time_tracking"]
CMD ["foreground"]
