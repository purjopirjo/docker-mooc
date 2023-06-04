```
docker run -d -it --rm --name missing-dep ubuntu sh -c 'while true; do echo "Input website:"; read website; echo "Searching $website"; sleep 1; curl http://$website; done'
ddocker exec -it missing-dep sh -c 'apt-get update; apt-get install curl -y'
docker attach missing-dep
helsinki.fi
ctrl+p ctrl+q
docker rm --force missing-dep

# start container with 'curl' pre-installed:
docker run -d -it --rm --name missing-dep ubuntu sh -c 'apt-get -y update; apt-get -y install curl; while true; do echo "Input website:"; read website; echo "Searching $website"; sleep 1; curl http://$website; done'
```