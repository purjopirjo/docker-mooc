#!/bin/bash

# Variables
repo_url="$1"
docker_repo="$2"
image_name=$(basename "$docker_repo")
tag="latest"

# Check if the Docker socket is accessible
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker socket is not accessible. Please make sure it is correctly bound."
    echo "Run: docker run --rm -e DOCKER_USER=user -e DOCKER_PW='password_here' -v /var/run/docker.sock:/var/run/docker.sock builder gituser/repo dockeruser/repo"
    exit 1
fi


# docker login
echo $DOCKER_PW | docker login --username $DOCKER_USER --password-stdin

# check args are set
if [[ ! -n "$repo_url" ]]; then
    echo "Error: missing git_repo and docker_repo arguments, ->gituser/repo ->dockeruser/repo"
    exit 1
fi
if [[ ! -n "$docker_repo" ]]; then
    echo "Error: missing docker_repo argument, gituser/repo ->dockeruser/repo"
    exit 1
fi

# Check if docker_repo ends with :tag and set as tag if found
count_colons=$(echo "$docker_repo" | tr -cd ':' | wc -c)
if [[ $count_colons -gt 0 ]]; then
  # Extract the tag after the last colon
  tag="${docker_repo##*:}"
  # Check if multiple colons are found
  if [[ $count_colons -gt 1 ]]; then
    echo "Invalid docker tag name: $tag"
    exit 1
  fi
fi
count_d_slashes=$(echo "$docker_repo" | tr -cd '/' | wc -c)
if [[ $count_d_slashes -eq 0 || $count_d_slashes -gt 1 ]]; then
  echo "Error: Bad docker repo name: $docker_repo"
  echo "Ex: user/repo or user/repo:$tag"
  exit 1
fi

# Check if repo_url contains a valid format
count_slashes=$(echo "$repo_url" | tr -cd '/' | wc -c)
if [ $count_slashes -eq 0 ]; then
  # Format: username
  echo "Error: Bad git repo name: $repo_url"
  exit 1
elif [ $count_slashes -eq 1 ]; then
  # Format: username/reponame
  repo_url="https://github.com/$repo_url.git"
elif [[ $count_slashes -eq 4 && $repo_url =~ ^(https?://).*$ && $repo_url != *".git" ]]; then
  # Format: https://github.com/username/reponame
  repo_url="$repo_url.git"
elif [[ $count_slashes -eq 4 && $repo_url =~ ^(https?://).*$ && $repo_url == *".git" ]]; then
  # Format: https://github.com/username/reponame.git
  repo_url=$repo_url
elif [[ $count_slashes -gt 4 && $repo_url =~ ^(https?://).*$ && $repo_url != *".git" ]]; then
  # Format: https://github.com/username/reponame/sub/directory
  username=$(echo "$repo_url" | awk -F'/' '{print $4}')
  reponame=$(echo "$repo_url" | awk -F'/' '{print $5}')
  subdirectory=$(echo "$repo_url" | awk -F"$username/$reponame/" '{print $2}')
  subdirectory=${subdirectory%/} # trim last / out
  repo_url="https://github.com/$username/$reponame.git"
elif [[ $count_slashes -gt 1 && ! $repo_url =~ ^(https?://).*$ && $repo_url != *".git" ]]; then
  # Format: username/reponame/sub
  username=$(echo "$repo_url" | awk -F'/' '{print $1}')
  reponame=$(echo "$repo_url" | awk -F'/' '{print $2}')
  subdirectory=$(echo "$repo_url" | awk -F"$username/$reponame/" '{print $2}')
  subdirectory=${subdirectory%/} # trim last / out
  repo_url="https://github.com/$username/$reponame.git"
else
  echo "Error: Bad git repo name: $repo_url"
  exit 1
fi

# check if repo_url http 200
repo_exists=$(curl -sL --head "$repo_url" | grep -E "^HTTP.* 200")
if ! [[ -n $repo_exists ]]; then
  echo "Error: $repo_url returned $repo_exists"
  exit 1
fi

# refresh reponame
reponame=$(echo "$repo_url" | awk -F'/' '{sub(/\.git$/, "", $5); print $5}')
# get branch name
branchname=$(git ls-remote --symref "$repo_url" | awk '/refs\/heads/ && !/HEAD/ {sub(/.*\//, "", $2); print $2}')
# Create a temporary directory to clone into
temp_dir=$(mktemp -d)

# if contains a subdirectory
if [[ -n "$subdirectory" && -n "$reponame" ]]; then
  # remove tree/branch/ from start
  subdirectory=$(echo "$subdirectory" | awk -F"tree/$branchname/" '{print $2}')
  git init "$temp_dir"
  cd "$temp_dir"
  git remote add origin "https://github.com/$username/$reponame"
  git config core.sparsecheckout true
  echo "$subdirectory" >> .git/info/sparse-checkout
  git pull --depth=1 origin $branchname
  cd "$subdirectory"
else
  # Clone the repository
  cd "$temp_dir"
  git clone "$repo_url"
  cd "$reponame"
fi

# check if Dockerfile exists
if [[ ! -f "Dockerfile" ]]; then
  echo "Error: Did not find Dockerfile in: $(pwd)"
  exit 1
fi


# Build the Docker image
docker build -t "$image_name":"$tag" .

# Tag the Docker image
docker tag "$image_name":"$tag" "$docker_repo":"$tag"

# Push the Docker image to Docker Hub using Docker client
docker push "$docker_repo":"$tag"