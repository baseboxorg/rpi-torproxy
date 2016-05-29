#
# pull latest Raspbian image
FROM resin/rpi-raspbian:latest
MAINTAINER ufud.org <webmaster :at: ufud :dot: org>

#
# install evennia prerequisites
RUN /usr/bin/apt-get -y update && apt-get -y install \
sudo \
privoxy \
tor


#
# install and set up TOR
RUN useradd -u 1984 -m -p '$1$Re@dy0rN$/upBg5x.s6nt8gHOH9NS0/' tor
RUN echo 'tor ALL=(ALL) ALL' > /etc/sudoers
COPY torrc /etc/tor/torrc
COPY runtor.sh /runtor.sh
RUN chmod 755 /runtor.sh
RUN sed -i 's/localhost:8118/0.0.0.0:8118/g' /etc/privoxy/config
RUN echo 'forward-socks4a  /               127.0.0.1:9050 .' >> /etc/privoxy/config

#
# docker entrypoint
EXPOSE 9001 9030 9050 8118
ENTRYPOINT ["/runtor.sh"]
