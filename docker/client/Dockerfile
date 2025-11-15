FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y iproute2 iputils-ping tcpdump traceroute && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./scripts/client_start.sh /usr/local/bin/client_start.sh
RUN chmod +x /usr/local/bin/client_start.sh

CMD ["/usr/local/bin/client_start.sh"]