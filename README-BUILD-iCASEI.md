```bash
docker build --build-arg \
   plugins=proxyprotocol,pdns \
   -t docker.icasei.com.br/caddy \
   github.com/icasei/caddy-docker.git --no-cache
```

```bash
docker build --build-arg \
   plugins=proxyprotocol,pdns \
   -t docker.icasei.com.br/caddy:1.1 \
   github.com/icasei/caddy-docker.git --no-cache
```