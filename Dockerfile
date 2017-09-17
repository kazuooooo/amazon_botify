FROM ruby:2.4
RUN gem install bundler
ADD ./app /app
WORKDIR /app
RUN bundle install