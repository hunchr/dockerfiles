# syntax=docker/dockerfile:1
# check=error=true

FROM debian:trixie-slim

ENV BUNDLE_DEPLOYMENT=1 \
  BUNDLE_SILENCE_ROOT_WARNING=1 \
  BUNDLE_WITHOUT=development:test \
  DEBIAN_FRONTEND=noninteractive \
  IRB_USE_AUTOCOMPLETE=true \
  LANG=C.UTF-8 \
  RAILS_ENV=production \
  RUBYOPT=--enable=frozen_string_literal,yjit

WORKDIR /app
COPY bin/docker-entrypoint /usr/local/bin
RUN apt-get install -Uqq --no-install-recommends \
    ca-certificates libffi8 libgmp10 libjemalloc2 libssl3t64 libyaml-0-2 \
  && mkdir -p tmp \
  && useradd -d /app -s /bin/bash -u 1000 rails \
  && chown -R rails:rails tmp \
  && rm -fr /usr/local/man /usr/local/share /usr/share/doc \
    /var/cache/apt/archives /var/lib/apt/lists

EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
CMD ["bin/rails", "s"]
