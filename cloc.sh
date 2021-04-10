#!/bin/bash

declare -a directories=(
    "01-ssr"
    "02-ssr-with-progressive-enhancement"
    "03-ssr-with-partial-dom-updates"
    "04-ssr-with-partial-csr"
    "05-csr-with-spa"
    "06-ssr-with-rehydration"
)

for directory in "${directories[@]}"
do
    cd $directory
    cloc ./src --exclude-ext=json,md --not-match-f=Dockerfile
    cd ..
done
