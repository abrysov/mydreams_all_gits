FROM erlang:18
MAINTAINER Alexey Nikitin tank@bohr.su

RUN mkdir -p /opt/messenger
COPY _build/default/rel/mydreams /opt/messenger
WORKDIR /opt/messenger

CMD ["tail", "-f", "/dev/null"]
