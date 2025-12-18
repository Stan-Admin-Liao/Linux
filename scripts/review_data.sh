#!/bin/bash
# review_data.sh -check picture quality
for label_dir in "$DATA_DIR"/*; do
LABEL=$(basename "$label_dir")
COUNT=$(find "$label_dir" -type f \( -name "*.jpg" -o -name "*.png" \) | wc -l)
SIZES=$(identify -format "%wx%h\n" "$label_dir"/*.jpg | sort | uniq -c)
echo "LABEL : $LABEL"
echo "PICTURE NUM : $COUNT"
echo "PICTURE SIZE :"
echo "$SIZES"
done
