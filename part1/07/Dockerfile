# Start from the alpine image
FROM ubuntu:20.04

# Use /usr/src/app as our workdir. The following instructions will be executed in this location.
WORKDIR /usr/src/app

# Copy the hello.sh file from this location to /usr/src/app/ creating /usr/src/app/search_website.sh.
COPY search_website.sh .

# Execute a command with `/bin/sh -c` prefix.
RUN chmod +x search_website.sh; apt-get -y update; apt-get -y install curl

# When running Docker run the command will be ./search_website.sh
CMD ./search_website.sh
