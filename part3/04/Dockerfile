FROM docker:git

RUN apk add --no-cache bash curl

COPY builder.sh /app/builder.sh

ENTRYPOINT ["/bin/bash", "/app/builder.sh"]