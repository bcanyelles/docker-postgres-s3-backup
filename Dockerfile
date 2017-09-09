FROM alpine:3.6
MAINTAINER Leif Gensert <leif@leif.io>

RUN \
	mkdir -p /aws \
	&& apk -Uuv --no-cache add groff less python py-pip postgresql \
	&& pip install awscli \
	&& apk --purge -v del py-pip \
	&& rm /var/cache/apk/*

ADD entrypoint.sh /usr/local/bin

RUN mkdir /backup
WORKDIR /backup

ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
