#!/bin/bash

docker build \
  --build-arg FUNCTION_FOLDER=functions/generic \
  -f shared/Dockerfile \
  -t base_processor \
  .

docker run --rm -it \
  --entrypoint="" \
  -v "$PWD"/shared:/var/task \
  -w /var/task \
  base_processor bundle install
