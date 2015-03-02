FROM centos:7

ENV RUBY_VERSION 2.2

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV HOME /root
ENV SHELL /bin/bash

RUN yum install -y make gcc ruby ruby-devel git
RUN gem install bundler


WORKDIR /app

ADD Gemfile /app/Gemfile
ADD gs_ruby_utils.gemspec /app/gs_ruby_utils.gemspec
ADD lib/gs_ruby_utils/version.rb /app/lib/gs_ruby_utils/version.rb
RUN bundle install
RUN cp /app/Gemfile.lock /app/.Gemfile.lock

ADD . /app
