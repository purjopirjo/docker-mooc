```
docker run -d --rm --name secret-msg devopsdockeruh/simple-web-service:ubuntu
docker exec -it secret-msg sh -c "tail -n11 ./text.log"|grep -i "secret message"
Secret message is: 'You can find the source code here: https://github.com/docker-hy'
```