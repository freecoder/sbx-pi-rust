FROM docker/sandbox-templates:shell

USER root

### Ubuntu Packages ###
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    build-essential \
    fd-find \
    ripgrep \
    curl \
    btop \
    git \
    vim \
    nodejs \
    npm \
    golang-go \
    python3 \
    python3-pip \
    python3-venv \
    mingw-w64 \
    clang \
    lld \
    llvm \
    && /usr/bin/ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

### UV ###
ENV UV_INSTALL_DIR=/usr/local/bin
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

WORKDIR /home/agent
USER agent

### Rust ###
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN /home/agent/.cargo/bin/rustup target add \
    x86_64-unknown-linux-gnu \
    x86_64-pc-windows-gnu \
    x86_64-pc-windows-msvc \
    wasm32-unknown-unknown \
    wasm32-wasip1 && \
    /home/agent/.cargo/bin/rustup component add rustfmt clippy rust-analyzer rust-src && \
    /home/agent/.cargo/bin/rustup set default-host x86_64-unknown-linux-gnu

### Pi.Dev ###
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent

### Semble ###
RUN /usr/local/bin/uv tool install semble

### CodeGraph ###
RUN /usr/bin/npm install -g @colbymchenry/codegraph

### Amend PATH
ENV PATH="/home/agent/.local:$PATH"
ENV PATH="/home/agent/.local/bin:$PATH"
ENV PATH="/home/agent/.cargo/bin:$PATH"

ENTRYPOINT ["pi"]
