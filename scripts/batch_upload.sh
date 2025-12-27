#!/bin/bash
# batch_upload.sh
set -e

DATA_DIR=$1

if [ -z "$DATA_DIR" ]; then
    echo "使用方法: $0 <資料夾路徑>"
    exit 1
fi

for label_dir in "$DATA_DIR"/*; do
    if [ -d "$label_dir" ]; then
        LABEL=$(basename "$label_dir")
        

        FILES=$(find "$label_dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" \))


        if [ -n "$FILES" ]; then
            FILE_ARRAY=($FILES)
            COUNT=${#FILE_ARRAY[@]}
            
            echo "------------------------------------------------"
            echo "標籤: [$LABEL]"
            echo "檔案數量: $COUNT 筆"
            ./scripts/upload_data.sh "$LABEL" "${FILE_ARRAY[@]}"
        fi
    fi
done

echo "------------------------------------------------"
echo "所有訓練集資料處理完畢。"
