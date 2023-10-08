# ==============================================================================
# Base Compilation
# ==============================================================================
FROM elixir:1.12-alpine AS elixir

RUN mix local.hex --force && mix local.rebar --force

RUN apk update
RUN apk add git inotify-tools bash curl tar xz alpine-sdk

ARG MIX_ENV=prod
ARG DATABASE_URL
ARG SECRET_KEY_BASE

WORKDIR /app

COPY mix.exs mix.exs
COPY mix.lock mix.lock
RUN mix deps.get

COPY config config
RUN mix deps.compile

COPY lib priv test .formatter.exs .gitignore .iex.exs /app/

RUN mix compile

## ==============================================================================
## JavaScript
## ==============================================================================
#
#FROM elixir:1.12-alpine AS javascript
#
#RUN apk update
#RUN apk add git nodejs npm inotify-tools bash curl tar xz alpine-sdk python3
#
#COPY assets /app/assets
#COPY --from=elixir /app/deps /app/deps
#
#WORKDIR /app/assets
#
#RUN npm install
#RUN npm run deploy

# ==============================================================================
# Final
# ==============================================================================

FROM elixir:1.12-alpine

RUN mix local.hex --force && mix local.rebar --force

RUN apk update
RUN apk add git inotify-tools bash curl tar xz alpine-sdk

WORKDIR /app

COPY --from=elixir /app /app
