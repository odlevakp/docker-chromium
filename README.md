# Chromium in Docker

A simple Debian based image containing chromium with rich font support for headless use.


```sh
docker run -d \
-p 9222:9222 \
--name chromium \
--cap-add=SYS_ADMIN \
bengroup/chromium:latest
```
