Pgpool2 Dockerfile
==================

This project can be used to deploy pgpool2 inside a Docker container for transparent failover between two postgresql hosts without requiring a floating IP address.

It relies on [Alpine Linux](https://alpinelinux.org/) - [Edge](https://wiki.alpinelinux.org/wiki/Edge).

### Tags and respective Dockerfile links
- [`3.6.0`, `latest` (master/Dockerfile)](https://github.com/manuc66/pgpool2-container/blob/master/Dockerfile)
- [`3.5.4` (3.5.4/Dockerfile)](https://github.com/manuc66/pgpool2-container/blob/3.5.4/Dockerfile)

### Current versions (latest)
- `Alpine 3.5` : ([release notes](https://www.alpinelinux.org/posts/Alpine-3.5.0-released.html))
- [Pgpool-II](http://www.pgpool.net): `3.6.1` ([release notes](http://www.pgpool.net/docs/latest/en/html/release-3-6.html))
- [libpq](https://pkgs.alpinelinux.org/package/v3.5/main/x86/libpq): `9.6.1-r0`
- [postgresql-client](https://pkgs.alpinelinux.org/package/v3.5/main/x86/postgresql-client): `9.6.1-r0`

### Running the Container

#### Stand alone command line
```sudo docker run --name pgpool2 -e PGPOOL_BACKENDS=1:127.0.0.1:5432,2:127.0.0.1:5433 -p 5432:5432/tcp manuc66/pgpool2-container-alpine:latest```

#### With docker-compose
```
version: '3'
services:
  mypostgres:
    image: postgres:9.6-alpine

  pgpool2:
    image: manuc66/pgpool2-container-alpine:latest
    depends_on: 
      - mypostgres
    environment:
      - PGPOOL_BACKENDS=1:mypostgres:5432
    ports:
      - 5432:5432/tcp
```

### Configuration Environment Variables

**PCP_PORT** - The port used to listen for PCP commands. (default: 9898)

**PCP_USER** - The user allowed to execute PCP commands. (default: postgres)

**PCP_USER_PASSWORD** - The pcp user password. (default: bettervoice)

**PGPOOL_PORT** - The port used by pgpool2 to listen for client connections. (default: 5432)

**PGPOOL_BACKENDS** - A comma separated list of PostgeSQL server backends. The format for each backend is as follows: INDEX:HOST:PORT (default: 1:localhost:5432)
