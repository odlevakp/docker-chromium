# Chromium in Docker

A simple image containing the [latest chromium build](https://www.chromium.org/getting-involved/download-chromium) inside an Ubuntu 16.04 based image.

As this build always takes the latest chromium zip file, details about the used revision are in `/opt/chromium_version.txt`.


```sh
docker run -d \
-p 9222:9222 \
--name chromium \
--cap-add=SYS_ADMIN \
bengroup/chromium:latest
```
