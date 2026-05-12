# syntax=docker/dockerfile:1
# check=error=true

FROM ghcr.io/hunchr/ruby

ARG RUBY_VERSION= RUSTUP_VERSION=1.29.0
ENV PATH=/root/.cargo/bin:$PATH

COPY bin/assets-precompile /usr/bin
RUN apt-get install -Uqq --no-install-recommends \
    ca-certificates g++ gcc libffi-dev libgmp-dev libjemalloc-dev \
    libssl-dev libyaml-dev make unzip wget zlib1g-dev \
  # Install Bun
  && url=https://github.com/oven-sh/bun/releases/latest/download/bun-linux \
  && wget -q $url-$([ $(uname -m) = aarch64 ] && echo aarch64 || echo x64).zip \
  && unzip -jqd /usr/local/bin bun-*.zip \
  # Install Rust
  && url=https://static.rust-lang.org/rustup/archive/$RUSTUP_VERSION \
  && arch=$([ $(uname -m) = aarch64 ] && echo aarch64 || echo x86_64) \
  && wget -q $url/$arch-unknown-linux-gnu/rustup-init \
  && chmod +x rustup-init \
  && ./rustup-init -y --no-modify-path \
  # Install Ruby  
  && version=$(echo $RUBY_VERSION | cut -d . -f 1,2)/ruby-$RUBY_VERSION \
  && wget -qO - https://cache.ruby-lang.org/pub/ruby/$version.tar.gz | tar -xz \
  && cd ruby-* \
  && ./configure --disable-install-doc --disable-zjit --with-jemalloc \
  && make -j $(nproc) \
  && make install \
  && rm -fr /app /usr/local/lib/pkgconfig /usr/local/lib/ruby/gems/*/cache \
    /usr/local/man /usr/local/share /usr/share/doc \
    /var/cache/apt/archives /var/lib/apt/lists
