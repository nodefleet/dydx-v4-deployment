# Run DyDx node

1- Setup env vars, just need to edit `env.example` file adding a ETH endpoint and rename the file as `.env`.

2- Change `$BINARY_VERSION` env var from `Dockerfile` or image name from `docker-compose.yaml` file (IF NEEDED).

3- Run `docker-compose up -d dydx`. There you go.


## Setup Traefik (Reverse Proxy - OPTIONAL)

If you want to create endpoints for your DyDx node with your own domain name, access to it via web browser with SSL certs (for https protocol implementation) and even share it without sharing the IP address of your node, probably you're interested in getting up a reverse proxy implementation.

One of the easiest reverse proxy out there is `Traefik`, just need to change `HOST` rule in `services/dydx.yaml` file to you own domain name and make sure to redirect the traffic to the correct port of your dydx node. Then, just need to get up the traefik service running `docker-compose up -d traefik`.

**NOTE:** If you run traefik reverse proxy and dydx node inside the same docker network, you can redirect the traffic from traefik directly to your docker container.

*EXAMPLE:*

Instead of using

```
dydx-tendermint:
  loadbalancer:
    passHostHeader: false
      servers:
        - url: http://{INSERT_YOUR_DYDX_NODE_IP_HERE}:26657
```

Is more efficient to use:

```
dydx-tendermint:
      loadbalancer:
        passHostHeader: false
        servers:
          - url: http://{INSERT_DYDX_DOCKER_CONTAINER_NAME}:26657
```
