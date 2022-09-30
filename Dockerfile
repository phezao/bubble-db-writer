FROM ruby:2.6.6

RUN apt-get update

RUN apt-get install -y build-essential libglib2.0-dev libexpat1-dev cron

RUN gem install httparty dotenv byebug whenever
RUN apt install -y libpq-dev
RUN gem install pg

RUN mkdir /mycareforce_db
COPY bin /mycareforce_db/bin
COPY lib /mycareforce_db/lib
COPY .env /mycareforce_db/.env
COPY config /mycareforce_db/config
RUN ls /mycareforce_db/bin
WORKDIR /mycareforce_db
RUN whenever --update-cron

RUN touch /var/log/cron.log

CMD cron && tail -f /var/log/cron.log


