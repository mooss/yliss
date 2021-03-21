#!/usr/bin/env bash

usage="Usage: $0 urlbase archive format sentinel [noweb-style-arguments]"

if [ $# -ne 4 -a $# -ne 5 ]
then
    >&2 echo "$usage"
    exit 1
fi

nowebargs="$5"
# Transform noweb-style variables into bash variables.
# "lazy" way to handle optional parameters by overriding default values.
if [ -n "$nowebargs" ]
then
    # Iterating with null delimiter from https://stackoverflow.com/a/8677566.
    while IFS= read -r -d $'\0' declaration
    do
        declare "$declaration"
    done < <(printf "$nowebargs\x0" | sed -r\
                                          -e 's| :|\x0:|g'\
                                          -e 's|:([^ ]+) +|\1=|g')
    # This "printf | sed" transformation changes something like ":a 4 :b 8 15" to "a=4\0b=8 15".
fi

function defined() {
    [ -n "$1" ]
}

urlbase="$1"
archive="$2"
format="$3"
sentinel=$(readlink -f "$4") # Absolute path.
project_root="$PWD" # Implying this script is only called from the project root.
include="$project_root/include"
src="$project_root/src"

case "$format" in
    7z)
        function extract() {
            7z x "$1" >/dev/null
        }
        ;;

    zip)
        function extract() {
            unzip "$1" >/dev/null
        }
        ;;

    *)
        >&2 echo "Unsupported format \`$format\`."
        exit 2
esac

# Check for sentinel file, i.e. a file whose presence indicates that the project is already retrieved.
[ -e "$sentinel" ] && exit 0

filename="$archive.$format"
url="$urlbase/$filename"
tempdir=$(mktemp -d)

cd "$tempdir"
wget --quiet --show-progress "$url"
extract "$filename"

# No spaces in filenames.
if defined "$to_include"
then
    echo "$to_include" | xargs mv --target-directory "$include"
    echo "\`$to_include\` -> \`$include\`"
fi

if defined "$to_src"
then
    echo "$to_src" | xargs mv --target-directory "$src"
    echo "\`$to_src\` -> \`$src\`"
fi

cd "$project_root"
rm -fr "$tempdir"
echo

exit
