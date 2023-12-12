FROM debian:bookworm-slim AS BUILDING

WORKDIR /root

RUN apt update && apt install -y wget make gcc file && \
    wget https://downloads.isc.org/isc/dhcp/4.4.3-P1/dhcp-4.4.3-P1.tar.gz && \
    tar xzf dhcp-4.4.3-P1.tar.gz && cd dhcp-4.4.3-P1 && \
    ./configure && make

FROM debian:bookworm-slim AS RUNNING

WORKDIR /root

COPY --from=BUILDING /root/dhcp-4.4.3-P1/server/dhcpd /root/dhcpd

RUN mkdir -p /var/lib/dhcp && touch /var/lib/dhcp/dhcpd.leases && \
    mkdir -p /etc/dhcp && touch /etc/dhcp/dhcpd.conf && \
    mkdir -p /run/dhcp-server && touch /run/dhcp-server/dhcp.pid && \
    chmod 775 /var/lib/dhcp && chmod 664 /var/lib/dhcp/dhcpd.leases

ENTRYPOINT ["./dhcpd", "-f", "-4", "-pf", "/run/dhcp-server/dhcpd.pid", "-cf", "/etc/dhcp/dhcpd.conf", "-lf", "/var/lib/dhcp/dhcpd.leases"]
