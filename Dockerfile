FROM rust:1.66.0 as builder

RUN rustup target add wasm32-wasi

# RUN curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -e all -p /usr/local

# ENV 

# Copy local code to the container image.
WORKDIR /usr/src/app
COPY . .

# Install production dependencies and build a release artifact.
RUN cargo build --release --target wasm32-wasi

FROM scratch 

COPY --from=builder /usr/src/app/target/wasm32-wasi/release/hellorust.wasm /

# Run the web service on container startup.
CMD ["/hellorust.wasm"]
