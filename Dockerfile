FROM debian:bookworm-slim AS BUILDING

WORKDIR /root

RUN apt update && apt install -y wget make gcc && \
    wget https://downloads.isc.org/isc/dhcp/4.4.3-P1/dhcp-4.4.3-P1.tar.gz && \
    tar xzvf dhcp-4.4.3-P1.tar.gz && cd dhcp-4.4.3-P1 \
    ./configure && make

FROM debian:bookworm-slim AS RUNNING

WORKDIR /root

COPY --from=BUILDING /root/dhcp-4.4.3-P1/server/dhcpd /root/dhcpd

# TODO: add options, pre-run scripts.

CMD ["dhcpd"]
