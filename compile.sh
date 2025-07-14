#!/bin/bash

if [ $# = 1 ]; then
    typst watch --input loc=./templates/"$1" resume.typ ./output/"${1%.*}.pdf"
    exit;
fi

for path in ./templates/*.yaml; do
    filename=$(basename "$path")
    typst compile --input loc="$path" resume.typ ./output/"${filename%.*}".pdf
done