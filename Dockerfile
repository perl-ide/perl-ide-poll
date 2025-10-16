FROM ubuntu:jammy

WORKDIR /app
COPY . . 

ENV MOJO_REVERSE_PROXY=1
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y libmojolicious-perl libmojo-sqlite-perl libcpanel-json-xs-perl

CMD ["perl", "bin/perl-ide-poll.pl", "daemon", "--listen", "http://0.0.0.0:3000"]
