FROM debian:stable

ADD https://download.brother.com/welcome/dlf101957/dcpt500wcupswrapper-3.0.2-0.i386.deb /
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
    cups \
    inotify-tools \
 && dpkg --add-architecture i386 \
 && dpkg -i --force-all /dcpt500wcupswrapper-3.0.2-0.i386.deb \
 && rm -f /dcpt500wcupswrapper-3.0.2-0.i386.deb \
 && rm -rf /var/lib/apt/lists/*

EXPOSE 631

VOLUME /config

ADD run.sh /
RUN chmod +x run.sh
CMD ["/run.sh"]
