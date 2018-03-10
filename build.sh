#!/bin/bash
cd package
git clone https://github.com/lshw/minivtun-openwrt
cd ..
./scripts/feeds update
make packages/libopenssl/compile V=99
make packages/minivtun-openwrt/compile V=99
find bin -name "minivtun.ipk" -exec ls -l {} \;
