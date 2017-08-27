FROM erlang:18
MAINTAINER Alexey Nikitin tank@bohr.su

RUN ["mkdir", "-p", "/opt"]
RUN ["mkdir", "-p", "/build"]
COPY [".", "/build/"]
WORKDIR /build
RUN ["./rebar3", "release", "--dev-mode", "false", "--output-dir", "/opt"]
WORKDIR /opt/messenger
RUN ["rm", "-r", "/build"]
