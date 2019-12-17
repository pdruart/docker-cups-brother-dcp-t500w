FROM debian:stable

ADD https://download.brother.com/welcome/dlf103526/mfcl2710dwpdrv-4.0.0-1.i386.deb /
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
    cups \
    inotify-tools \
 && dpkg --add-architecture i386 \
 && dpkg -i --force-all /mfcl2710dwpdrv-4.0.0-1.i386.deb \
 && rm -f /mfcl2710dwpdrv-4.0.0-1.i386.deb \
 && rm -rf /var/lib/apt/lists/*

EXPOSE 631

VOLUME /config

ADD run.sh /
RUN chmod +x run.sh
CMD ["/run.sh"]
