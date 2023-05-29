# video-downloader

### Features

- Downloads audio/video URLs using yt-dlp ( [debian](https://tracker.debian.org/pkg/yt-dlp "debian") / [github](https://github.com/yt-dlp/yt-dlp "github") )
- Takes filesize limit as argument, and if necessary tries to encode closer to desired filesize (ffmpeg)
- Stores files in .mp4 format

### Installation
- Install Docker then pull image:

`$ docker pull servufi/video-downloader:latest`

### Usage
- With menu:
`$ docker run -it --rm -v $(pwd):/dl servufi/video-downloader`
- Without menu (best quality):
`$ docker run -it --rm -v $(pwd):/dl servufi/video-downloader <URL>`
- Without menu and target filesize 13MB:
`$ docker run -it --rm -v $(pwd):/dl servufi/video-downloader <URL> 13M`

`$(pwd)` is save directory, from where commands are executed. You can replace that with your own full path, but leave `:/dl` intact, which is ENV path ($SAVEDIR) inside container what Bash script uses.
