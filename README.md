## Description

Dockerfile and dhcpd.conf to create/run ISC DHCP (4.4.3-P1) container.
This is for my experiments.

## Usage

### Required Environment

- Docker

### Command

Build Dockerfile:

```sh
$ docker build -t <name> .
```

Run:

```sh
$ docker run --rm -itd --name <container_name> -v /path/to/dhcpd.conf:/etc/dhcp/dhcpd.conf -p 67:67 -p 68:68 <name>
```
