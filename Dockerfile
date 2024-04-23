FROM ruby:3.2.1

RUN apt update -qq && apt install -y postgresql-client
RUN mkdir /second_to_none
WORKDIR /second_to_none
COPY Gemfile /second_to_none/Gemfile
COPY Gemfile.lock /second_to_none/Gemfile.lock
RUN bundle install
RUN gem install foreman
COPY . /second_to_none
ENV TZ Asia/Tokyo

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

