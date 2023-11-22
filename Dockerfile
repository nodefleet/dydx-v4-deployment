FROM ubuntu:latest

# Setting env vars
ENV DYDX_CHAIN_ID=dydx-mainnet-1
ENV BINARY_VERSION="v1.0.1"
ENV DYDX_PLATFORM="linux-amd64"

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      jq curl htop vim ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN update-ca-certificates

# Creating workdir and copying file into it
ENV HOME /dydxprotocol
WORKDIR /dydxprotocol
COPY . .

# Downloading the binary and addit it to PATH
RUN curl -LO https://github.com/dydxprotocol/v4-chain/releases/download/protocol%2F${BINARY_VERSION}/dydxprotocold-${BINARY_VERSION}-${DYDX_PLATFORM}.tar.gz
RUN tar -xzf dydxprotocold-${BINARY_VERSION}-${DYDX_PLATFORM}.tar.gz
RUN cp build/dydxprotocold-${BINARY_VERSION}-${DYDX_PLATFORM} "/bin/dydxprotocold"
RUN rm -r build dydxprotocold-${BINARY_VERSION}-${DYDX_PLATFORM}.tar.gz

RUN dydxprotocold version

# Setting chain-id
RUN dydxprotocold config chain-id ${DYDX_CHAIN_ID}

# Grant execution permission to start_node.sh (entrypoint)
RUN chmod +x start_node.sh

EXPOSE 26656
EXPOSE 1317
EXPOSE 26657
EXPOSE 9090

ENTRYPOINT ["/bin/bash", "/dydxprotocol/start_node.sh"]
