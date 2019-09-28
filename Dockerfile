FROM nginx:1

RUN export DEBIAN_FRONTEND noninteractive \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       imagemagick \
       exiftran \
       zip \
       liblcms2-utils \
       libimage-exiftool-perl \
       libjson-perl \
       libjson-xs-perl \
       jpegoptim \
       pngcrush \
       git \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://gitlab.com/wavexx/fgallery.git /fgallery/ \
  && cd /fgallery \
  && rm .git -rf

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

COPY files/* /
RUN rm -rf /usr/share/nginx/html

VOLUME /usr/share/nginx/html
VOLUME /images
WORKDIR /images
EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
