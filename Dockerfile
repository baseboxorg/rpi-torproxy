#
# pull latest Raspbian image
#FROM resin/rpi-raspbian:latest
FROM resin/raspberrypi2-debian:latest
MAINTAINER rpio

ENV TORUSER 1940
ENV TORPASSWORD 'f9m9nFE38y2mTJ8k7crM'
#
# install evennia prerequisites
RUN /usr/bin/apt-get -y update && apt-get -y install \
  sudo \
  privoxy \
  tor

#
# install and set up TOR
RUN useradd -u $TORUSER -m -p $TORPASSWORD tor
RUN echo '$TORUSER ALL=(ALL) ALL' > /etc/sudoers
COPY torrc /etc/$TORUSER/torrc
COPY runtor.sh /runtor.sh
RUN chmod 755 /runtor.sh
RUN sed -i 's/localhost:8118/0.0.0.0:8118/g' /etc/privoxy/config
RUN echo 'forward-socks4a  /               127.0.0.1:9050 .' >> /etc/privoxy/config

#
# docker entrypoint
EXPOSE 9001 9030 9050 8118
ENTRYPOINT ["/runtor.sh"]
