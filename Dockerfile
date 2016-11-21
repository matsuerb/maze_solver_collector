FROM ruby:2.3.2-slim
MAINTAINER Yuya.Nishida.

# install PostgreSQL client and Node.js
RUN set -xe ; \
  apt-get update ; \
  apt-get install -y --no-install-recommends postgresql-client nodejs ; \
  rm -rf /var/lib/apt/lists/*

# install Docker: https://docs.docker.com/engine/installation/linux/debian/
RUN set -xe ; \
  apt-get update ; \
  apt-get install -y --no-install-recommends \
    apt-transport-https ca-certificates ; \
  apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
    --recv-keys 58118E89F3A912897C070ADBF76221572C52609D ; \
  echo deb https://apt.dockerproject.org/repo debian-jessie main | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null ; \
  apt-get update ; \
  apt-get install -y --no-install-recommends docker-engine

# install application
ENV RAILS_ENV production
WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .
RUN cp -a config/database.yml.example config/database.yml

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
