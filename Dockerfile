# Pgpool2.

FROM alpine:edge



# ENV PG_VERSION 9.6.1-r0

ENV LANG en_US.utf8

RUN apk add --no-cache curl pgpool py3-jinja2


ARG GOSU_VERSION=1.7
ENV GOSU_VERSION $GOSU_VERSION
ARG GOSU_DOWNLOAD_URL=https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64
ENV GOSU_DOWNLOAD_URL ${GOSU_DOWNLOAD_URL}

RUN curl -o /usr/local/bin/gosu -sSL ${GOSU_DOWNLOAD_URL} && \
    chmod +x /usr/local/bin/gosu

    
# RUN apk --update --no-cache add libpq=${PG_VERSION} postgresql-dev=${PG_VERSION} postgresql-client=${PG_VERSION} \
#                                 linux-headers gcc make libgcc g++ \
#                                 libffi-dev python python-dev py2-pip libffi-dev && \
#     cd /tmp && \ 
#     wget http://www.pgpool.net/mediawiki/images/pgpool-II-${PGPOOL_VERSION}.tar.gz -O - | tar -xz && \
#     chown root:root -R /tmp/pgpool-II-${PGPOOL_VERSION} && \
#     cd /tmp/pgpool-II-${PGPOOL_VERSION} && \
#     ./configure --prefix=/usr \
#                 --sysconfdir=/etc \
#                 --mandir=/usr/share/man \
#                 --infodir=/usr/share/info && \
#     make && \
#     make install && \
#     rm -rf /tmp/pgpool-II-${PGPOOL_VERSION} && \
#     apk del postgresql-dev linux-headers gcc make libgcc g++

# RUN pip install Jinja2

# RUN mkdir /etc/pgpool2 /var/run/pgpool /var/log/pgpool /var/run/postgresql /var/log/postgresql/ && \
#     chown postgres /etc/pgpool2 /var/run/pgpool /var/log/pgpool /var/run/postgresql /var/log/postgresql

RUN mkdir /var/run/postgresql /var/log/postgresql /var/run/pgpool && \
    chown postgres /var/run/postgresql /etc/pgpool /var/log/postgresql /var/run/pgpool

# Post Install Configuration.
COPY bin/configure-pgpool2 /usr/bin/
RUN chmod +x /usr/bin/configure-pgpool2
ADD conf/pcp.conf.template /tmp/pcp.conf.template
ADD conf/pgpool.conf.template /tmp/pgpool.conf.template

# Start the container.
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9999 9898

CMD ["pgpool","-n", "-f", "/etc/pgpool/pgpool.conf", "-F", "/etc/pgpool/pcp.conf"]
