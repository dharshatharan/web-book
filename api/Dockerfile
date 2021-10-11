FROM ruby:3.0.2-slim-buster

RUN apt-get update \
	&& apt-get install -y \
	nodejs \
	build-essential \
	default-mysql-client \
	default-libmysqlclient-dev \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN gem install bundler
RUN bundle install
COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 5000
CMD ["rails", "server", "-b", "0.0.0.0"]