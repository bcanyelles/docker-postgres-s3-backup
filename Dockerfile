FROM postgres:11

RUN apt-get update && \
	apt-get install python-dev python-pip -y && \
	apt-get clean && \
	pip install --use-wheel awscli

ADD entrypoint.sh /usr/local/bin

RUN mkdir /backup
WORKDIR /backup

ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
