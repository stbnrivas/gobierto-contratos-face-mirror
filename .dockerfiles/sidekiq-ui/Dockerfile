FROM ruby:2.7.1
EXPOSE 9292/tcp
LABEL MAINTAINER populate team

COPY src /src
RUN touch ~/.gemrc && echo "gem: --no-document" > ~/.gemrc

RUN apt-get update -qq \
  && apt-get install -y \
    build-essential \
    ruby-dev \
    bundler \
  && cd /src \
  && bundler install

WORKDIR /src
CMD ["bundle","exec","rackup","--host","0.0.0.0","-p","9292"]