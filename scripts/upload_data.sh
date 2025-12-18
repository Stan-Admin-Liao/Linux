#!/bin/bash
# upload_data.sh - 統一的 Edge Impulse 數據上傳腳本
# 功能: 根據參數上傳文件到 training, test, 或 split 類別。
# 依賴: edge-impulse-uploader CLI (npm install -g edge-impulse-cli)
# 環境變數: EI_API_KEY 必須設定

set -e # 遇到錯誤立即停止

# --- 顏色與日誌函式定義 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}
log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}
log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}
# ----------------------------


LOG_DIR="logs"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")



# --- 預設值與變數設定 ---
LABEL=""
FILES=()

# 函數來顯示使用說明
show_usage() {
    log_info "Edge Impulse 數據上傳工具 (upload_data.sh)"
    echo "---------------------------------------------------------"
    echo "使用方法: $0 [-c CATEGORY] <LABEL> <FILES...>"
    echo "用於自動上傳數據到 Edge Impulse 專案的訓練或測試集。"
    echo ""
    echo "選項:"
    echo "  -c, --category <CATEGORY>  設定數據的目標類型。選項:"
    echo "                             - training (預設): 上傳到訓練數據集。"
    echo "                             - test: 上傳到測試數據集。"
    echo "                             - split: 上傳後按比例 (通常 80/20) 自動分配到訓練/測試集。"
    echo ""
    echo "參數:"
    echo "  <LABEL>                    數據的標籤/類別名稱 (例如: coffee, motor_running)。"
    echo "  <FILES...>                 一個或多個要上傳的文件路徑 (支援萬用字元，例如: *.jpg, *.wav)。"
    echo ""
    echo "範例:"
    echo "  1. 基本上傳 (訓練集): $0 coffee data/images/coffee*.jpg"
    echo "  2. 測試集上傳: $0 -c test lamp data/images/lamp1.jpg"
    echo "  3. 自動分配比例: $0 -c split noise data/audio/noise_*.wav"
    echo "---------------------------------------------------------"
    exit 0 # 呼叫說明後成功退出
}

# --- 檢查 API Key ---
if [ -z "$EI_API_KEY" ]; then
    log_error "環境變數 EI_API_KEY 未設定。"
    echo "請確認您已執行: export EI_API_KEY='<您的 API Key>'"
    exit 1
fi

# --- 參數解析 ---
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -t|-test)
            if [ -z "$2" ]; then
                log_error "-t lable files"
                exit 1
            fi
            LABEL="$2"
            FILES="$3"
            LOG_FILE="$LOG_DIR/upload_${LABEL}_${TIMESTAMP}.txt"
	    edge-impulse-uploader --api-key $EI_API_KEY --category testing --label $LABEL "${FILES[@]}" | tee $LOG_FILE
            break
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *) # 處理 LABEL 和 FILES
            if [ -z "$LABEL" ]; then
                LABEL="$1"
            else
                # 將剩下的所有參數視為文件列表
                FILES+=("$1")
                LOG_FILE="$LOG_DIR/upload_${LABEL}_${TIMESTAMP}.txt"
                edge-impulse-uploader --api-key $EI_API_KEY --category "training" --label "$LABEL" "${FILES[@]}" | tee $LOG_FILE
            fi
            
            shift
            ;;
    esac
done







