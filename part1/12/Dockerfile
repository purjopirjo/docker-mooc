FROM node:16.20.0-bullseye
WORKDIR /home/node/app
COPY ./material-applications/example-frontend /home/node/app
RUN npm install .
RUN npm run build .
RUN npm install -g serve
CMD serve -s -l 5000 build
EXPOSE 5000