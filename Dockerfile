FROM ruby:alpine

RUN \
  apk --no-cache add --virtual build_deps \
    build-base \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev && \
  apk --no-cache add \
    postgresql-client && \
  gem install pg && \
  gem install nokogiri -- --use-system-libraries && \
  gem install standalone_migrations && \
  apk del build_deps

WORKDIR /usr/src/app

RUN \
  echo \
    "require 'standalone_migrations'; StandaloneMigrations::Tasks.load_tasks" \
    >> Rakefile

ENTRYPOINT ["rake"]
