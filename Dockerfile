FROM library/rails:4.2.2

MAINTAINER Michael Lopez <michael@weahead.se>

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.17.1.1/s6-overlay-amd64.tar.gz /tmp/

RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && rm -f /tmp/s6-overlay-amd64.tar.gz

RUN mkdir /portus

WORKDIR /portus

COPY Portus/Gemfile* ./

RUN bundle install --retry=3

COPY Portus .

COPY root /

EXPOSE 3000

ENTRYPOINT ["/init"]
