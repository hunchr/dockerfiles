# Dockerfiles

A collection of my personal dockerfiles.

## Ruby

Use this Dockerfile for Rails, Bun, and PostgreSQL:

```Dockerfile
# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is for production
FROM ghcr.io/hunchr/ruby:4.0.6 AS build

COPY package.json bun.lock .
RUN bun i -p

COPY Gemfile Gemfile.lock .ruby-version .
RUN bundle i

COPY . .
RUN assets-precompile

FROM ghcr.io/hunchr/ruby

COPY --from=build /app .
COPY --from=build /usr/local /usr/local

USER 1000:1000
```

Size: ~350 MB, Versions: `4.0.3`, `4.0.4`, `4.0.5`, `4.0.6`
