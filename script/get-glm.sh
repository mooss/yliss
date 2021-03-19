#!/usr/bin/env bash

destination="$PWD/include/glm"
[ ! -d "$destination" ] || exit 0

archive=glm-0.9.9.8.7z
url_base=https://github.com/g-truc/glm/releases/download/0.9.9.8
tempdir=$(mktemp -d)

cd "$tempdir"
wget "$url_base/$archive"
7z x "$archive"
mv glm/glm "$destination"

cd -
rm -fr "$archive" "$tempdir"
