FROM rust:slim as builder
RUN apt-get update && \
    apt-get install -y pkg-config libssl-dev && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /build
COPY . .
RUN mkdir bin
RUN cd phase1-cli && \
    cargo build --release --bins && \
    find ./target/release/ -maxdepth 1 -type f -perm /a+x -exec sh -c 'mv {} /build/bin/phase1_$(basename {})' \;
RUN cd setup2 && \
    cargo build --release --bins && \
    find ./target/release/ -maxdepth 1 -type f -perm /a+x -exec sh -c 'mv {} /build/bin/phase2_$(basename {})' \;

FROM debian:buster-slim
COPY --from=builder /build/bin/* /usr/bin/