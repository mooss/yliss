#!/usr/bin/env bash
if ! [ -d  worgle ]
then
    git clone https://github.com/paulbatchelor/worgle
fi
cd worgle
make --no-print-directory
