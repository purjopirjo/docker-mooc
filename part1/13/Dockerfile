FROM golang:1.16-bullseye
WORKDIR /usr/src/app
COPY ./example-backend ./
RUN go mod download && go mod verify
RUN go build
CMD ["./server"]
EXPOSE 8080