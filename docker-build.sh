#!/bin/bash

docker build --tag=build-clang-format --file=- . < <(
	sed "s/%uid%/$(id --user)/g; s/%gid%/$(id --group)/g" Dockerfile
)
