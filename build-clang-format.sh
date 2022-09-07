#!/bin/bash

if [ -d src ]; then
	git -C src fetch
else
	git clone https://github.com/llvm/llvm-project.git src
fi

git -C src checkout llvmorg-15.0.0

mkdir build/
pushd build/

cmake -G Ninja -DLLVM_ENABLE_PROJECTS=clang -DCMAKE_BUILD_TYPE=MinSizeRel -DLLVM_TARGET_ARCH=x86_64 -DLLVM_DEFAULT_TARGET_TRIPLE=x86_64-linux-gnu ../src/llvm
cmake --build . --target clang-format
DESTDIR=$(realpath ../sysroot) cmake --build . --target install-clang-format-stripped

popd

mkdir sysroot/DEBIAN

cat <<EOF > sysroot/DEBIAN/control
Package: clang-format
#Version: 1:10.0-50~exp1
Version: 15.0.0-focal-flederwiesel1
Priority: optional
Section: universe/devel
Architecture: amd64
#Source: llvm-defaults (0.50~exp1)
Source: llvm-defaults (15.0.0)
#Origin: Ubuntu
Origin: flederwiesel
Maintainer: flederwiesel <flederwiesel@fra-flugplan.de>
#Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Original-Maintainer: LLVM Packaging Team <pkg-llvm-team@lists.alioth.debian.org>
Installed-Size: 2,5 MB
#Depends: clang-format-10 (>= 10~)
Depends:
Breaks: clang (<< 1:3.6-28)
#Replaces: clang (<< 1:3.6-28)
Replaces: clang (=1:10.0-50~exp1), clang(<=1:14), clang(<=14)
Download-Size: 815 kB
APT-Manual-Installed: yes
#APT-Sources: http://de.archive.ubuntu.com/ubuntu focal/universe amd64 Packages
Description: Tool to format C/C++/Obj-C code
 Clang-format is both a library and a stand-alone tool with the goal of
 automatically reformatting C++ sources files according to configurable
 style guides. To do so, clang-format uses Clang's Lexer to transform an
 input file into a token stream and then changes all the whitespace around
 those tokens. The goal is for clang-format to both serve both as a user
 tool (ideally with powerful IDE integrations) and part of other
 refactoring tools, e.g. to do a reformatting of all the lines changed
 during a renaming.
 .
 This is a dependency package providing the clang format tool.
EOF

dpkg-deb --root-owner-group --build sysroot .
