# build-clang-format

Build clang-format in a docker container.

```
./docker-build.sh &&
./docker-run.sh --rm
```

... should build a Debian package targeted for Ubuntu-20.04
in `$PWD/build-clang-format`.

For debugging or otherwise peeking into the docker, run
```
./docker-run.sh --entrypoint /bin/bash
```
