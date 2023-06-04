```
cp -r ../../part1/12/material-applications/express-app .
cp express-app-to-docker.yml ../../.github/workflows/.
git push origin main
docker compose up -d
docker compose down

```
Config/workflow: express-app-to-docker.yml

Repository: [https://hub.docker.com/r/servufi/mooc-express-app](https://hub.docker.com/r/servufi/mooc-express-app)