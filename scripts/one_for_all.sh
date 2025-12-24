#!/bin/bash

# 確保輸出目錄存在
mkdir -p processed_results

echo "------------------------------------------------"
echo "Edge Impulse 資料處理工具箱"
echo "1: 上傳單一標籤 (Upload Data)"
echo "2: 批次資料夾上傳 (Batch Upload)"
echo "3: 自動繪製標籤框 (Bounding Box Process)"
echo "------------------------------------------------"
read -p "請選擇指令 [1-3]: " command

case "$command" in
    1)
        read -p "Enter label: " LABEL
        read -e -p "Enter file/path: " FILES
        bash scripts/upload_data.sh "$LABEL" $FILES
        ;;
    2)
        read -e -p "Enter the root data directory: " DATA_DIR
        bash scripts/batch_upload.sh "$DATA_DIR"
        ;;
    3)
        read -p "Enter label name: " LABEL
        read -e -p "Enter input image directory: " IMG_DIR
        python3 scripts/bounding_box.py "$LABEL" "$IMG_DIR"
        ;;
    *)
        echo "無效選項，退出中..."
        exit 1
        ;;
esac
