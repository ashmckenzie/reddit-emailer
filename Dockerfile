FROM gliderlabs/alpine:latest
MAINTAINER ash@the-rebellion.net

ENV APP_HOME /app

ADD ./config/repositories /etc/apk/repositories

RUN apk add --update-cache build-base libxml2-dev libxslt-dev bash openssl-dev ca-certificates \
libffi-dev tzdata wget ruby@edge ruby-dev@edge

RUN cp /usr/share/zoneinfo/{{ userdata.system.timezone }} /etc/localtime

RUN echo 'gem: --no-document' > /etc/gemrc
RUN gem install bundler foreman io-console

RUN bundle config build.nokogiri "--use-system-libraries"

RUN mkdir -p ${APP_HOME}

WORKDIR /tmp
ADD src/Gemfile Gemfile
ADD src/Gemfile.lock Gemfile.lock
RUN bundle install -j4 --without "development test"

COPY src ${APP_HOME}
ADD config/Procfile ${APP_HOME}/Procfile
WORKDIR ${APP_HOME}
RUN cp -r /tmp/.bundle .

ADD ./config/start /start
RUN chmod 755 /start

CMD [ "/start" ]
