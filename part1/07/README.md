```
docker build . -t curler
[+] Building 41.5s (10/10) FINISHED
 => [internal] load build definition from Dockerfile                   0.0s 
 => => transferring dockerfile: 547B                                   0.0s 
 => [internal] load .dockerignore                                      0.0s 
 => => transferring context: 2B                                        0.0s 
 => [internal] load metadata for docker.io/library/ubuntu:20.04        1.2s 
 => [auth] library/ubuntu:pull token for registry-1.docker.io          0.0s 
 => [1/4] FROM docker.io/library/ubuntu:20.04@sha256:24a0df437301598d  0.0s 
 => [internal] load build context                                      0.0s 
 => => transferring context: 168B                                      0.0s 
 => CACHED [2/4] WORKDIR /usr/src/app                                  0.0s 
 => [3/4] COPY search_website.sh .                                     0.0s 
 => [4/4] RUN chmod +x search_website.sh; apt-get -y update; apt-get  39.8s 
 => exporting to image                                                 0.3s 
 => => exporting layers                                                0.3s 
 => => writing image sha256:811d0f90f25a9ca0f19ef0547d18d97b04ec1d509  0.0s 
 => => naming to docker.io/library/curler
docker run -it curler
```