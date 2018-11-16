```bash
git tag -a v0.11.0 -m "v.0.11.0"
git push origin --tags
```

```bash
docker build --build-arg \
   plugins=proxyprotocol,pdns \
   -t docker.icasei.com.br/caddy:1.4 \
   github.com/icasei/caddy-docker.git --no-cache
```