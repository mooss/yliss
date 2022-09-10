#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 submodule"
    exit 1
fi

repo="$1"

if [[ -L "$repo" ]]; then
    echo "$repo is initialised as a link to $(readlink -f $repo)."
    exit 0
fi

if [[ -d "$repo" ]]; then
    if [[ -s "$repo" ]]; then
        echo "$repo is already initialised."
    else
        git submodule init "$repo"
        git submodule update "$repo"
    fi
    exit 0
fi

echo "Failed to initialize $repo."
exit 2
