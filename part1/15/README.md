# video-downloader

### Features

- Downloads audio/video URLs using yt-dlp ( [debian](https://tracker.debian.org/pkg/yt-dlp "https://tracker.debian.org/pkg/yt-dlp") / [github](https://github.com/yt-dlp/yt-dlp "https://github.com/yt-dlp/yt-dlp") )
- Takes filesize limit as argument, and if not satisfied tries to encode closer to target filesize (ffmpeg)
- Stores files only in .mp4 format

### Dependencies
- Install Docker and pull/run [image](https://hub.docker.com/r/servufi/video-downloader "https://hub.docker.com/r/servufi/video-downloader"):

`$ docker pull servufi/video-downloader:latest`

### Usage
- With menu:

`$ docker run -it --rm -v $(pwd):/dl servufi/video-downloader`
- Without menu (best quality):

`$ docker run -it --rm -v $(pwd):/dl servufi/video-downloader <URL>`
- Without menu and target filesize 13MB:

`$ docker run -it --rm -v $(pwd):/dl servufi/video-downloader <URL> 13M`

`$(pwd)` is save directory (from where command is executed). You can replace that with your own path, but leave `:/dl` intact, which is path inside container where dl.sh writes files to ($SAVEDIR).