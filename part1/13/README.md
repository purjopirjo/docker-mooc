```
cp -r ../12/material-applications/example-backend .
docker build . -t exer13
docker run -it --rm -p 8080:8080 exer13
```