#!/bin/bash

#########################################################################
### DOCKER ALIASES
#########################################################################
docker-arm() {
  export DOCKER_DEFAULT_PLATFORM=linux/arm64
}
docker-intel() {
  export DOCKER_DEFAULT_PLATFORM=linux/amd64
}
docker-noplatform() {
  unset DOCKER_DEFAULT_PLATFORM
}

#########################################################################
### DOCKER DAEMON
#########################################################################
docker-start() {
  open -a Docker
}
docker-stop() {
  killall -9 Docker
}

docker-stop-all() {
  docker kill "$(docker ps -q)"
}

docker-teardown-all() {
  docker rm "$(docker ps -a -q)"
}
