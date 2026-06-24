# sbx-pi-rust
Docker SBX Pi.dev Rust

## Docker Hub Image

```
docker pull freecoderhub/sbx-pi-rust
```

## Docker SBX Agent Kit

```
schemaVersion: "2"
kind: sandbox
name: sbx-pi-rust-agent
network:
  allowedDomains:
    - "*"
sandbox:
  image: "docker.io/freecoderhub/sbx-pi-rust:latest"
  entrypoint:
    run: ["pi"]
agentContext:
  ## Sandbox environment
  Inside Docker sandbox.
  `sudo` is passwordless for package installs.
commands:
  install:
    - description: "Update Installation"
      user: "0"
      command: |
        ( \
          /usr/bin/apt-get update && \
          /usr/bin/apt-get upgrade -y \
        ) > /tmp/apt_install_log.txt 2>&1
    - description: "Update Rust"
      user: "1000"
      command: "/home/agent/.cargo/bin/rustup update"
    - description: "Update Pi"
      user: "1000"
      command: "/usr/bin/npm update -g @earendil-works/pi-coding-agent"
    - description: "Update sandbox persistence"
      user: "0"
      command: |
        cat << 'FEOF' >> /etc/sandbox-persistent.sh
        export PATH="$HOME/.local:$PATH"
        export PATH="$HOME/.local/bin:$PATH"
        export PATH="$HOME/.cargo/bin:$PATH"
        FEOF
```


## Docker SBX Windows Script

```
@echo off
set "script_dir=%~dp0"
for %%I in ("%~dp0..") do set "working_dir=%%~fI"
sbx run --kit %script_dir% --name sbx-pi-rust-sandbox sbx-pi-rust-agent %working_dir%
sbx rm --force sbx-pi-rust-sandbox
```
