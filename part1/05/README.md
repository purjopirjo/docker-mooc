```
docker pull devopsdockeruh/simple-web-service:alpine
docker images |grep 'devopsdockeruh/simple-web-service'
devopsdockeruh/simple-web-service   ubuntu    4e3362e907d5   2 years ago   83MB
devopsdockeruh/simple-web-service   alpine    fd312adc88e0   2 years ago   15.7MB
docker run -d -it --rm --name exer1.5 devopsdockeruh/simple-web-service:alpine
docker exec -it exer1.5 sh
tail -n20 ./text.log
Secret message is: 'You can find the source code here: https://github.com/docker-hy'
ctrl+p, ctrl+q
docker stop exer1.5
```