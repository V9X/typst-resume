#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" &> /dev/null && pwd)"

INPUT_PATH=$(realpath "${1:-"./example.yaml"}")
INPUT_DIR=$(dirname "$INPUT_PATH")
INPUT_FILE=$(basename "$INPUT_PATH")

OUTPUT_PATH=${2:-"$INPUT_DIR/${INPUT_FILE%.*}.pdf"}

ROOT_PATH=$INPUT_DIR
FILE_PATH="/$INPUT_FILE"

if [[ $INPUT_PATH == $SCRIPT_DIR* ]]; then
    ROOT_PATH=$SCRIPT_DIR
    FILE_PATH="${INPUT_PATH:${#SCRIPT_DIR}}"
fi

typst compile \
    --root "$ROOT_PATH" \
    --ignore-system-fonts \
    --font-path "./assets" \
    --input "loc=$FILE_PATH" \
    "$SCRIPT_DIR/src/resume.typ" \
    "$OUTPUT_PATH"