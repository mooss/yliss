#!/usr/bin/env bash

set -Ee
[ $# -eq 1 ]

image=felixjamet/yliss-tangle:0.2
if [ -z "$(docker images -q $image)" ]; then
    docker pull $image
fi

mkdir -p tangle
chmod 777 tangle
docker run --rm --volume "$PWD:/yliss" $image\
       emacs -nw -Q "/yliss/$1" --batch -l /yliss/script/tangle-utils.el -f yls/tangle 2>/dev/null
