#!/bin/bash

# 確保輸出目錄存在
mkdir -p processed_results

echo "------------------------------------------------"
echo "Edge Impulse 資料處理工具箱"
echo "1: 上傳單一標籤 (Upload Data)"
echo "2: 批次資料夾上傳 (Batch Upload)"
echo "3: 辨識圖片 (run inference)"
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
        read -e -p "Enter input image directory: " IMG_DIR
        bash scripts/run_inference.sh "$IMG_DIR"
        ;;
    *)
        echo "無效選項，退出中..."
        exit 1
        ;;
esac
