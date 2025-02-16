ARG BASE_IMAGE_TAG=ubuntu-22.04
FROM jupyter/minimal-notebook:$BASE_IMAGE_TAG

LABEL maintainer="Alessandro Fazzi <alessandro.fazzi@welaika.com>"

USER root

# Pre-requisites
# hadolint ignore=DL3008
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
  curl \
  gcc \
  libczmq-dev \
  libffi-dev \
  libgdbm-dev \
  libgmp-dev \
  liblapacke-dev \
  libncurses5-dev \
  libopenblas-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libxml2-dev \
  libxslt1-dev \
  libyaml-dev \
  libzmq3-dev \
  pkg-config \
  sqlite3 \
  tzdata \
  zlib1g-dev && \
  rm -rf /var/lib/apt/lists/*

# Copy Ruby files from rubylang/ruby with specific version
COPY --from=ruby:3.4.2 \
  /usr/local/bin/bundle \
  /usr/local/bin/bundler \
  /usr/local/bin/erb \
  /usr/local/bin/gem \
  /usr/local/bin/irb \
  /usr/local/bin/racc \
  /usr/local/bin/rake \
  /usr/local/bin/rdoc \
  /usr/local/bin/ri \
  /usr/local/bin/ruby \
  /usr/local/bin/

COPY --from=ruby:3.4.2 \
  /usr/local/etc/gemrc \
  /usr/local/etc/

# NOTE: Ruby include directory version is major.minor.0
COPY --from=ruby:3.4.2 \
  /usr/local/include/ruby-3.4.0/ \
  /usr/local/include/ruby-3.4.0/

COPY --from=ruby:3.4.2 \
  /usr/local/lib/libruby.so \
  /usr/local/lib/libruby.so.* \
  /usr/local/lib/

COPY --from=ruby:3.4.2 \
  /usr/local/lib/pkgconfig/ \
  /usr/local/lib/pkgconfig/

COPY --from=ruby:3.4.2 \
  /usr/local/lib/ruby/ \
  /usr/local/lib/ruby/

COPY --from=ruby:3.4.2 \
  /usr/local/share/man/man1/erb.1 \
  /usr/local/share/man/man1/irb.1 \
  /usr/local/share/man/man1/ri.1 \
  /usr/local/share/man/man1/ruby.1 \
  /usr/local/share/man/man1/

USER $NB_UID

RUN echo "gem: --user-install" >> "$HOME/.gemrc"

# NOTE: DO NOT CHANGE the version in the path of gem's bin directory
ENV PATH=$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH

# Install basic gems
RUN \
  gem install irb:1.15.1 \
  iruby:0.8.1 \
  amazing_print:1.7.2 \
  ffi-rzmq:2.0.7 && \
  iruby register --force
