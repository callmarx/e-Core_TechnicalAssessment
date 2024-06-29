ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

RUN apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    less \
    git \
    libpq-dev \
    postgresql-client \
    libvips \
    curl

ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
  
WORKDIR /app

RUN gem update --system && gem install bundler

ENTRYPOINT ["./bin/docker-entrypoint"]

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
