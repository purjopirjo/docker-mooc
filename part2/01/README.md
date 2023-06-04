```
touch text.log
docker compose up
[+] Running 1/0
 ✔ Container web-text-log  Created                                                                                                                                                   0.0s 
Attaching to web-text-log
web-text-log  | Starting log output
web-text-log  | Wrote text to /usr/src/app/text.log
web-text-log  | Wrote text to /usr/src/app/text.log

docker container ls -a
docker container rm web-text-log
```