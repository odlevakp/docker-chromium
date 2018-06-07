#!/bin/bash
#
# Download fonts to circumvent an issue in ttf-mscorefonts-installer.
#
set -e

FONTS='andale32 arial32 arialb32 comic32 courie32 georgi32 impact32 times32 trebuc32 verdan32 webdin32'

mkdir -p /opt/ms-fonts
cd /opt/ms-fonts

echo 'Downloading fonts...'

for font in ${FONTS}; do
  echo "* ${font}"
  wget -q http://downloads.sourceforge.net/corefonts/${font}.exe
done

echo 'Done'
