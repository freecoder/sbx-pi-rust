$MyTag = Get-Date -Format "yyyyMMddHHmm"
docker buildx build --platform linux/amd64 -t freecoderhub/sbx-pi-rust:$MyTag -t freecoderhub/sbx-pi-rust:latest --push .