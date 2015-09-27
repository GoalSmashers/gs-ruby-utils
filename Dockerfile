FROM ruby:2.2.3

WORKDIR /app

ADD Gemfile /app/Gemfile
ADD gs_ruby_utils.gemspec /app/gs_ruby_utils.gemspec
ADD lib/gs_ruby_utils/version.rb /app/lib/gs_ruby_utils/version.rb
RUN bundle install --jobs 4 --binstubs

ADD . /app

CMD ["bash"]
