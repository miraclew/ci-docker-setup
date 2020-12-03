FROM golang:1.15.1

COPY ci-dep.list /etc/apt/sources.list
COPY start.sh start.sh
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 8C718D3B5072E1F5
ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update \
    && apt-get install -y apt-utils \                                           
    && { \
        echo debconf debconf/frontend select Noninteractive; \
        echo mysql-community-server mysql-community-server/data-dir \
            select ''; \
        echo mysql-community-server mysql-community-server/root-pass \
            password 'abc123'; \
        echo mysql-community-server mysql-community-server/re-root-pass \
            password 'abc123'; \
        echo mysql-community-server mysql-community-server/remove-test-db \
            select true; \
    } | debconf-set-selections \
    && apt-get install -y mysql-server \
    && apt-get -y install redis-server

CMD [ "./start.sh" ]
