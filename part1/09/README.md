```
mkdir logs
touch logs/text.log
docker run -it --rm -v "$(pwd)/logs/text.log:/usr/src/app/text.log:rw" devopsdockeruh/simple-web-service
Starting log output
Wrote text to /usr/src/app/text.
```