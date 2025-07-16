#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" &> /dev/null && pwd)"

INPUT_PATH=$(realpath "${1:-"./example.yaml"}")
OUTPUT_PATH=$(realpath "${2:-${INPUT_PATH%.*}.pdf}")

typst compile \
    --root / \
    --creation-timestamp 1112470620 \
    --ignore-system-fonts \
    --font-path "./assets" \
    --input "loc=$INPUT_PATH" \
    "$SCRIPT_DIR/src/resume.typ" \
    "$OUTPUT_PATH"