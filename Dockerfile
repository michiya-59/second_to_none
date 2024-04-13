FROM ruby:3.2.1

RUN apt update -qq && apt install -y postgresql-client
RUN mkdir /blast_stn_knowledge
WORKDIR /blast_stn_knowledge
COPY Gemfile /blast_stn_knowledge/Gemfile
COPY Gemfile.lock /blast_stn_knowledge/Gemfile.lock
RUN bundle install
RUN gem install foreman
COPY . /blast_stn_knowledge
ENV TZ Asia/Tokyo

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

