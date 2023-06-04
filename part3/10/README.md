```
Previous dockerfile:
https://github.com/purjopirjo/docker-mooc/blob/main/part1/15/Dockerfile

Changes:
- base image debian:stable-slim -> alpine:latest
- apk --no-cache and also rm -rf /var/cache/apk/* if there was something before apk add
- use of non-root user (uid 1000)
- added ENV TERM to remove warning message

Results:
- 662MB -> 215MB image size

Usage:
https://github.com/purjopirjo/docker-mooc/blob/main/part1/15/README.md

----
docker build . -t video-downloader -f ./Dockerfile
docker tag video-downloader servufi/video-downloader:latest
docker push servufi/video-downloader:latest
docker images
docker rmi 135ea09ff21a video-downloader
```