FROM debian:bookworm-slim AS BUILDING

WORKDIR /root

RUN apt update && apt install -y wget make gcc && \
    wget https://downloads.isc.org/isc/dhcp/4.4.3-P1/dhcp-4.4.3-P1.tar.gz && \
    tar xzvf dhcp-4.4.3-P1.tar.gz && cd dhcp-4.4.3-P1 \
    ./configure && make

FROM debian:bookworm-slim AS RUNNING

WORKDIR /root

COPY --from=BUILDING /root/dhcp-4.4.3-P1/server/dhcpd /root/dhcpd

RUN mkdir /var/lib/dhcp && touch /var/lib/dhcp/dhcpd.leases && \
    chown root:dhcpd /var/lib/dhcp /var/lib/dhcp/dhcpd.leases && \
    chmod 775 /var/lib/dhcp && chmod 664 /var/lib/dhcp/dhcpd.leases

CMD ["dhcpd", "-user", "dhcpd", "-group", "dhcpd", "-f", "-4", "-pf", "/run/dhcp-server/dhcpd.pid", "-cf", "/etc/dhcp/dhcpd.conf"]
