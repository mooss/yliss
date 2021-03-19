#!/usr/bin/env bash

file=glm-0.9.9.8.7z
url=https://github.com/g-truc/glm/releases/download/0.9.9.8

[ ! -f "$file" ] || exit 0
wget "$url/$file"
7z x "$file"
rm "$file"
