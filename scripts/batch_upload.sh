#!/bin/bash
# batch_upload.sh - batch upload dir
set -e

DATA_DIR=$1

for label_dir in "$DATA_DIR"/*; do
LABEL=$(basename "$label_dir")
IMAGES=("$label_dir"/*.{jpg,jpeg,png,bmp})
./scripts/upload_data.sh "$LABEL" "${IMAGES[@]}"
done
