#!/bin/bash
# --- 顏色 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()    { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }


while true; do
	echo "------------------------------------------------"
	echo "Edge Impulse 資料處理工具箱"
	echo "1: 檢查環境"
	echo "2: 上傳圖片"
	echo "3: 批次資料夾上傳 "
	echo "4: retrain"
	echo "5: 辨識圖片"
	echo "6: 批次上傳 + retrain"
	echo "7: 退出腳本"
	echo "------------------------------------------------"
	read -p "請選擇指令 [1-7]: " choice

	case "$choice" in
        1)
            scripts/check_env.sh 
            ;;
        2)
            read -p "輸入類別 (category):" c
            read -p "請輸入標籤名稱 (Label): " LABEL
            read -e -p "請輸入圖片檔案路徑: " FILES
            case "$c" in
            train|training)
            	bash scripts/upload_data.sh "--train" "$LABEL" "$FILES"
            	;;
            /test|testing)
            	bash scripts/upload_data.sh "--test" "$LABEL" "$FILES"
            	;;
            *)
                bash scripts/upload_data.sh "--test" "$LABEL" "$FILES"
                ;;
            esac
            ;;
        3)
            read -e -p "請輸入資料根目錄路徑: " DATA_DIR
            if [ -d "$DATA_DIR" ]; then
                bash scripts/batch_upload.sh "$DATA_DIR"
            else
                log_error "❌ 錯誤：找不到目錄 $DATA_DIR"
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
                log_info "✅ 辨識完成，結果已儲存至 processed_results"
            else
                log_error "❌ 錯誤：找不到目錄 $IMG_DIR"
            fi
            ;;
        6)
            read -p "請輸入標籤名稱 (Label): " LABEL
            read -e -p "請輸入圖片檔案路徑: " FILES
            bash scripts/upload_data.sh "$LABEL" "$FILES"
            sleep 3
            bash scripts/retrain.sh
            ;;
        7)
            echo "退出..."
            break 
            ;;
        *)
            log_error "⚠️ 無效的選項，請輸入 1 到 7 之間的數字。"
            ;;
         esac
         echo ""
         sleep 2
done
