FROM centos:7

ENV RUBY_VERSION 2.2.0

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV HOME /root
ENV SHELL /bin/bash

RUN yum install -y make wget tar libffi-devel zlib zlib-devel openssl openssl-devel gcc git

RUN wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-$RUBY_VERSION.tar.gz
RUN tar fxz ruby-$RUBY_VERSION.tar.gz
RUN cd ruby-$RUBY_VERSION && ./configure --disable-install-doc && make --jobs=4 && make install

RUN echo "gem: --no-document" > /etc/gemrc
RUN gem install bundler


WORKDIR /app

ADD Gemfile /app/Gemfile
ADD gs_ruby_utils.gemspec /app/gs_ruby_utils.gemspec
ADD lib/gs_ruby_utils/version.rb /app/lib/gs_ruby_utils/version.rb
RUN bundle install --jobs 4

ADD . /app

CMD ["bash"]
