FROM ruby:3.2.1

RUN apt update -qq && apt install -y postgresql-client
RUN mkdir /shine_stn_app
WORKDIR /shine_stn_app
COPY Gemfile /shine_stn_app/Gemfile
COPY Gemfile.lock /shine_stn_app/Gemfile.lock
RUN bundle install
COPY . /shine_stn_app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

