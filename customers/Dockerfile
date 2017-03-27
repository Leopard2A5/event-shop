FROM ruby:latest

RUN mkdir /app
WORKDIR /app

ADD . /app
RUN bundle install

ENTRYPOINT ["ruby", "app.rb"]
