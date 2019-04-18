FROM ubuntu:16.04
LABEL version "1.3"
LABEL description "Headless chromium builds."

ENV APT_PACKAGES wget curl unzip apt-transport-https ca-certificates software-properties-common

# Proper font support.
ENV FONT_MISC fonts-symbola ttf-ubuntu-font-family ttf-bitstream-vera fonts-twemoji-svginot
ENV FONT_CHI fonts-arphic-ukai fonts-arphic-uming
ENV FONT_JPN fonts-ipafont-mincho fonts-ipafont-gothic
ENV FONT_KOR fonts-unfonts-core
ENV FONT_THA fonts-thai-tlwg

ENV FONT_PACKAGES ${FONT_MISC} ${FONT_CHI} ${FONT_JPN} ${FONT_KOR} ${FONT_THA}

ENV CHROME_USER chrome
ENV CHROMIUM_REVISION latest

RUN mkdir -p /home/${CHROME_USER} && \
    groupadd --system ${CHROME_USER} && \
    useradd --system --gid ${CHROME_USER} ${CHROME_USER} && \
    chown -R ${CHROME_USER}:${CHROME_USER} /home/${CHROME_USER}

# Add helper scripts.
ADD get_latest_chromium.sh /opt/get_latest_chromium.sh
ADD get_fonts.sh /opt/get_fonts.sh

# Install fonts so we can render properly.
RUN apt-get update && \
    apt-get install --yes ${APT_PACKAGES} && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
    echo ttf-mscorefonts-installer msttcorefonts/dldir select /root/ms-fonts/ | debconf-set-selections && \
    bash /opt/get_fonts.sh && \
    apt-add-repository --yes ppa:eosrei/fonts && \
    apt-get update && \
    apt-get install --yes ttf-mscorefonts-installer ${FONT_PACKAGES}

# Install chromium.
RUN apt-get install --yes --no-install-recommends \
    $( apt-cache depends chromium-browser | awk '/\ Depends:/{print$2}' ) && \
    bash /opt/get_latest_chromium.sh && \
    apt-get remove --yes ${APT_PACKAGES} && \
    chown -R ${CHROME_USER}:${CHROME_USER} /opt/chrome-linux && \
    rm -rf /var/lib/apt/lists/*

USER ${CHROME_USER}

WORKDIR /opt/chrome-linux

EXPOSE 9222

ENTRYPOINT [ "./chrome", \
             "--headless", "--disable-gpu", \
             "--remote-debugging-address=0.0.0.0", \
             "--remote-debugging-port=9222" ]
