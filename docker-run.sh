#!/bin/bash

scriptdir=$(realpath $(dirname "${BASH_SOURCE[0]}"))

mkdir -p  "$scriptdir/build-clang-format"

docker run \
	--name build-clang-format \
	--hostname builder \
	--volume "$scriptdir/build-clang-format":/home/bob/build-clang-format \
	--env TERM=$TERM \
	--interactive \
	--tty \
	--workdir=/home/bob/build-clang-format \
	$@ \
	build-clang-format:latest
