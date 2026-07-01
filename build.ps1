$MyTag = Get-Date -Format "yyyyMMddHHmm"
docker buildx build --no-cache --platform linux/amd64 -t freecoderhub/sbx-pi-rust:$MyTag -t freecoderhub/sbx-pi-rust:latest --push .