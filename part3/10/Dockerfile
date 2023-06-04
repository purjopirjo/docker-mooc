FROM alpine:latest
WORKDIR /app
COPY --chown=1000:1000 ./dl.sh .
ENV TERM=xterm \
    SAVEDIR=/dl
RUN mkdir -p /.cache && chown 1000:1000 /.cache && chmod +x dl.sh && touch temp.txt && chown 1000:1000 temp.txt && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk add --no-cache bash dialog yt-dlp ca-certificates wget ffmpeg bc && \
    rm -rf /var/cache/apk/*
USER 1000
ENTRYPOINT ["./dl.sh"]