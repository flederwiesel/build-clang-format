FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get upgrade

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install --yes \
        build-essential \
        bzip2 \
        cmake \
        git \
        grep \
        gzip \
        make \
        ninja-build \
        python3 \
        sed \
        sudo \
        tar \
        unzip \
        zip \
        zlib1g-dev

RUN groupadd --gid %gid% bob
RUN useradd --uid %uid% --gid %gid% --groups sudo --home /home/bob --create-home bob
RUN echo "bob ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER bob

RUN mkdir /home/bob/build-clang-format

COPY build-clang-format.sh /home/bob

ENTRYPOINT ["/home/bob/build-clang-format.sh"]
