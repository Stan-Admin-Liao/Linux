#!/bin/bash

while true; do
	echo "------------------------------------------------"
	echo "Edge Impulse 資料處理工具箱"
	echo "1: 檢查環境"
	echo "2: 上傳圖片"
	echo "3: 批次資料夾上傳 "
	echo "4: retrain"
	echo "5: 辨識圖片"
	echo "6: 退出腳本"
	echo "------------------------------------------------"
	read -p "請選擇指令 [1-6]: " choice

	case "$choice" in
        1)
            scripts/check_env.sh 
            ;;
        2)
            read -p "請輸入標籤名稱 (Label): " LABEL
            read -e -p "請輸入圖片檔案路徑: " FILES
            bash scripts/upload_data.sh "$LABEL" "$FILES"
            ;;
        3)
            read -e -p "請輸入資料根目錄路徑: " DATA_DIR
            if [ -d "$DATA_DIR" ]; then
                bash scripts/batch_upload.sh "$DATA_DIR"
            else
                echo "❌ 錯誤：找不到目錄 $DATA_DIR"
            fi
            ;;
        4)
            bash scripts/retrain.sh
            ;;
        5)
            read -e -p "請輸入待辨識圖片目錄: " IMG_DIR
            if [ -d "$IMG_DIR" ]; then
                mkdir -p processed_results
                bash scripts/run_inference.sh "$IMG_DIR"
                echo "✅ 辨識完成，結果已儲存至 processed_results"
            else
                echo "❌ 錯誤：找不到目錄 $IMG_DIR"
            fi
            ;;
        6)
            echo "退出..."
            break # 退出 while 迴圈
            ;;
        *)
            echo "⚠️ 無效的選項，請輸入 1 到 6 之間的數字。"
            ;;
         esac
         echo ""
         sleep 2
done
