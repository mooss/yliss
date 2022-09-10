#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 submodule"
    exit 1
fi

repo=$1

if [[ -L $repo ]]; then
    echo "$repo is initialised as a link to $(readlink -f $repo)."
    exit 0
fi

if [[ -d $repo ]]; then
    if [[ -z "$(ls -A $repo)" ]]; then
        git submodule init $repo
        git submodule update $repo
    else
        echo "$repo is already initialised."
    fi
    exit 0
fi

echo "Failed to initialize $repo."
exit 2
