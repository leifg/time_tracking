FROM alpine:3.7
LABEL maintainer="Leif Gensert <leif@leif.io>"

RUN apk add --no-cache ncurses-libs openssl bash

ARG VERSION

ADD _build/prod/rel/time_tracking/releases/${VERSION}/time_tracking.tar.gz /app

ENTRYPOINT ["app/bin/time_tracking"]
CMD ["foreground"]
