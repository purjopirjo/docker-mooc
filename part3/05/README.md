```
docker build . -f ./DockerfileBack -t userbackend
docker build . -f ./DockerfileFront -t userfrontend
docker run -it --rm --name back -p 8080:8080 userbackend
docker run -it --rm --name front -p 80:5000 userfrontend

docker exec -it back sh       
/usr/src/app $ ps aux
PID   USER     TIME  COMMAND 
    1 gouser    0:00 ./server
   12 gouser    0:00 sh      
   18 gouser    0:00 ps aux

docker exec -it front sh
$ ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
nodeuser     1  0.2  0.0   2480   580 pts/0    Ss+  06:20   0:00 /bin/sh -c serve -s -l 5000 build
nodeuser     8  5.2  0.3 11252120 70112 pts/0  Sl+  06:20   0:00 node /usr/local/bin/serve -s -l 5000 build
nodeuser    21  1.0  0.0   2480   580 pts/1    Ss   06:20   0:00 sh
nodeuser    27  0.0  0.0   6756  2832 pts/1    R+   06:20   0:00 ps aux
```