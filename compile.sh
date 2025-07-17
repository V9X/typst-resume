#!/bin/bash

FIRST_FILE=$(set -- *.yaml; echo "$1")
if [ -z "$1" ] && [ "$FIRST_FILE" = "*.yaml" ]; then
    echo "Error: No .yaml files found in the current directory." >&2 
    exit 1
fi

INPUT_PATH=$(realpath "${1:-${FIRST_FILE}}")
OUTPUT_PATH=$(realpath "${2:-${INPUT_PATH%.*}.pdf}")
SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" &> /dev/null && pwd)"

typst compile \
    --root / \
    --creation-timestamp 1112470620 \
    --ignore-system-fonts \
    --font-path "$SCRIPT_DIR/src/assets" \
    --input "loc=$INPUT_PATH" \
    "$SCRIPT_DIR/src/resume.typ" \
    "$OUTPUT_PATH"