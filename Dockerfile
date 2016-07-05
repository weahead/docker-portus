FROM rails:4.2.2

MAINTAINER We ahead <docker@weahead.se>

ENV RAILS_ENV=production\
    NOKOGIRI_USE_SYSTEM_LIBRARIES=1\
    S6_VERSION=1.18.1.3\
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz /tmp/
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz.sig /tmp/

RUN gpg --keyserver pgp.mit.edu --recv-key 0x337EE704693C17EF && \
    gpg --verify /tmp/s6-overlay-amd64.tar.gz.sig /tmp/s6-overlay-amd64.tar.gz && \
    tar -xzf /tmp/s6-overlay-amd64.tar.gz -C /

WORKDIR /portus

COPY Portus/Gemfile* ./

RUN bundle config build.nokogiri --use-system-libraries && \
    bundle install --retry=3

COPY Portus .

COPY root /

EXPOSE 3000

ENTRYPOINT ["/init"]
