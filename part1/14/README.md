```
cp ../12/Dockerfile ./frontDockerfile
cp ../13/Dockerfile ./backDockerfile
nano frontDockerfile backDockerfile
cp -r ../12/material-applications/example-frontend .
cp -r ../12/material-applications/example-backend .
docker build . -t exer14front -f ./frontDockerfile
docker build . -t exer14back -f ./backDockerfile
docker run -it --rm --name='front14' -p 80:5000 exer14front
docker run -it --rm --name='backend14' -p 5001:5001 exer14back
```