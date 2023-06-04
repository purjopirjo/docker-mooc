```
docker build -t builder .

wsl/unix:
docker run --rm -e DOCKER_USER=username -e DOCKER_PW='password_here' -v /var/run/docker.sock:/var/run/docker.sock builder mluukkai/express_app servufi/testing2
```