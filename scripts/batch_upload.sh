#!/bin/bash
# batch_upload.sh
set -e

# --- 顏色 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()    { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }


DATA_DIR=$1
FAILED=1

if [ -z "$DATA_DIR" ]; then
    log_error "須輸入路徑"
    log_info "使用方法: $0 <資料夾路徑>"
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
            log_info   "標籤: [$LABEL]"
            log_info   "檔案數量: $COUNT 筆"
            ./scripts/upload_data.sh "$LABEL" "${FILE_ARRAY[@]}"
        fi
        FAILED=0
    fi
    
done

echo "------------------------------------------------"
if [ $FAILED -eq 0 ]; then
    log_info "所有資料處理完畢。"
    exit 0
else
    log_error "資料處理失敗。"
    exit 1
fi

exit 0
