```
docker build . -f ./DockerfileBack -t userbackend2
docker build . -f ./DockerfileFront -t userfrontend2

docker image history userbackend2
...
docker image history userfrontend2
...

docker images
userbackend2    latest  c9253d77eae1    11 hours ago    703MB
userfrontend2   latest  d2d358935173    59 minutes ago  1.48GB


# Backend optimizations:
- first stage for building server executable only
- second stage to run executable in fresh alpine container
- Combined Dockerfile commands / minimal layers 
- Run as non-root user (uid 1000)
- Clear cache in container after runned commands

docker build . -f ./DockerfileBack -t userbackend3 --no-cache --progress plain
docker run -it --rm --name back -p 8080:8080 userbackend3

# Frontend optimizations:
- first stage for building static files only
- second stage to serve static files only without node_modules in fresh node alpine container
- Combined Dockerfile commands / minimal layers 
- Run as non-root user (uid 1000)
- Clear cache in container after runned commands

docker build . -f ./DockerfileFront -t userfrontend3 --no-cache --progress plain
docker run -it --rm --name front -p 80:5000 userfrontend3

docker images
userbackend3    latest 43679d5c2a82    About a minute ago   26.4MB
userfrontend3   latest  bc92b9c2ff6c    8 minutes ago   129MB


Results after size optimizations:
- back  from 703MB to 26.4MB
- front from 1.48GB to 129MB
```