FROM debian:stable-slim
WORKDIR /usr/src/app
COPY ./dl.sh ./
RUN echo "deb http://deb.debian.org/debian $(cat /etc/os-release | grep 'VERSION_CODENAME' | cut -d'=' -f2)-backports main" >> /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get -y install dialog yt-dlp ca-certificates wget ffmpeg bc
ENTRYPOINT ["./dl.sh"]
ENV SAVEDIR=/dl