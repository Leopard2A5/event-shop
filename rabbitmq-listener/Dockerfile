FROM ruby:2.4.1-alpine

RUN mkdir /app
WORKDIR /app

ADD . /app
RUN bundle install

ENTRYPOINT ["ruby", "app.rb"]
