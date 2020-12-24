FROM ruby:2.7.2-slim
MAINTAINER Sathish <reachtosathish.b@gmail.com>

RUN apt update &&\
    apt upgrade &&\
    apt-get install -y build-essential patch ruby-dev zlib1g-dev liblzma-dev postgresql-client libpq-dev

# Clean APT cache
RUN rm -rf /var/cache/apt/*
RUN mkdir -p /usr/app
COPY . /usr/app/
WORKDIR /usr/app/
RUN bundle install

CMD ["bin/run"]