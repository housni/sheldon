FROM bash:4.3
MAINTAINER Housni Yakoob <housni.yakoob@gmail.com>

RUN apk update && apk upgrade && apk add py-pip

RUN apk add --update \
    py-pip \
  && pip install sphinx \
  && rm -rf /var/cache/apk/

WORKDIR /usr/lib/sheldon