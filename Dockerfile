# ビルドステージ
FROM ruby:3.2.2-slim-bullseye as builder

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR /app

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y build-essential curl libpq-dev postgresql-client tzdata nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

# 本番ステージ
FROM ruby:3.2.2-slim-bullseye as prod

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR /app

RUN apt-get update -y && \
    apt-get install -y libpq-dev postgresql-client tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bundle /usr/local/bundle

COPY . .

RUN sh entrypoint.sh

ENTRYPOINT ["sh", "./entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

# 開発ステージ
FROM ruby:3.2.2-slim-bullseye as dev

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR /app

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y build-essential curl libpq-dev postgresql-client tzdata nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN bundle config set --global force_ruby_platform true

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

