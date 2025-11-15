FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y iproute2 iptables iputils-ping tcpdump babeld && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./scripts/mesh_start.sh /usr/local/bin/mesh_start.sh
RUN chmod +x /usr/local/bin/mesh_start.sh

CMD ["/usr/local/bin/mesh_start.sh"]